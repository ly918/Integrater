//
//  GNRTaskManager.m
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRIntegrater.h"
#import "GNRUserNotificationCenter.h"


@interface GNRIntegrater ()

@property (nonatomic, strong)NSMutableDictionary * taskGroup;
@property (nonatomic, strong)dispatch_queue_t taskQueue;//任务异步队列

@property (nonatomic, strong)GNRArchiveTask * cleanTask;//clean
@property (nonatomic, strong)GNRArchiveTask * archiveTask;//build
@property (nonatomic, strong)GNRArchiveTask * ipaTask;//导出ipa
@property (nonatomic, strong)GNRUploadTask * uploadTask;//上传

@property (nonatomic, copy)GNRTaskRunStatusBlock taskBlock;

@end

@implementation GNRIntegrater

//getter
- (NSMutableDictionary *)taskGroup{
    if (!_taskGroup) {
        _taskGroup = [NSMutableDictionary dictionary];
    }
    return _taskGroup;
}

- (GNRArchiveTask *)cleanTask{
    if (!_cleanTask) {
        _cleanTask = [GNRArchiveTask new];
        _cleanTask.identifier = @"kArchiveTask_Clean";
    }
    return _cleanTask;
}

- (GNRArchiveTask *)archiveTask{
    if (!_archiveTask) {
        _archiveTask = [GNRArchiveTask new];
        _archiveTask.identifier = @"kArchiveTask_Archive";
    }
    return _archiveTask;
}

- (GNRArchiveTask *)ipaTask{
    if (!_ipaTask) {
        _ipaTask = [GNRArchiveTask new];
        _ipaTask.identifier = @"kArchiveTask_IPA";
    }
    return _ipaTask;
}

- (GNRUploadTask *)uploadTask{
    if (!_uploadTask) {
        _uploadTask = [GNRUploadTask new];
        _uploadTask.identifier = @"kUploadTask_IPA";
    }
    return _uploadTask;
}

- (void)setTaskInfo:(GNRTaskInfo *)taskInfo{
    _taskInfo = taskInfo;
    if (taskInfo) {
        //1 clean
        self.cleanTask.scriptFormat = [NSString stringWithFormat:taskInfo.projectType==GNRProjectType_Proj?k_ScripFromat_Project_Clean:k_ScripFromat_Workspace_Clean,
                                       taskInfo.projectType==GNRProjectType_Proj?taskInfo.projectPath:taskInfo.workspacePath,
                                       taskInfo.schemeName,
                                       taskInfo.configuration];
        
        //2 archive
        self.archiveTask.scriptFormat = [NSString stringWithFormat:taskInfo.projectType==GNRProjectType_Proj?k_ScripFromat_Project:k_ScripFromat_Workspace,
                                         taskInfo.projectType==GNRProjectType_Proj?taskInfo.projectPath:taskInfo.workspacePath,
                                         taskInfo.schemeName,
                                         taskInfo.archiveFileOutputPath,
                                         taskInfo.configuration];
        //3 ipa
        self.ipaTask.scriptFormat = [NSString stringWithFormat:k_ScriptFormat_IPA,
                                     taskInfo.archiveFileOutputPath,
                                     taskInfo.ipaFileOutputHeadPath,
                                     taskInfo.optionsPlistPath];
        
        //4 upload
        self.uploadTask.uploadUrl = taskInfo.uploadURL;
        self.uploadTask.appkey = taskInfo.appkey;
        self.uploadTask.userkey = taskInfo.userkey;
        self.uploadTask.importIPAPath = taskInfo.ipaFileOutputPath;
    }
}

/**
MARK: - 初始化方法
 */
