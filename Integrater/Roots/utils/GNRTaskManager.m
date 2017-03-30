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
        [self readTaskInfoListFromDB];
    }
    return self;
}

- (void)readTaskInfoListFromDB{
    WEAK_SELF;
    NSMutableArray <GNRTaskInfo *>* taskList = [[GNRDBManager manager] taskInfos];
    [taskList enumerateObjectsUsingBlock:^(GNRTaskInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj configValues];
        GNRIntegrater * task = [[GNRIntegrater alloc]initWithTaskInfo:obj];
        [wself addTaskFromDB:task];
    }];

}

//数据库的
- (void)addTaskFromDB:(GNRIntegrater *)task{
    if (task) {
        [_tasks addObject:task];
        [self addTaskListModelWithTask:task];
    }
}

//新建的
- (void)addTask:(GNRIntegrater *)task{
    if (task) {
        [_tasks addObject:task];
        [self addTaskListModelWithTask:task];
        task.taskInfo.createTime = [GNRUtil standardTime:[NSDate date]];//创建时间
        [[GNRDBManager manager] insertNewTaskInfo:task.taskInfo];
    }
}

- (void)addTaskListModelWithTask:(GNRIntegrater *)task{
    GNRTaskInfo * taskInfo = task.taskInfo;
    GNRTaskListModel * model = [[GNRTaskListModel new]initWithTaskName:taskInfo.taskName appName:taskInfo.schemeName];
    [_taskListModels addObject:model];
    
    //MARK: - 增加
    if (_delegate && [_delegate respondsToSelector:@selector(manager:addTask:taskListModel:)]) {
        [_delegate manager:self addTask:task taskListModel:model];
    }
}

- (void)removeTaskListModelWithTask:(GNRIntegrater *)task{
    NSString * taskName = task.taskInfo.taskName;
    __block GNRTaskListModel * model = nil;
    [_taskListModels enumerateObjectsUsingBlock:^(GNRTaskListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.taskName isEqualToString:taskName]) {
            model = obj;
        }
    }];
    if (model) {
        [_taskListModels removeObject:model];

        //MARK: - 删除
        if (_delegate && [_delegate respondsToSelector:@selector(manager:removeTask:taskListModel:)]) {
            [_delegate manager:self removeTask:task taskListModel:model];
        }
    }
}


- (void)removeTask:(GNRIntegrater *)task{
    if (task&&[_tasks containsObject:task]) {
        [_tasks removeObject:task];
        [self removeTaskListModelWithTask:task];
    }
}

- (GNRIntegrater *)getTaskWithModel:(GNRTaskListModel *)model{
    if (!model.taskName.length) {
        return nil;
    }
    __block GNRIntegrater * task = nil;
    [_tasks enumerateObjectsUsingBlock:^(GNRIntegrater * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([task.taskInfo.taskName isEqualToString:model.taskName]) {
            task = obj;
        }
    }];
    return task;
}

@end
