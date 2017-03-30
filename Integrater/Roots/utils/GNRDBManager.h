//
//  GNRDBManager.h
//  Integrater
//
//  Created by LvYuan on 2017/3/30.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRObject.h"

@class GNRTaskInfo;

@interface GNRDBManager : GNRObject

+ (instancetype)manager;

- (void)insertNewTaskInfo:(GNRTaskInfo *)taskInfo;
- (void)deleteTaskInfo:(GNRTaskInfo *)taskInfo;
- (void)updateTaskInfo:(GNRTaskInfo *)taskInfo;

- (NSMutableArray <GNRTaskInfo *>*)taskInfos;

@end
