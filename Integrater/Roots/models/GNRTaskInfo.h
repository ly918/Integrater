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
    GNRTaskInfoPlatform_OSX,
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

@property (nonatomic, copy, readonly)NSString * taskName;//任务名称 用于创建GNRIntegrater对象

/********/
@property (nonatomic, copy)NSString * projectPath;
@property (nonatomic, copy)NSString * workspacePath;
@property (nonatomic, copy)NSString * schemeName;
/********/

@property (nonatomic, copy)NSString * configuration;//构建环境: Debug Release
//out
@property (nonatomic, copy)NSString * archivePath;

@property (nonatomic, copy)NSString * archiveOutputParentDir;
@property (nonatomic, copy)NSString * archiveOutputDir;
@property (nonatomic, copy)NSString * archiveFileOutputPath;//.xcarchive输出path
@property (nonatomic, copy)NSString * ipaFileOutputHeadPath;
@property (nonatomic, copy)NSString * ipaFileOutputPath;//ipa输出path

//upload
@property (nonatomic, copy)NSString * uploadURL;
@property (nonatomic, copy)NSString * appkey;
@property (nonatomic, copy)NSString * userkey;

@property (nonatomic, copy)NSString * optionsPlistPath;

@property (nonatomic, copy)NSString * createTime;//创建时间
@property (nonatomic, copy)NSString * lastUploadTime;//最后上传时间

//生成其他字段
- (void)configValues;

@end
