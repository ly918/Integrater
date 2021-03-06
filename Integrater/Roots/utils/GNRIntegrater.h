//
//  GNRTaskManager.h
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRObject.h"
#import "GNRArchiveTask.h"
#import "GNRGitTask.h"
#import "GNRUploadTask.h"
#import "GNRTaskInfo.h"
#import "GNRTaskStatus.h"

typedef void(^GNRTaskRunStatusBlock)(GNRTaskStatus *);

@interface GNRIntegrater : GNRObject
@property (nonatomic, copy)NSString * name;
@property (nonatomic, assign, getter=isRunning)BOOL running;//运行中？
@property (nonatomic, strong)GNRTaskInfo * taskInfo;//任务信息汇总
@property (nonatomic, strong)GNRTaskStatus * taskStatus;//任务状态
/**
 初始化方法

 @param taskInfo 任务信息
 @return self
 */
- (instancetype)initWithTaskInfo:(GNRTaskInfo *)taskInfo;

/**
 执行打包任务
 @return self
 */
- (GNRIntegrater *)runTask;

//停止
- (GNRIntegrater *)stopTask;

- (void)taskStatusCallback:(GNRTaskRunStatusBlock)block;

@end
