//
//  GNRHeader.h
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#ifndef GNRHeader_h
#define GNRHeader_h

#define WEAK_SELF __weak typeof(self) wself = self

#define k_Integrater_Name_iOS @"k_Integrater_Name_iOS"
#define k_Debug @"Debug"
#define k_Release @"Release"

#define k_XcodeProject @".xcodeproj"
#define k_Xcworkspace @".xcworkspace"


//clean
#define k_ScripFromat_Project_Clean @"do shell script \"xcodebuild clean -project %@ -scheme %@ CONFIGURATION=%@\""

#define k_ScripFromat_Workspace_Clean @"do shell script \"xcodebuild clean -workspace %@ -scheme %@ CONFIGURATION=%@\""

//导出archive
#define k_ScripFromat_Project @"do shell script \"xcodebuild archive -project %@ -scheme %@ -archivePath %@ CONFIGURATION=%@\""

#define k_ScripFromat_Workspace @"do shell script \"xcodebuild archive -workspace %@ -scheme %@ -archivePath %@ CONFIGURATION=%@\""

//导出ipa
#define k_ScriptFormat_IPA @"do shell script \"xcodebuild -exportArchive -archivePath %@ -exportPath %@ -exportOptionsPlist /Users/lvyuan/Projects/BuildLocal/build.plist\""

#define k_Appkey_Pgyer @"c17ad8d42627eca76e8901148463ee25"

#define k_UserKey_Pgyer @"9801f719800965a0fef6560488d1f80f"

#define k_AppID_Pgyer @"01bff2e7ea20c82e0af8390a16d74c4f"

#define k_Upload_URL_Pgyer @"https://qiniu-storage.pgyer.com/apiv1/app/upload"

//log
#if DEBUG
#define GLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define GLog(...)
#endif

//        application/octet-stream
//        application/iphone    pxl ipa
//        application/vnd.android.package-archive  apk


#import "GNRUtil.h"
#import "GNRHelper.h"
#import "NSObject+Extension.h"
#import "NSString+Extension.h"

#endif /* GNRHeader_h */
