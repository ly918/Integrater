//
//  GNRTaskManager.h
//  Integrater
//
//  Created by LvYuan on 2017/3/27.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRObject.h"
#import "GNRIntegrater.h"
#import "GNRTaskListModel.h"

@class GNRTaskManager;
@class GNRTaskListModel;
@protocol GNRTaskManagerDelegate <NSObject>

- (void)manager:(GNRTaskManager *)manager addTask:(GNRIntegrater *)task taskListModel:(GNRTaskListModel *)taskListModel;
- (void)manager:(GNRTaskManager *)manager readTask_DB:(GNRIntegrater *)task taskListModel:(GNRTaskListModel *)taskListModel;
- (void)manager:(GNRTaskManager *)manager removeTask:(GNRIntegrater *)task taskListModel:(GNRTaskListModel *)taskListModel;

@end

@interface GNRTaskManager : GNRObject

@property (nonatomic, strong)NSMutableArray <GNRIntegrater *>* tasks;
@property (nonatomic, strong)NSMutableArray <GNRTaskListModel *>* taskListModels;

@property (nonatomic, weak) id<GNRTaskManagerDelegate> delegate;

+ (instancetype)manager;
//MARK: - 从数据课读取任务信息
- (void)readTaskInfoListFromDB;
//新添加一个任务
- (void)addTask:(GNRIntegrater *)task;
//update任务信息
- (void)updateTaskInfo:(GNRTaskInfo *)taskInfo;
//删除一个任务
- (void)removeTask:(GNRIntegrater *)task;
//MARK: - 从列表数据 获取 任务
- (GNRIntegrater *)getTaskWithModel:(GNRTaskListModel *)model;
//MARK: - 更新任务最后上传时间
- (void)updateLastTimeWithTask:(GNRIntegrater *)task;
//MARK: - 通过任务状态 更新列表数据
- (void)updateListModel:(GNRTaskListModel *)model status:(GNRTaskStatus *)status;
//是否存在 该任务
- (BOOL)isExsitsTask:(NSString *)taskName;
//MARK: - 过滤
- (NSMutableArray *)filter:(NSString *)keyword;
@end
