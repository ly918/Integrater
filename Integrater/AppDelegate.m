//
//  AppDelegate.m
//  Integrater
//
//  Created by LvYuan on 2017/3/17.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<NSUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    //通知测试
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"标题";
    notification.subtitle = @"小标题";
    notification.informativeText = @"BBBCCCCCBBBBBBBB";
    [notification setSoundName:NSUserNotificationDefaultSoundName];
     //设置通知提交的时间
    [notification setDeliveryDate:[NSDate dateWithTimeInterval:2 sinceDate:[NSDate date]]];
    
     //设置通知的循环(必须大于1分钟，估计是防止软件刷屏)
//     NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//     [dateComponents setSecond:70];
//     notification.deliveryRepeatInterval = dateComponents;
    
    //只有当用户设置为提示模式时，才会显示按钮
    notification.hasActionButton = YES;
    notification.actionButtonTitle = @"OK";
    notification.otherButtonTitle = @"Cancel";
    
    //递交通知
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];
    //设置通知的代理
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
//    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    /*
     
     //删除已经显示过的通知(已经存在用户的通知列表中的)
     [[NSUserNotificationCenter defaultUserNotificationCenter] removeAllDeliveredNotifications];
     //删除已经在执行的通知(比如那些循环递交的通知)
     for (NSUserNotification *notify in [[NSUserNotificationCenter defaultUserNotificationCenter] scheduledNotifications])
     {
     [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:notify];
     }
     
     
     */
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification
{
    NSLog(@"通知已经递交！");
}
- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification
{
    NSLog(@"用户点击了通知！");
}
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    //用户中心决定不显示该条通知(如果显示条数超过限制或重复通知等)，returen YES;强制显示
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
