//
//  GNRTaskManager.m
//  Integrater
//
//  Created by LvYuan on 2017/3/27.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskManager.h"
#import "GNRDBManager.h"

@interface GNRTaskManager()

@end

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
        task.taskStatus.taskStatus = taskInfo.taskName?GNRIntegraterTaskStatusPrepared:GNRIntegraterTaskStatusPrepareError;
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
    if (task && ![self isExsitsTask:task.taskInfo.Id]) {
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
    GNRTaskListModel * model = [[GNRTaskListModel new]initWithId:taskInfo.Id taskName:taskInfo.taskName appName:taskInfo.schemeName];
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
    NSString * taskId = task.taskInfo.Id;
    __block GNRTaskListModel * model = nil;
    [_taskListModels enumerateObjectsUsingBlock:^(GNRTaskListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.Id isEqualToString:taskId]) {
            model = obj;
        }
    }];
    if (model) {
        [_taskListModels removeObject:model];
    }
    return model;
}

//是否存在 该任务
- (BOOL)isExsitsTask:(NSString *)taskId{
    if (taskId.length) {
        for (GNRIntegrater * obj in _tasks) {
            if ([obj.taskInfo.Id isEqualToString:taskId]) {
                return YES;
            }
        }
    }
    return NO;
}

//MARK: - 从列表数据 获取 任务
- (GNRIntegrater *)getTaskWithModel:(GNRTaskListModel *)model{
    if (!model.Id.length) {
        return nil;
    }
    __block GNRIntegrater * task = nil;
    [_tasks enumerateObjectsUsingBlock:^(GNRIntegrater * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:model.Id]) {
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
        model.downloadUrl = task.taskInfo.buildShortcutUrl.length?[NSString stringWithFormat:@"%@%@",@"https://www.pgyer.com/",task.taskInfo.buildShortcutUrl]:nil;
        
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

//MARK: - 过滤
- (NSMutableArray *)filter:(NSString *)keyword{
    __block NSMutableArray * names = [NSMutableArray array];
    __block NSMutableArray * fileters = [NSMutableArray array];
    
    [_taskListModels enumerateObjectsUsingBlock:^(GNRTaskListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [names addObject:obj.appName];
    }];
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",keyword];
    [names filterUsingPredicate:pred];
    
    for (NSString * name in names) {
        [_taskListModels enumerateObjectsUsingBlock:^(GNRTaskListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([name isEqualToString:obj.appName]) {
                [fileters addObject:obj];
            }
        }];
    }
    return fileters;
}

@end
