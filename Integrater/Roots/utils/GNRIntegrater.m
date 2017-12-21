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
#import "GNRBlockOperation.h"

@interface GNRIntegrater ()

@property (nonatomic, strong)NSMutableDictionary * taskGroup;
@property (nonatomic, strong)NSOperationQueue * operationQueue;//任务队列
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
    GNRArchiveTask * _cleanTask = [GNRArchiveTask new];
    _cleanTask.identifier = [NSString stringWithFormat:@"%@%@",k_TaskID_ArchiveTask_Clean,self.taskInfo.schemeName];
    _cleanTask.scriptFormat = [NSString stringWithFormat:_taskInfo.projectType==GNRProjectType_Proj?k_ScripFromat_Project_Clean:k_ScripFromat_Workspace_Clean,
                               _taskInfo.projectType==GNRProjectType_Proj?_taskInfo.projectPath:_taskInfo.workspacePath,
                               _taskInfo.schemeName,
                               _taskInfo.configuration];
    
    return _cleanTask;
}

- (GNRArchiveTask *)archiveTask{
    GNRArchiveTask * _archiveTask = [GNRArchiveTask new];
    _archiveTask.identifier = [NSString stringWithFormat:@"%@%@",k_TaskID_ArchiveTask_Archive,self.taskInfo.schemeName];
    _archiveTask.scriptFormat = [NSString stringWithFormat:_taskInfo.projectType==GNRProjectType_Proj?k_ScripFromat_Project:k_ScripFromat_Workspace,
                                 _taskInfo.projectType==GNRProjectType_Proj?_taskInfo.projectPath:_taskInfo.workspacePath,
                                 _taskInfo.schemeName,
                                 _taskInfo.archiveFileOutputPath,
                                 _taskInfo.configuration];
    
    return _archiveTask;
}

- (GNRArchiveTask *)ipaTask{
    GNRArchiveTask * _ipaTask = [GNRArchiveTask new];
    _ipaTask.identifier = [NSString stringWithFormat:@"%@%@",k_TaskID_ArchiveTask_IPA,self.taskInfo.schemeName];
    _ipaTask.scriptFormat = [NSString stringWithFormat:k_ScriptFormat_IPA,
                             _taskInfo.archiveFileOutputPath,
                             _taskInfo.ipaFileOutputHeadPath,
                             _taskInfo.optionsPlistPath];
    
    return _ipaTask;
}

- (GNRUploadTask *)uploadTask{
    GNRUploadTask * _uploadTask = [GNRUploadTask new];
    _uploadTask.identifier = [NSString stringWithFormat:@"%@%@",k_TaskID_UploadTask_IPA,self.taskInfo.schemeName];
    _uploadTask.uploadUrl = _taskInfo.uploadURL;
    _uploadTask.appkey = self.taskInfo.submit_formal?_taskInfo.appkey_formal:_taskInfo.appkey;
    _uploadTask.userkey = self.taskInfo.submit_formal?_taskInfo.userkey_formal:_taskInfo.userkey;
    _uploadTask.importIPAPath = _taskInfo.ipaFileOutputPath;
    return _uploadTask;
}

- (NSOperationQueue *)newOperationQueue{
    NSOperationQueue * operationQueue = [[NSOperationQueue alloc]init];
    operationQueue.maxConcurrentOperationCount = 1;
    operationQueue.name = self.taskInfo.Id;
    return operationQueue;
}

/**
MARK: - 初始化方法
 */
- (instancetype)init{
    if (self = [super init]) {
    
    }
    return self;
}

- (instancetype)initWithTaskInfo:(GNRTaskInfo *)taskInfo{
    if (self = [super init]) {
        _name = taskInfo.Id;
        _taskStatus = [GNRTaskStatus new];
        self.taskInfo = taskInfo;
    }
    return self;
}

- (void)taskStatusCallback:(GNRTaskRunStatusBlock)block{
    _taskBlock = nil;
    _taskBlock = [block copy];
}

