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

@property (weak) IBOutlet NSTextField *projPathField;
@property (weak) IBOutlet NSTextField *archivePathField;
@property (weak) IBOutlet NSTextField *ipaPathField;

- (IBAction)selectProjPath:(id)sender;//本地工程目录
- (IBAction)selectDebug:(id)sender;
- (IBAction)selectArchivePath:(id)sender;
- (IBAction)selectIPAPath:(id)sender;

- (IBAction)closeAction:(id)sender;
- (IBAction)saveAction:(id)sender;

@end
