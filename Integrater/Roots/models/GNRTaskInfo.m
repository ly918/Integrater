//
//  GNRTaskInfo.m
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskInfo.h"

@interface GNRTaskInfo ()

@property (nonatomic, strong) NSString * submit_Str;
@property (nonatomic, strong) NSString * nowTime;
@property (nonatomic, strong) NSString * nowDate;

@end

@implementation GNRTaskInfo

- (instancetype)init{
    if (self = [super init]) {
        _projectPath = @"";
        _workspacePath = @"";
        _createTime = @"";
        _lastUploadTime = @"";
        _configuration = k_Configuration_Debug;
        _platform = GNRTaskInfoPlatform_iOS;
        
    }
    return self;
}

//自动生成其他字段
- (void)configValues{
    if ([GNRHelper validPath:_projectDir]) {
        //设置工程类型和scheme
        [self setupProjTypeAndScheme];
        
        //create output dir
        [GNRUtil createDir:self.archiveOutputDir];
        
        //create plist
        [self createOptionsPlist];
    }else{
        GLog(@"project path error!");
    }
}

//设置工程类型 和 scheme
- (void)setupProjTypeAndScheme{
    NSError * error = nil;
    //自动构建project 或者 workspace 路径
    NSFileManager * fm = [NSFileManager defaultManager];
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
        self.schemeName = [workspaceContent substringWithRange:NSMakeRange(0,workspaceContent.length - k_Xcworkspace.length)];
    }else if (hasProj) {
        _projectType = GNRProjectType_Proj;
        self.schemeName = [projectContent substringWithRange:NSMakeRange(0, projectContent.length - k_XcodeProject.length)];
    }
    
    NSDate * date = [NSDate date];
    _nowDate = [GNRUtil standardDateForFile:date];
    _nowTime = [GNRUtil standardTimeForFile:date];
}

- (NSString *)ipaFileOutputPath{
    if (self.ipaFileOutputHeadPath.length&&_schemeName.length) {
        _ipaFileOutputPath = [NSString stringWithFormat:@"%@/%@.ipa",self.ipaFileOutputHeadPath,_schemeName];
    }
    return _ipaFileOutputPath;
}

- (NSString *)submit_Str{
    return self.submit_formal?@"Formal":@"Local";
}

- (NSString *)ipaFileOutputHeadPath{
    if (self.archiveOutputDir.length&&_schemeName.length) {
        _ipaFileOutputHeadPath = [NSString stringWithFormat:@"%@/%@_%@_%@",_archiveOutputDir,_schemeName,_nowTime,self.submit_Str];
    }
    return _ipaFileOutputHeadPath;
}

//archive path
- (NSString *)archiveFileOutputPath{
    if (self.archiveOutputDir.length&&_schemeName.length) {
        _archiveFileOutputPath = [NSString stringWithFormat:@"%@/%@_%@_%@.xcarchive",_archiveOutputDir,_schemeName,_nowTime,self.submit_Str];
    }
    return _archiveFileOutputPath;
}

//OptionsPlist path
- (NSString *)optionsPlistPath{
    if (self.archiveOutputParentDir.length&&_schemeName.length) {
        _optionsPlistPath = [_archiveOutputParentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_ExportOptions.plist",_schemeName]];
    }
    return _optionsPlistPath;
}

//xxx/archive_app/app_2017-03-30
- (NSString *)archiveOutputDir{
    if (self.archiveOutputParentDir.length&&_schemeName.length) {
        _archiveOutputDir =  [NSString stringWithFormat:@"%@/%@_%@_%@",_archiveOutputParentDir,_schemeName,_nowDate,self.submit_Str];

    }
    return _archiveOutputDir;
}


//xxx/archive_app
- (NSString *)archiveOutputParentDir{
    if (_archivePath.length&&_schemeName.length) {
        _archiveOutputParentDir = [NSString stringWithFormat:@"%@/archive_%@",_archivePath,_schemeName];
    }
    return _archiveOutputParentDir;
}

- (void)setSchemeName:(NSString *)schemeName{
    _schemeName = schemeName;
    if (schemeName.length&&_projectDir.length) {
        //taskName
        _taskName = [NSString stringWithFormat:@"%@_%@",[_projectDir MD5],_schemeName];
    }
}

//MARK: - 生存plist文件
- (void)createOptionsPlist{
    NSString * method = [_configuration isEqualToString:@"Debug"]?@"development":@"app-store";
    NSDictionary * dict = @{k_Key_ExportPlist_BitCode:@NO,
                            k_Key_ExportPlist_Method:method};
    
    [GNRUtil createPlist:dict path:self.optionsPlistPath];
}

- (NSString *)description{
    return self.getAllPropertiesAndVaules.description;
}

@end
