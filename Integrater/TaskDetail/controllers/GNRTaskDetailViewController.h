//
//  GNRTaskDetailViewController.h
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRBaseViewController.h"

@interface GNRTaskDetailViewController : GNRBaseViewController

@property (strong) IBOutlet NSTabView *tabView;
@property (strong) IBOutlet NSView *toolBar;
@property (weak) IBOutlet NSButton *saveBtn;

- (IBAction)closeAction:(id)sender;
- (IBAction)saveAction:(id)sender;

@end
