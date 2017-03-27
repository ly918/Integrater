//
//  GNRTaskListModel.m
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskListModel.h"
#import "GNRTaskStatus.h"

@implementation GNRTaskListModel

- (void)initData{
    _statusMsg = [GNRTaskStatus statusMsgWithStatus:GNRIntegraterTaskStatusPreparing];
    _lastTime = [GNRUtil showTime:[[NSDate date] timeIntervalSince1970] showDetail:YES];
    _progress = 0;
}

- (instancetype)initWithTaskName:(NSString *)taskName appName:(NSString *)appName{
    if (self = [super init]) {
        _taskName = taskName;
        _appName = appName;
        [self initData];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)setAppName:(NSString *)appName{
    _appName = appName;
    _iconLetter = [appName substringToIndex:0];
}

+ (instancetype)initModel{
    GNRTaskListModel * model = [[GNRTaskListModel alloc]init];
    return model;
}

@end
