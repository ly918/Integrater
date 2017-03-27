//
//  GNRTaskManager.m
//  Integrater
//
//  Created by LvYuan on 2017/3/27.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskManager.h"

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

- (void)addTask:(GNRIntegrater *)task{
    if (task) {
        [_tasks addObject:task];
        [self addTaskListModelWithTask:task];
    }
}

- (void)addTaskListModelWithTask:(GNRIntegrater *)task{
    GNRTaskInfo * taskInfo = task.taskInfo;
    GNRTaskListModel * model = [[GNRTaskListModel new]initWithTaskName:taskInfo.taskName appName:taskInfo.schemeName];
    [_taskListModels addObject:model];
}

- (void)removeTaskListModelWithTaskName:(NSString *)taskName{
    [_taskListModels enumerateObjectsUsingBlock:^(GNRTaskListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.taskName isEqualToString:taskName]) {
            [_taskListModels removeObject:obj];
        }
    }];
}

- (void)removeTask:(GNRIntegrater *)task{
    if (task&&[_tasks containsObject:task]) {
        [_tasks removeObject:task];
        [self removeTaskListModelWithTaskName:task.taskInfo.taskName];
    }
}

@end
