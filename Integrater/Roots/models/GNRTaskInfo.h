//
//  GNRTaskInfo.h
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRObject.h"

typedef NS_ENUM(NSInteger,GNRTaskInfoPlatform) {
    GNRTaskInfoPlatform_iOS=1,
    GNRTaskInfoPlatform_Android
};

typedef NS_ENUM(NSInteger,GNRProjectType) {
    GNRProjectType_Proj=1,
    GNRProjectType_Workspace
};

@interface GNRTaskInfo : GNRObject

@property (nonatomic, assign)GNRTaskInfoPlatform platform;
//in
@property (nonatomic, assign, readonly)GNRProjectType projectType;
@property (nonatomic, copy)NSString * projectDir;//工程目录

/********/
//下面四个会根据自动赋值
@property (nonatomic, copy)NSString * projectPath;
@property (nonatomic, copy)NSString * workspacePath;
@property (nonatomic, copy)NSString * schemeName;
@property (nonatomic, copy,readonly)NSString * archiveOutputPath;//.xcarchive输出path
/********/

@property (nonatomic, copy)NSString * buildEnvironment;//构建环境: Debug Release
//out
@property (nonatomic, copy)NSString * archivePath;
@property (nonatomic, copy)NSString * ipaPath;

@property (nonatomic, copy, readonly)NSString * taskName;//任务名称 用于创建GNRIntegrater对象

@end
