//
//  GNRTaskManager.m
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRIntegrater.h"


@interface GNRIntegrater ()
@property (nonatomic, strong)NSMutableDictionary * taskGroup;
@property (nonatomic, strong)dispatch_queue_t taskQueue;//任务异步队列

@property (nonatomic, strong)GNRArchiveTask * cleanTask;//clean
@property (nonatomic, strong)GNRArchiveTask * archiveTask;//build
@property (nonatomic, strong)GNRArchiveTask * ipaTask;//导出ipa
@property (nonatomic, strong)GNRUploadTask * uploadTask;//上传
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
        NSString * archivePath = [NSString stringWithFormat:@"%@/archive_iOS",taskInfo.archivePath];
        NSString * importPath = [NSString stringWithFormat:@"%@.xcarchive",archivePath];

        //1 clean
        self.cleanTask.scriptFormat = [NSString stringWithFormat:taskInfo.projectType==GNRProjectType_Proj?k_ScripFromat_Project_Clean:k_ScripFromat_Workspace_Clean,
                                         taskInfo.projectPath,
                                       taskInfo.schemeName,
                                       taskInfo.buildEnvironment];
        
        //2 archive
        self.archiveTask.scriptFormat = [NSString stringWithFormat:taskInfo.projectType==GNRProjectType_Proj?k_ScripFromat_Project:k_ScripFromat_Workspace,
                                         taskInfo.projectPath,
                                         taskInfo.schemeName,
                                         archivePath,
                                         taskInfo.buildEnvironment];
        //3 ipa
        self.ipaTask.scriptFormat = [NSString stringWithFormat:k_ScriptFormat_IPA,
                                     importPath,
                                     taskInfo.ipaPath];
        //4 upload
        self.uploadTask.uploadUrl = k_Upload_URL_Pgyer;
        self.uploadTask.appkey = k_Appkey_Pgyer;
        self.uploadTask.userkey = k_UserKey_Pgyer;
        self.uploadTask.importIPAPath = [NSString stringWithFormat:@"%@/app.ipa",taskInfo.ipaPath];
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


//TODO: - 总任务
- (GNRIntegrater *)runTaskWithCompletion:(void(^)(GNRTaskStatus *))completion{
    
    //archive task
    GNRTaskStatus * taskStatus = [GNRTaskStatus new];
    taskStatus.taskStatus = GNRIntegraterTaskStatusCleaning;

    WEAK_SELF;
    
    [[[[self runArchiveTask:wself.cleanTask completion:^(BOOL state,NSDictionary * error) {//clean
        if (error) {
            [taskStatus configWithCode:GNRIntegraterTaskStatusCleanError userInfo:error];
        }else{
            taskStatus.taskStatus = GNRIntegraterTaskStatusBuilding;
        }
        if (completion) {
            completion(taskStatus);
        }
    }] runArchiveTask:wself.archiveTask completion:^(BOOL state,NSDictionary * error) {//archive
        if (error) {
            [taskStatus configWithCode:GNRIntegraterTaskStatusBuildError userInfo:error];
        }else{
            taskStatus.taskStatus = GNRIntegraterTaskStatusArchiving;
        }
        if (completion) {
            completion(taskStatus);
        }
    }] runArchiveTask:wself.ipaTask completion:^(BOOL state,NSDictionary * error) {//ipa
        if (error) {
            [taskStatus configWithCode:GNRIntegraterTaskStatusArchiveError userInfo:error];
        }else{
            taskStatus.taskStatus = GNRIntegraterTaskStatusUpdating;
        }
        if (completion) {
            completion(taskStatus);
        }
    }] uploadTask:wself.uploadTask completion:^(BOOL state, NSString * msg, NSDictionary * error) {
        if (error) {
            [taskStatus configWithCode:GNRIntegraterTaskStatusUpdateError userInfo:error];
        }else{
            taskStatus.taskStatus = GNRIntegraterTaskStatusSucceeded;
        }
        if (completion) {
            completion(taskStatus);
        }
    }];
    return self;
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
                completion(error.allKeys.count?NO:YES,error);
            }
        });
    });
    return self;
}

/**
 TODO: - 上传
 */
- (GNRIntegrater *)uploadTask:(GNRUploadTask *)task completion:(void(^)(BOOL,NSString *,NSDictionary *))completion{
    //1 加入任务组
    [self addToGroupWithTask:task];
    //2 异步执行队列
    WEAK_SELF;
    dispatch_async(wself.taskQueue, ^{
        [task uploadIPAWithrogress:^(NSProgress * progress) {
            //3 上传进度
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(NO,[NSString stringWithFormat:@"Updating %lldMB/%lldMB %.2f",progress.completedUnitCount/(1024*1024),progress.totalUnitCount/(1024*1024),(double)progress.completedUnitCount/(double)progress.totalUnitCount],nil);
                }
            });
        } completion:^(BOOL state, id responseObject, NSError * error) {
            //4 上传结束
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(state,state?@"Upload Succeeded!":error.description,error.userInfo);
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
