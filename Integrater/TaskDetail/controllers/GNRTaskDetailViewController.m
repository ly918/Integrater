//
//  GNRTaskDetailViewController.m
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskDetailViewController.h"

@interface GNRTaskDetailViewController ()

@end

@implementation GNRTaskDetailViewController

- (void)dealloc{
    GLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self installUI];
}

- (void)installUI{
    [self.view addSubview:self.toolBar];
    self.toolBar.frame = CGRectMake((self.view.bounds.size.width - _toolBar.bounds.size.width)/2.0, (self.view.bounds.size.height - _toolBar.bounds.size.height)/2.0 - 8.f, self.view.bounds.size.width, self.view.bounds.size.height);
    
    
}

- (IBAction)closeAction:(id)sender {
    [self dismissController:nil];
}

- (IBAction)saveAction:(id)sender {
    
}

@end
