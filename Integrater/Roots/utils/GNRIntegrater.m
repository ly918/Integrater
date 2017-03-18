//
//  GNRTaskManager.m
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRIntegrater.h"


@interface GNRIntegrater ()
@property (nonatomic, copy)NSString * name;//执行者名称
@property (nonatomic, strong)NSMutableDictionary * taskGroup;
@property (nonatomic, strong)dispatch_queue_t taskQueue;//任务异步队列

@property (nonatomic, strong)GNRTaskInfo * taskInfo;
@property (nonatomic, strong)GNRArchiveTask * archiveTask;
@property (nonatomic, strong)GNRArchiveTask * ipaTask;

@end

@implementation GNRIntegrater

//getter
- (NSMutableDictionary *)taskGroup{
    if (!_taskGroup) {
        _taskGroup = [NSMutableDictionary dictionary];
    }
    return _taskGroup;
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

- (void)setTaskInfo:(GNRTaskInfo *)taskInfo{
    _taskInfo = taskInfo;
    if (taskInfo) {
        //1 archive
        NSString * archivePath = [NSString stringWithFormat:@"%@/archive_iOS",taskInfo.archivePath];
        NSString * ipaPath = [NSString stringWithFormat:@"%@/ipa_iOS",taskInfo.ipaPath];
        NSString * importIPAPath = [NSString stringWithFormat:@"%@.xcarchive",archivePath];

        self.archiveTask.scriptFormat = [NSString stringWithFormat:taskInfo.projectType==GNRProjectType_Proj?k_ScripFromat_Project:k_ScripFromat_Workspace,
                                         taskInfo.projectPath,
                                         taskInfo.schemeName,
                                         archivePath,
                                         taskInfo.releaseStr];
        //2 ipa
        self.ipaTask.scriptFormat = [NSString stringWithFormat:k_ScriptFormat_IPA,
                                     importIPAPath,
                                     ipaPath];
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

- (instancetype)initWithName:(NSString *)name{
    if (self = [super init]) {
        _taskQueue = dispatch_queue_create([name cStringUsingEncoding:NSUTF8StringEncoding], DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


//TODO: - 总任务
- (GNRIntegrater *)runTaskInfo:(GNRTaskInfo *)taskInfo completion:(void(^)(BOOL,NSString *,GNRError *))completion{
    self.taskInfo = taskInfo;
    //archive task
    WEAK_SELF;
    [[self runArchiveTask:wself.archiveTask completion:^(BOOL state,GNRError * error) {//archive
        if (completion) {
            completion(state,state?@"编译成功正在导出ipa包......":error.description,error);
        }
    }] runArchiveTask:wself.ipaTask completion:^(BOOL state,GNRError * error) {//ipa
        if (completion) {
            completion(state,state?@"ipa 导出成功！":error.description,error);
        }
    }];
    return self;
}

/**
TODO: - 打包任务
 */
- (GNRIntegrater *)runArchiveTask:(GNRArchiveTask *)task completion:(void(^)(BOOL,GNRError *))completion{
    //1 加入任务组
    [self addToGroupWithTask:task];
    //2 异步执行队列
    WEAK_SELF;
    dispatch_async(wself.taskQueue, ^{
        //队列中
        //1 执行
        GNRError * error = [task runScrip];
        //2 删除此任务
        [wself removeFromGroupWithTask:task];
        //3 主线程回调
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(error?NO:YES,error);
        });
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
