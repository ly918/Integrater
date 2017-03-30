//
//  GNRTaskStatus.h
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRObject.h"

typedef NS_ENUM(NSInteger,GNRIntegraterTaskStatus) {
    GNRIntegraterTaskStatusUpdateError = -6,//上传出错
    GNRIntegraterTaskStatusArchiveError = -5,//打包出错
    GNRIntegraterTaskStatusBuildError = -4,//编译出错
    GNRIntegraterTaskStatusCleanError = -3,//清理出错
    GNRIntegraterTaskStatusGitError= -2,//git 命令 执行错误
    GNRIntegraterTaskStatusPrepareError = -1,//准备数据有错
    GNRIntegraterTaskStatusPreparing = 0,//所需数据准备中
    GNRIntegraterTaskStatusPrepared = 1,///所需数据准备好了 但未启动
    GNRIntegraterTaskStatusGitting = 2,//git 命令 执行中
    GNRIntegraterTaskStatusCleaning = 3,//清理
    GNRIntegraterTaskStatusBuilding = 4,//编译
    GNRIntegraterTaskStatusArchiving = 5,//编译
    GNRIntegraterTaskStatusUpdating = 6,//上传
    GNRIntegraterTaskStatusSucceeded = 666666 //所有任务执行成功  666666！！
};


@interface GNRTaskStatus : GNRObject

@property (nonatomic, assign) GNRIntegraterTaskStatus taskStatus;//任务状态
@property (nonatomic, copy) NSString * statusMsg;//状态信息、
@property (nonatomic, copy) NSString * showTime;//状态更新时间
@property (nonatomic, strong)NSError * error;//错误信息 如果是脚本错误信息(为字典类型) 则为error的userinfo
//TODO: - 任务进度
@property (nonatomic, assign)CGFloat progress;

- (void)configWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;

+ (NSString *)statusMsgWithStatus:(GNRIntegraterTaskStatus)status;

@end
