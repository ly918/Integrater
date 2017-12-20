//
//  NSDate+GNRExtension.h
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//
#import "GNRObject.h"

@interface GNRUtil : GNRObject

+ (void)alertMessage:(NSString *)msg;

+ (void)alertMessage:(NSString *)msg cancel:(NSString *)cancel confirm:(NSString *)confirm completion:(void (^)(NSInteger code))completion;
+ (void)alertMessage:(NSString *)msg cancel:(NSString *)cancel ortherBtns:(NSArray *)ortherBtns completion:(void (^)(NSInteger code))completion;
//MARK: - path select board
+ (NSString *)openPanelForCanCreateDir:(BOOL)canCreateDir canChooseDir:(BOOL)canChooseDir canChooseFiles:(BOOL)canChooseFiles;

+ (BOOL)createDir:(NSString *)path;
+ (BOOL)createPlist:(id)data path:(NSString *)path;

+ (NSString*)showDetailTime:(NSTimeInterval) msglastTime;
+ (NSString*)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail;
+ (NSString*)standardTime:(NSDate*)date;//yyyy-MM-dd HH:mm:ss
+ (NSString*)standardTimeForFile:(NSDate*)date;//yyyy-MM-dd_HH:mm:ss
+ (NSString*)standardDateForFile:(NSDate*)date;

#pragma mark - 颜色转换
+ (NSColor *)colorWithHexString:(NSString *)stringToConvert;
+ (NSColor *)randColor;

@end
