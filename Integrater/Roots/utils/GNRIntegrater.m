//
//  GNRTaskManager.m
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRIntegrater.h"
#import "GNRUserNotificationCenter.h"
#import "GNRTaskManager.h"

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
    _cleanTask = [GNRArchiveTask new];
    _cleanTask.identifier = @"kArchiveTask_Clean";
    _cleanTask.scriptFormat = [NSString stringWithFormat:_taskInfo.projectType==GNRProjectType_Proj?k_ScripFromat_Project_Clean:k_ScripFromat_Workspace_Clean,
                               _taskInfo.projectType==GNRProjectType_Proj?_taskInfo.projectPath:_taskInfo.workspacePath,
                               _taskInfo.schemeName,
                               _taskInfo.configuration];
    
    return _cleanTask;
}

- (GNRArchiveTask *)archiveTask{
    _archiveTask = [GNRArchiveTask new];
    _archiveTask.identifier = @"kArchiveTask_Archive";
    _archiveTask.scriptFormat = [NSString stringWithFormat:_taskInfo.projectType==GNRProjectType_Proj?k_ScripFromat_Project:k_ScripFromat_Workspace,
                                 _taskInfo.projectType==GNRProjectType_Proj?_taskInfo.projectPath:_taskInfo.workspacePath,
                                 _taskInfo.schemeName,
                                 _taskInfo.archiveFileOutputPath,
                                 _taskInfo.configuration];
    
    return _archiveTask;
}

- (GNRArchiveTask *)ipaTask{
    _ipaTask = [GNRArchiveTask new];
    _ipaTask.identifier = @"kArchiveTask_IPA";
    _ipaTask.scriptFormat = [NSString stringWithFormat:k_ScriptFormat_IPA,
                             _taskInfo.archiveFileOutputPath,
                             _taskInfo.ipaFileOutputHeadPath,
                             _taskInfo.optionsPlistPath];
    
    return _ipaTask;
}

- (GNRUploadTask *)uploadTask{
    _uploadTask = [GNRUploadTask new];
    _uploadTask.identifier = @"kUploadTask_IPA";
    _uploadTask.uploadUrl = _taskInfo.uploadURL;
    _uploadTask.appkey = _taskInfo.appkey;
    _uploadTask.userkey = _taskInfo.userkey;
    _uploadTask.importIPAPath = _taskInfo.ipaFileOutputPath;
    return _uploadTask;
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
        _taskStatus = [GNRTaskStatus new];
        self.taskInfo = taskInfo;
    }
    return self;
}

- (void)taskStatusCallback:(GNRTaskRunStatusBlock)block{
    _taskBlock = nil;
    _taskBlock = [block copy];
}

//队列任务
- (NSString *)newTaskQueueName{
    return [NSString stringWithFormat:@"%@_%@",self.taskInfo.taskName,[GNRUtil standardTimeForFile:[NSDate date]]];
}

//TODO: - 总任务
- (GNRIntegrater *)runTask{
    
    if (_running==YES) {//防止重复调用
        return self;
    }
    
    _running = YES;
    
    _taskQueue = nil;
    _taskQueue = dispatch_queue_create([self.newTaskQueueName cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
    
    //状态对象
    self.taskStatus.taskStatus = GNRIntegraterTaskStatusCleaning;
    if (_taskBlock) {
        _taskBlock(_taskStatus);
    }
    
    WEAK_SELF;
    [[[[self runArchiveTask:wself.cleanTask completion:^(BOOL state,NSDictionary * error) {//clean
        if (error) {
            [_taskStatus configWithCode:GNRIntegraterTaskStatusCleanError userInfo:error];
        }else{
            _taskStatus.taskStatus = GNRIntegraterTaskStatusBuilding;
            _taskStatus.progress = 10;
        }
        if (_taskBlock) {
            _taskBlock(_taskStatus);
        }
    }] runArchiveTask:wself.archiveTask completion:^(BOOL state,NSDictionary * error) {//archive
        if (error) {
            [_taskStatus configWithCode:GNRIntegraterTaskStatusBuildError userInfo:error];
        }else{
            _taskStatus.taskStatus = GNRIntegraterTaskStatusArchiving;
            _taskStatus.progress = 20;
        }
        if (_taskBlock) {
            _taskBlock(_taskStatus);
        }
    }] runArchiveTask:wself.ipaTask completion:^(BOOL state,NSDictionary * error) {//ipa
        if (error) {
            [_taskStatus configWithCode:GNRIntegraterTaskStatusArchiveError userInfo:error];
        }else{
            _taskStatus.taskStatus = GNRIntegraterTaskStatusUpdating;
            _taskStatus.progress = 30;
        }
        if (_taskBlock) {
            _taskBlock(_taskStatus);
        }
    }] uploadTask:wself.uploadTask completion:^(BOOL state, CGFloat progress, NSError * error) {
        if (error) {
            _taskStatus.taskStatus = GNRIntegraterTaskStatusUpdateError;
            _taskStatus.error = error;
        }else{
            if (state) {//上传成功
                _taskStatus.taskStatus = GNRIntegraterTaskStatusSucceeded;
                _taskStatus.progress = 30 + progress;//30 ~ 100
                _running = NO;
                [[GNRTaskManager manager] updateLastTimeWithTask:wself];
                [wself pushSucceededMsg];
            }else{//上传中
                _taskStatus.taskStatus = GNRIntegraterTaskStatusUpdating;
                _taskStatus.progress = 30 + progress;//30 ~ 100
                _running = YES;
            }
        }
        if (_taskBlock) {
            _taskBlock(_taskStatus);
        }
    }];
    return self;
}

- (GNRIntegrater *)stopTask{
    [self.taskGroup enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [(GNRBaseTask *)obj cancel];
    }];
    [self.taskGroup removeAllObjects];
    //删除所有任务
    _running = NO;
    _taskStatus.taskStatus = GNRIntegraterTaskStatusPrepared;
    _taskStatus.progress = 0;
    if (_taskBlock) {
        _taskBlock(_taskStatus);
    }
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
