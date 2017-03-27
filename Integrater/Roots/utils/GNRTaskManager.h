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
@interface GNRTaskManager : GNRObject

@property (nonatomic, strong)NSMutableArray <GNRIntegrater *>* tasks;
@property (nonatomic, strong)NSMutableArray <GNRTaskListModel *>* taskListModels;

+ (instancetype)manager;

- (void)addTask:(GNRIntegrater *)task;
- (void)removeTask:(GNRIntegrater *)task;

@end
