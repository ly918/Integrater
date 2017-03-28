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

//自动生成其他字段
- (void)configValues{
    if (_projectDir) {
        //自动构建project 或者 workspace 路径
        NSFileManager * fm = [NSFileManager defaultManager];
        NSError * error = nil;
        NSArray * paths = [fm contentsOfDirectoryAtPath:_projectDir error:&error];
        GLog(@"path %@ \n error %@",paths,error);
        
        BOOL hasProj = NO;
        BOOL hasWorkspace = NO;
        NSString * projectContent = nil;
        NSString * workspaceContent = nil;
        //proj path
        for (NSString * content in paths) {
            if ([content hasSuffix:k_XcodeProject]) {
                self.projectPath = [_projectDir stringByAppendingPathComponent:content];
                hasProj = YES;
                projectContent = content;
            }else if ([content hasSuffix:k_Xcworkspace]){
                self.workspacePath = [_projectDir stringByAppendingPathComponent:content];
                hasWorkspace = YES;
                workspaceContent = content;
            }
        }
        //type proj schemeName
        if (hasWorkspace) {
            _projectType = GNRProjectType_Workspace;
            self.schemeName = [projectContent substringWithRange:NSMakeRange(0,workspaceContent.length - k_Xcworkspace.length)];
        }else if (hasProj) {
            _projectType = GNRProjectType_Proj;
            self.schemeName = [workspaceContent substringWithRange:NSMakeRange(0, projectContent.length - k_XcodeProject.length)];
        }
        
        //taskName
        _taskName = [self createTaskName];
        
        //output path
        _archiveOutputDir = [NSString stringWithFormat:@"%@/archive_%@",_archivePath,_schemeName];
        _archiveFileOutputPath = [NSString stringWithFormat:@"%@.xcarchive",_archiveOutputDir];
        
        //ipa path
        _ipaFileOutputPath = [NSString stringWithFormat:@"%@/%@.ipa",_ipaPath,_schemeName];
        
        //OptionsPlist path
        _optionsPlistPath = [_projectDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_exportOptionsPlist.plist",_schemeName]];
        [self createOptionsPlist];
    }
}

//MARK: - 生存plist文件
- (void)createOptionsPlist{
    NSDictionary * dict = @{@"compileBitcode":@NO,
                            @"method":@"development"};
    BOOL flag = [dict writeToFile:_optionsPlistPath atomically:YES];
    if (flag) {
        GLog(@"plist 文件写入成功");
    }else{
        GLog(@"plist 文件写入失败");
    }
    
}

//MARK: - 生成任务队列name
- (NSString *)createTaskName{
    if (_projectDir.length&&
        _schemeName.length) {
        return [NSString stringWithFormat:@"%@_%@",[_projectDir MD5],_schemeName];
    }
    return nil;
}

- (NSString *)description{
    return self.getAllPropertiesAndVaules.description;
}

@end
