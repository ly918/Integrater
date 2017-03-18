//
//  GNRTaskInfo.h
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRObject.h"

typedef NS_ENUM(NSInteger,GNRTaskInfoPlatform) {
    GNRTaskInfoPlatform_iOS,
    GNRTaskInfoPlatform_Android
};

typedef NS_ENUM(NSInteger,GNRProjectType) {
    GNRProjectType_Proj,
    GNRProjectType_Workspace
};

@interface GNRTaskInfo : GNRObject

@property (nonatomic, assign)GNRTaskInfoPlatform platform;
//in
@property (nonatomic, assign, readonly)GNRProjectType projectType;
@property (nonatomic, copy)NSString * projectPath;
@property (nonatomic, copy,readonly)NSString * importInPath;
@property (nonatomic, copy)NSString * schemeName;
@property (nonatomic, copy)NSString * releaseStr;
//out
@property (nonatomic, copy)NSString * archivePath;
@property (nonatomic, copy)NSString * ipaPath;

@end
