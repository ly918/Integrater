//
//  GNRTaskStatus.m
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskStatus.h"

@implementation GNRTaskStatus

- (instancetype)init{
    if (self = [super init]) {
        _showTime = [GNRUtil showDetailTime:[[NSDate date] timeIntervalSince1970]];
        self.taskStatus = GNRIntegraterTaskStatusPreparing;
    }
    return self;
}

- (void)configWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo{
    if (userInfo) {
        NSLog(@"error %@",userInfo);
        self.taskStatus = code;
        _error = [NSError errorWithDomain:self.statusMsg code:code userInfo:userInfo];
    }
}

- (void)setTaskStatus:(GNRIntegraterTaskStatus)taskStatus{
    _taskStatus = taskStatus;
    _statusMsg = [GNRTaskStatus statusMsgWithStatus:self.taskStatus];
}

+ (NSString *)statusMsgWithStatus:(GNRIntegraterTaskStatus)status{
    NSNumber * number = @(status);
    NSDictionary * infos = @{@(GNRIntegraterTaskStatusPreparing):@"Preparing",
                             @(GNRIntegraterTaskStatusPrepared):@"Prepared",
                             @(GNRIntegraterTaskStatusGitting):@"Pulling",
                             @(GNRIntegraterTaskStatusCleaning):@"Cleaning",
                             @(GNRIntegraterTaskStatusBuilding):@"Building",
                             @(GNRIntegraterTaskStatusArchiving):@"Archiving",
                             @(GNRIntegraterTaskStatusUpdating):@"Updating",
                             @(GNRIntegraterTaskStatusSucceeded):@"Update Succeeded",
                             @(GNRIntegraterTaskStatusPrepareError):@"Prepare Error",
                             @(GNRIntegraterTaskStatusGitError):@"Git Error",
                             @(GNRIntegraterTaskStatusCleanError):@"Clean Error",
                             @(GNRIntegraterTaskStatusBuildError):@"Build Error",
                             @(GNRIntegraterTaskStatusArchiveError):@"Archive Error",
                             @(GNRIntegraterTaskStatusUpdateError):@"Update Error",
                             };
    return [infos objectForKey:number];
}

@end