//TODO: - 总任务
- (GNRIntegrater *)runTask{

    if (_running==YES) {//防止重复调用
        return self;
    }
    
    [self clearQueue];
    _running = YES;
    _operationQueue = [self newOperationQueue];

    //状态对象
    self.taskStatus.taskStatus = GNRIntegraterTaskStatusCleaning;

    if (_taskBlock) {
        _taskBlock(_taskStatus);
    }
    
    
    WEAK_SELF;
    //clean
    [self runArchiveTask:wself.cleanTask completion:^(BOOL state,NSDictionary * error) {
        if (error) {
            [_taskStatus configWithCode:GNRIntegraterTaskStatusCleanError userInfo:error];
            [wself clearQueue];
        }else{
            _taskStatus.taskStatus = GNRIntegraterTaskStatusBuilding;
        }
        if (_taskBlock) {
            _taskBlock(_taskStatus);
        }
    }];
    
    //build
    [self runArchiveTask:wself.archiveTask completion:^(BOOL state,NSDictionary * error) {
        if (error) {
            [_taskStatus configWithCode:GNRIntegraterTaskStatusBuildError userInfo:error];
            [wself clearQueue];
        }else{
            _taskStatus.taskStatus = GNRIntegraterTaskStatusArchiving;
        }
        if (_taskBlock) {
            _taskBlock(_taskStatus);
        }
    }];
    
    //archive
    [self runArchiveTask:wself.ipaTask completion:^(BOOL state,NSDictionary * error) {
        if (error) {
            [_taskStatus configWithCode:GNRIntegraterTaskStatusArchiveError userInfo:error];
            [wself clearQueue];
        }else{
            _taskStatus.taskStatus = GNRIntegraterTaskStatusUpdating;
        }
        if (_taskBlock) {
            _taskBlock(_taskStatus);
        }
    }];
    
    //upload
    [self uploadTask:wself.uploadTask completion:^(BOOL state, CGFloat progress, id result, NSError * error) {
        if (error) {
            if(error.code == -999){//手动取消
                _taskStatus.taskStatus = GNRIntegraterTaskStatusPrepared;
            }else{
                _taskStatus.taskStatus = GNRIntegraterTaskStatusUpdateError;
                _taskStatus.error = error;
                [wself pushErrorMsg];
            }
            [wself clearQueue];
        }else{
            if (state) {//上传成功
                _taskStatus.taskStatus = GNRIntegraterTaskStatusSucceeded;
                _running = NO;
                wself.taskInfo.buildShortcutUrl = [self buildShortcutUrlWithResult:result];//获取短链
                [[GNRTaskManager manager] updateLastTimeWithTask:wself];
                [wself pushSucceededMsg];
            }else{//上传中
                _taskStatus.taskStatus = GNRIntegraterTaskStatusUpdating;
                _taskStatus.progress = 60 + progress;//60 ~ 100
            }
        }
        if (_taskBlock) {
            _taskBlock(_taskStatus);
        }
    }];
    return self;
}

//获取短链接
- (NSString *)buildShortcutUrlWithResult:(NSDictionary *)result{
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *data =[result objectForKey:@"data"];
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSString *buildShortcutUrl = [data objectForKey:@"appShortcutUrl"];
            return buildShortcutUrl;
        }
    }
    return nil;
}

- (void)clearQueue{
    [self.operationQueue.operations enumerateObjectsUsingBlock:^(__kindof GNRBlockOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
        [obj setStop:YES];
    }];
    [self.operationQueue cancelAllOperations];//取消所有任务
    _running = NO;
    GLog(@"%@ all operations %ld",self.name,self.operationQueue.operationCount);
    [self.taskGroup enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [(GNRBaseTask *)obj cancel];
    }];
    [self.taskGroup removeAllObjects];
}

- (GNRIntegrater *)stopTask{
    [self returnTaskStatus];
    [self clearQueue];
    return self;
}

//MARK: - 回归任务状态
- (void)returnTaskStatus{
    _running = NO;
    _taskStatus.taskStatus = GNRIntegraterTaskStatusPrepared;
    if (_taskBlock) {
        _taskBlock(_taskStatus);
    }
}

- (void)pushSucceededMsg{
    NSString * title = [NSString stringWithFormat:@"%@",_taskInfo.schemeName];
    NSString * msg = [NSString stringWithFormat:@"%@",_taskStatus.statusMsg];
    [[GNRUserNotificationCenter center] pushTitle:title msg:msg];
}

- (void)pushErrorMsg{
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
    __block GNRBlockOperation * operation = [GNRBlockOperation blockOperationWithBlock:^{
        if (operation.stop) {
            return;
        }
        //队列中
        //1 执行
        NSDictionary * error = [task runScrip];
        //2 删除此任务
        [wself removeFromGroupWithTask:task];
        //3 主线程回调
        if (operation.stop==NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion&&operation.stop==NO) {
                    completion(error.allKeys.count?NO:YES,error.allKeys.count?error:nil);
                }
                _running = error.allKeys.count?NO:YES;
                if (error.allKeys.count) {
                    [wself pushErrorMsg];
                }
            });
        }
    }];
    operation.name = task.identifier;
    [self.operationQueue addOperation:operation];
    return self;
}

/**
 TODO: - 上传
 */
- (GNRIntegrater *)uploadTask:(GNRUploadTask *)task completion:(void(^)(BOOL,CGFloat,id,NSError *))completion{
    //1 加入任务组
    [self addToGroupWithTask:task];
    //2 异步执行队列
    __block GNRBlockOperation * operation = [GNRBlockOperation blockOperationWithBlock:^{
        if (operation.stop) {
            return;
        }
        [task uploadIPAWithrogress:^(NSProgress * progress) {
            //3 上传进度
            if (operation.stop==NO) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(NO,100.f*(double)progress.completedUnitCount/(double)progress.totalUnitCount,nil,nil);
                    }
                });
            }

        } completion:^(BOOL state, id responseObject, NSError * error) {
            //4 上传结束
            if (operation.stop==NO) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(state,100.f,responseObject,state?nil:error);
                    }
                });
            }
        }];
    }];
    operation.name = task.identifier;
    [self.operationQueue addOperation:operation];
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
 从数组中移除任务组
 */
- (void)removeFromGroupWithTask:(GNRBaseTask *)task{
    if (task.identifier) {
        [self.taskGroup removeObjectForKey:task.identifier];
    }
}

@end
