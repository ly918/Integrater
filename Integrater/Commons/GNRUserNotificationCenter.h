//
//  GNRUserNotificationCenter.h
//  Integrater
//
//  Created by LvYuan on 2017/3/28.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRObject.h"

@interface GNRUserNotificationCenter : GNRObject

+ (instancetype)center;

- (void)pushTitle:(NSString *)title msg:(NSString *)msg;

- (void)removeAllNotification;

@end
