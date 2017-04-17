//
//  AppDelegate.m
//  Integrater
//
//  Created by LvYuan on 2017/3/17.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "AppDelegate.h"
#import "GNRWindow.h"
#import "GNRTaskListViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong)GNRWindow * rootWindow;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSButton *closeButton = [[[NSApplication sharedApplication]keyWindow] standardWindowButton:NSWindowCloseButton];
    [closeButton setTarget:self];
    [closeButton setAction:@selector(closeApplication)];
}

- (void) closeApplication {
    [[NSApplication sharedApplication] terminate:nil];
}

- (IBAction)createNewTask:(id)sender {
    GNRTaskListViewController * taskList = (GNRTaskListViewController *)[[NSApplication sharedApplication].keyWindow contentViewController];
    [taskList showDetail:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {

}


@end
