//
//  GNRTaskInfo.m
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskInfo.h"

@implementation GNRTaskInfo

- (instancetype)init{
    if (self = [super init]) {
        _buildEnvironment = k_Debug;
        _platform = GNRTaskInfoPlatform_iOS;
    }
    return self;
}

- (void)setProjectDir:(NSString *)projectDir{
    _projectDir = projectDir;
    if (projectDir) {
        //自动构建project 或者 workspace 路径
        NSFileManager * fm = [NSFileManager defaultManager];
        NSError * error = nil;
        NSArray * paths = [fm contentsOfDirectoryAtPath:projectDir error:&error];
        GLog(@"path %@ \n error %@",paths,error);
        
        BOOL hasProj = NO;
        BOOL hasWorkspace = NO;
        NSString * projectContent = nil;
        NSString * workspaceContent = nil;

        for (NSString * content in paths) {
            if ([content hasSuffix:k_XcodeProject]) {
                self.projectPath = [projectDir stringByAppendingPathComponent:content];
                hasProj = YES;
                projectContent = content;
            }else if ([content hasSuffix:k_Xcworkspace]){
                self.workspacePath = [projectDir stringByAppendingPathComponent:content];
                hasWorkspace = YES;
                workspaceContent = content;
            }
        }
        
        if (hasWorkspace) {
            _projectType = GNRProjectType_Workspace;
            self.schemeName = [projectContent substringWithRange:NSMakeRange(0,workspaceContent.length - k_Xcworkspace.length)];
        }else if (hasProj) {
            _projectType = GNRProjectType_Proj;
            self.schemeName = [workspaceContent substringWithRange:NSMakeRange(0, projectContent.length - k_XcodeProject.length)];
        }
        
        //taskName
        _taskName = [self createTaskName];
    }
}

- (NSString *)createTaskName{
    if (_projectDir.length&&
        _schemeName.length) {
        return [NSString stringWithFormat:@"%@_%@_%@",[_projectDir MD5],_schemeName,[GNRUtil standardTime:[NSDate date]]];
    }
    return nil;
}


- (void)setProjectPath:(NSString *)projectPath{
    _projectPath = projectPath;
}

- (NSString *)importInPath{
    return [NSString stringWithFormat:@"%@.xcarchive",self.archivePath];
}

- (NSString *)description{
    return self.getAllPropertiesAndVaules.description;
}

@end
