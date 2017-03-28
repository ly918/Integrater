//
//  AppDelegate.m
//  Integrater
//
//  Created by LvYuan on 2017/3/17.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "AppDelegate.h"
#import "GNRUserNotificationCenter.h"

@interface AppDelegate ()<NSUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[GNRUserNotificationCenter center] pushTitle:@"哈哈哈哈" msg:@"哈师大哈斯大市口街道哈匡山街道哈框架"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
