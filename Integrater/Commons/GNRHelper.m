//
//  GNRHelper.m
//  Integrater
//
//  Created by LvYuan on 2017/3/27.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRHelper.h"

@implementation GNRHelper

+ (BOOL)validPath:(NSString *)path{
    return path.length>0;
}

+ (NSString *)getAppVersion{
    NSString * path=[[NSBundle mainBundle]pathForResource:@"Info" ofType:@"plist"];
    NSDictionary * info=[NSDictionary dictionaryWithContentsOfFile:path];
    NSString * versionString=[info objectForKey:@"CFBundleShortVersionString"];
    NSString * bundleVersion=[info objectForKey:@"CFBundleVersion"];
    return [NSString stringWithFormat:@"v%@(%@)",versionString,bundleVersion];
}
@end
