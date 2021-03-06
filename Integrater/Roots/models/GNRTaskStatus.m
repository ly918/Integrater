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
    _statusMsg = [GNRTaskStatus statusMsgWithStatus:taskStatus];
    _progress = [GNRTaskStatus progressWithStatus:taskStatus];
}

+ (CGFloat)progressWithStatus:(GNRIntegraterTaskStatus)status{
    if (status>=0&&status<GNRIntegraterTaskStatusCleaning) {
        return 0;
    }else if (status == GNRIntegraterTaskStatusCleaning){
        return 1;
    }else if (status == GNRIntegraterTaskStatusBuilding){
        return 10;
    }else if (status == GNRIntegraterTaskStatusArchiving){
        return 30;
    }else if (status == GNRIntegraterTaskStatusUpdating){
        return 60;
    }else if (status == GNRIntegraterTaskStatusSucceeded) {
        return 130;
    }
    return 0;
}

+ (NSString *)statusMsgWithStatus:(GNRIntegraterTaskStatus)status{
    NSNumber * number = @(status);
    NSDictionary * infos = @{@(GNRIntegraterTaskStatusPreparing):@"Preparing",
                             @(GNRIntegraterTaskStatusPrepared):@"Prepared",
                             @(GNRIntegraterTaskStatusGitting):@"Pulling",
                             @(GNRIntegraterTaskStatusCleaning):@"Cleaning",
                             @(GNRIntegraterTaskStatusBuilding):@"Building",
                             @(GNRIntegraterTaskStatusArchiving):@"Archiving",
                             @(GNRIntegraterTaskStatusUpdating):@"Uploading",
                             @(GNRIntegraterTaskStatusSucceeded):@"Upload Successfully",
                             @(GNRIntegraterTaskStatusPrepareError):@"Prepare Error",
                             @(GNRIntegraterTaskStatusGitError):@"Git Error",
                             @(GNRIntegraterTaskStatusCleanError):@"Clean Error",
                             @(GNRIntegraterTaskStatusBuildError):@"Build Error",
                             @(GNRIntegraterTaskStatusArchiveError):@"Archive Error",
                             @(GNRIntegraterTaskStatusUpdateError):@"Upload Error",
                             };
    return [infos objectForKey:number];
}

@end
