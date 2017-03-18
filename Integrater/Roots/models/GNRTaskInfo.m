//
//  GNRTaskInfo.m
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskInfo.h"

@implementation GNRTaskInfo

- (void)setProjectPath:(NSString *)projectPath{
    _projectPath = projectPath;
    if (projectPath) {
        if ([projectPath hasSuffix:@".xcworkspace"]) {
            _projectType = GNRProjectType_Workspace;
        }else{
            _projectType = GNRProjectType_Proj;
        }
    }
}

- (NSString *)importInPath{
    return [NSString stringWithFormat:@"%@.xcarchive",self.archivePath];
}

@end