- (instancetype)init{
    if (self = [super init]) {
        _taskQueue = dispatch_queue_create("", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (instancetype)initWithTaskInfo:(GNRTaskInfo *)taskInfo{
    if (self = [super init]) {
        _name = taskInfo.taskName;
        self.taskInfo = taskInfo;
        _taskQueue = dispatch_queue_create([taskInfo.taskName cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)taskStatusCallback:(GNRTaskRunStatusBlock)block{
    _taskBlock = nil;
    _taskBlock = [block copy];
    [self runTask];
}

//TODO: - 总任务
- (GNRIntegrater *)runTask{
    
    if (_running==YES) {//防止重复调用
        return self;
    }
    
    _running = YES;
    
    //状态对象
    GNRTaskStatus * taskStatus = [GNRTaskStatus new];
    self.taskStatus = taskStatus;
    
    taskStatus.taskStatus = GNRIntegraterTaskStatusCleaning;
    if (_taskBlock) {
        _taskBlock(taskStatus);
    }
    
    WEAK_SELF;
    //archive task
    [[[[self runArchiveTask:wself.cleanTask completion:^(BOOL state,NSDictionary * error) {//clean
        if (error) {
            [taskStatus configWithCode:GNRIntegraterTaskStatusCleanError userInfo:error];
        }else{
            taskStatus.taskStatus = GNRIntegraterTaskStatusBuilding;
            taskStatus.progress = 10;
        }
        if (_taskBlock) {
            _taskBlock(taskStatus);
        }
    }] runArchiveTask:wself.archiveTask completion:^(BOOL state,NSDictionary * error) {//archive
        if (error) {
            [taskStatus configWithCode:GNRIntegraterTaskStatusBuildError userInfo:error];
        }else{
            taskStatus.taskStatus = GNRIntegraterTaskStatusArchiving;
            taskStatus.progress = 20;
        }
        if (_taskBlock) {
            _taskBlock(taskStatus);
        }
    }] runArchiveTask:wself.ipaTask completion:^(BOOL state,NSDictionary * error) {//ipa
        if (error) {
            [taskStatus configWithCode:GNRIntegraterTaskStatusArchiveError userInfo:error];
        }else{
            taskStatus.taskStatus = GNRIntegraterTaskStatusUpdating;
            taskStatus.progress = 30;
        }
        if (_taskBlock) {
            _taskBlock(taskStatus);
        }
    }] uploadTask:wself.uploadTask completion:^(BOOL state, CGFloat progress, NSError * error) {
        if (error) {
            taskStatus.taskStatus = GNRIntegraterTaskStatusUpdateError;
            taskStatus.error = error;
        }else{
            if (state) {//上传成功
                taskStatus.showTime = [GNRUtil showDetailTime:[[NSDate date] timeIntervalSince1970]];
                taskStatus.taskStatus = GNRIntegraterTaskStatusSucceeded;
                taskStatus.progress = 30 + progress;//30 ~ 100
                _running = NO;
                _taskInfo.lastUploadTime = [GNRUtil standardTime:[NSDate date]];//最后上传时间
                [wself pushSucceededMsg];
            }else{//上传中
                taskStatus.taskStatus = GNRIntegraterTaskStatusUpdating;
                taskStatus.progress = 30 + progress;//30 ~ 100
                _running = YES;
            }
        }
        if (_taskBlock) {
            _taskBlock(taskStatus);
        }
    }];
    return self;
}

- (void)pushSucceededMsg{
    NSString * title = [NSString stringWithFormat:@"%@",_taskInfo.schemeName];
    NSString * msg = [NSString stringWithFormat:@"%@",_taskStatus.statusMsg];
    [[GNRUserNotificationCenter center] pushTitle:title msg:msg];
}

/**
TODO: - 打包任务
 */
- (GNRIntegrater *)runArchiveTask:(GNRArchiveTask *)task completion:(void(^)(BOOL,NSDictionary *))completion{
    //1 加入任务组
    [self addToGroupWithTask:task];
    //2 异步执行队列
    WEAK_SELF;
    dispatch_async(wself.taskQueue, ^{
        //队列中
        //1 执行
        NSDictionary * error = [task runScrip];
        //2 删除此任务
        [wself removeFromGroupWithTask:task];
        //3 主线程回调
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(error.allKeys.count?NO:YES,error.allKeys.count?error:nil);
            }
        });
    });
    return self;
}

/**
 TODO: - 上传
 */
- (GNRIntegrater *)uploadTask:(GNRUploadTask *)task completion:(void(^)(BOOL,CGFloat,NSError *))completion{
    //1 加入任务组
    [self addToGroupWithTask:task];
    //2 异步执行队列
    WEAK_SELF;
    dispatch_async(wself.taskQueue, ^{
        [task uploadIPAWithrogress:^(NSProgress * progress) {
            //3 上传进度
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(NO,100.f*(double)progress.completedUnitCount/(double)progress.totalUnitCount,nil);
                }
            });
        } completion:^(BOOL state, id responseObject, NSError * error) {
            //4 上传结束
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(state,100.f,state?nil:error);
                }
            });
        }];
    });
    return self;
}

/**
 增加到任务组
 */
- (void)addToGroupWithTask:(GNRBaseTask *)task{
    if (task&&task.identifier) {
        [self.taskGroup setValue:task forKey:task.identifier];
    }
}

/**
 从数组中任务组
 */
- (void)removeFromGroupWithTask:(GNRBaseTask *)task{
    if (task.identifier) {
        [self.taskGroup removeObjectForKey:task.identifier];
    }
}

@end
