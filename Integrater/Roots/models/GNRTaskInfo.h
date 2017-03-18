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

@interface GNRTaskInfo : GNRObject

@property (nonatomic, assign)GNRTaskInfoPlatform platform;
//in
@property (nonatomic, copy)NSString * projectPath;
@property (nonatomic, copy)NSString * workspacePath;
@property (nonatomic, copy)NSString * schemeName;
@property (nonatomic, assign)BOOL isDebug;
//out
@property (nonatomic, copy)NSString * archivePath;
@property (nonatomic, copy)NSString * ipaPath;

@end
