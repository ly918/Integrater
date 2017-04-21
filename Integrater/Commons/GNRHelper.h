//
//  GNRHelper.h
//  Integrater
//
//  Created by LvYuan on 2017/3/27.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNRHelper : NSObject
//检查path
+ (BOOL)validPath:(NSString *)path;
+ (NSString *)getAppVersion;
@end
