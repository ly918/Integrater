//
//  GNRConstString.h
//  Integrater
//
//  Created by LvYuan on 2017/3/30.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRObject.h"

@interface GNRConstString : GNRObject

FOUNDATION_EXPORT NSString * const k_Key_ExportPlist_BitCode;
FOUNDATION_EXPORT NSString * const k_Key_ExportPlist_TeamID;
FOUNDATION_EXPORT NSString * const k_Key_ExportPlist_Method;
FOUNDATION_EXPORT NSString * const k_Key_ProvisioningProfiles;
FOUNDATION_EXPORT NSString * const k_Configuration_Debug;
FOUNDATION_EXPORT NSString * const k_Configuration_Release;

FOUNDATION_EXPORT NSString * const k_XcodeProject;
FOUNDATION_EXPORT NSString * const k_Xcworkspace;

FOUNDATION_EXPORT NSString * const k_TaskID_ArchiveTask_Clean;
FOUNDATION_EXPORT NSString * const k_TaskID_ArchiveTask_Archive;
FOUNDATION_EXPORT NSString * const k_TaskID_ArchiveTask_IPA;
FOUNDATION_EXPORT NSString * const k_TaskID_UploadTask_IPA;

@end
