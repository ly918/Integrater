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


#define k_ScripFromat_Project @"do shell script \"xcodebuild archive -project %@ -scheme %@ -archivePath %@ CONFIGURATION=%@ -exportOptionsPlist /Users/lvyuan/Projects/iBox/Xbox.plist \""

#define k_ScripFromat_Workspace @"do shell script \"xcodebuild archive -workspace %@ -scheme %@ -archivePath %@ CONFIGURATION=%@ -exportOptionsPlist /Users/lvyuan/Projects/iBox/Xbox.plist \""

#define k_ScriptFormat_IPA @"do shell script \"xcodebuild -exportArchive -archivePath %@ -exportPath %@ -exportFormat ipa\""

#endif /* GNRHeader_h */
