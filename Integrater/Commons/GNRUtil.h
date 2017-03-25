//
//  NSDate+GNRExtension.h
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GNRUtil : NSObject

+ (NSString*)showDetailTime:(NSTimeInterval) msglastTime;
+ (NSString*)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail;

@end
