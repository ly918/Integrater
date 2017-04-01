//
//  GNRTaskManager.m
//  Integrater
//
//  Created by LvYuan on 2017/3/27.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskManager.h"
#import "GNRDBManager.h"
@implementation GNRTaskManager

+ (instancetype)manager{
    static GNRTaskManager *c = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        c = [[self alloc] init];
    });
    return c;
}

- (instancetype)init{
    if (self = [super init]) {
        _tasks = [NSMutableArray array];
        _taskListModels = [NSMutableArray array];
    }
    return self;
}

//MARK: - 从数据课读取任务信息
- (void)readTaskInfoListFromDB{
    WEAK_SELF;
    NSMutableArray <GNRTaskInfo *>* taskList = [[GNRDBManager manager] taskInfos];
    [taskList enumerateObjectsUsingBlock:^(GNRTaskInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //配置任务信息
        [obj configValues];
        //添加一个任务
        [wself addTaskFromDBTaskInfo:obj];
    }];
}

//MARK: - 根据数据库任务信息 添加一个任务
- (void)addTaskFromDBTaskInfo:(GNRTaskInfo *)taskInfo{
    if (taskInfo) {
        GNRIntegrater * task = [[GNRIntegrater alloc]initWithTaskInfo:taskInfo];
        task.taskStatus.taskStatus = GNRIntegraterTaskStatusPrepared;
        [_tasks addObject:task];
        GNRTaskListModel * model = [self addTaskListModelWithTask:task];
        //MARK: - 从DB读取
        if (_delegate && [_delegate respondsToSelector:@selector(manager:readTask_DB:taskListModel:)]) {
            [_delegate manager:self readTask_DB:task taskListModel:model];
        }
    }
}

//MARK: - 新添加任务
- (void)addTask:(GNRIntegrater *)task{
    if (task && ![self isExsitsTask:task.taskInfo.taskName]) {
        [_tasks addObject:task];
        GNRTaskListModel * model=[self addTaskListModelWithTask:task];
        task.taskInfo.createTime = @([[NSDate date] timeIntervalSince1970]).stringValue;//创建时间
        [[GNRDBManager manager] insertNewTaskInfo:task.taskInfo];
        //MARK: - 增加
        if (_delegate && [_delegate respondsToSelector:@selector(manager:addTask:taskListModel:)]) {
            [_delegate manager:self addTask:task taskListModel:model];
        }
    }
}

//update任务
- (void)updateTaskInfo:(GNRTaskInfo *)taskInfo{
    [[GNRDBManager manager] updateTaskInfo:taskInfo];
}

- (GNRTaskListModel *)addTaskListModelWithTask:(GNRIntegrater *)task{
    GNRTaskInfo * taskInfo = task.taskInfo;
    GNRTaskListModel * model = [[GNRTaskListModel new]initWithTaskName:taskInfo.taskName appName:taskInfo.schemeName];
    [_taskListModels addObject:model];
    [self updateListModel:model status:task.taskStatus];//根据状态 更新ListModel
    return model;
}

//MARK: - 删除任务
- (void)removeTask:(GNRIntegrater *)task{
    if (task&&[_tasks containsObject:task]) {
        [_tasks removeObject:task];
        [[GNRDBManager manager] deleteTaskInfo:task.taskInfo];
        GNRTaskListModel * model = [self removeTaskListModelWithTask:task];
        //MARK: - 删除
        if (_delegate && [_delegate respondsToSelector:@selector(manager:removeTask:taskListModel:)]) {
            [_delegate manager:self removeTask:task taskListModel:model];
        }
    }
}

- (GNRTaskListModel *)removeTaskListModelWithTask:(GNRIntegrater *)task{
    NSString * taskName = task.taskInfo.taskName;
    __block GNRTaskListModel * model = nil;
    [_taskListModels enumerateObjectsUsingBlock:^(GNRTaskListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.taskName isEqualToString:taskName]) {
            model = obj;
        }
    }];
    if (model) {
        [_taskListModels removeObject:model];
    }
    return model;
}

//是否存在 该任务
- (BOOL)isExsitsTask:(NSString *)taskName{
    if (taskName.length) {
        for (GNRIntegrater * obj in _tasks) {
            if ([obj.taskInfo.taskName isEqualToString:taskName]) {
                return YES;
            }
        }
    }
    return NO;
}

//MARK: - 从列表数据 获取 任务
- (GNRIntegrater *)getTaskWithModel:(GNRTaskListModel *)model{
    if (!model.taskName.length) {
        return nil;
    }
    __block GNRIntegrater * task = nil;
    [_tasks enumerateObjectsUsingBlock:^(GNRIntegrater * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:model.taskName]) {
            task = obj;
        }
    }];
    return task;
}

//MARK: - 通过任务状态 更新列表数据
- (void)updateListModel:(GNRTaskListModel *)model status:(GNRTaskStatus *)status{
    
    if (status && model) {
        
        GNRIntegrater * task = [self getTaskWithModel:model];
        model.statusMsg = status.statusMsg;
        model.progress = status.progress;
        model.lastTime = task.taskInfo.lastUploadTime;
        model.createTime = task.taskInfo.createTime;
        
        if (status.taskStatus<GNRIntegraterTaskStatusPreparing) {
            model.textColor = [GNRUtil colorWithHexString:@"#FF3300"];
        }else if(status.taskStatus<GNRIntegraterTaskStatusSucceeded){
            model.textColor = [GNRUtil colorWithHexString:@"#009966"];
        }else {
            model.textColor = [GNRUtil colorWithHexString:@"#0066FF"];
        }
    }
}

//MARK: - 更新最后上传时间
- (void)updateLastTimeWithTask:(GNRIntegrater *)task{
    NSString * lastUpdateTime = @([[NSDate date] timeIntervalSince1970]).stringValue;//最后更新时间
    task.taskInfo.lastUploadTime = lastUpdateTime;
    [[GNRDBManager manager]updateTaskInfo:task.taskInfo];
}

@end
