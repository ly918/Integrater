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
- (void)manager:(GNRTaskManager *)manager removeTask:(GNRIntegrater *)task taskListModel:(GNRTaskListModel *)taskListModel;

@end

@interface GNRTaskManager : GNRObject

@property (nonatomic, strong)NSMutableArray <GNRIntegrater *>* tasks;
@property (nonatomic, strong)NSMutableArray <GNRTaskListModel *>* taskListModels;

@property (nonatomic, weak) id<GNRTaskManagerDelegate> delegate;

+ (instancetype)manager;

- (void)addTask:(GNRIntegrater *)task;
- (void)removeTask:(GNRIntegrater *)task;
- (GNRIntegrater *)getTaskWithModel:(GNRTaskListModel *)model;

@end
