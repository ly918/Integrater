//
//  NSDate+GNRExtension.h
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface GNRUtil : NSObject

+ (void)alertMessage:(NSString *)msg;
//MARK: - path select board
+ (NSString *)openPanelForCanCreateDir:(BOOL)canCreateDir canChooseDir:(BOOL)canChooseDir canChooseFiles:(BOOL)canChooseFiles;
+ (NSString*)showDetailTime:(NSTimeInterval) msglastTime;
+ (NSString*)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail;
+ (NSString*)standardTime:(NSDate*)date;//yyyy-MM-dd HH:mm:ss
@end
