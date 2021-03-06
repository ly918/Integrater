//
//  GNRTaskDetailViewController.h
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRBaseViewController.h"

@class GNRTaskInfo;

@interface GNRTaskDetailViewController : GNRBaseViewController
//编辑时传
@property (nonatomic, strong)GNRTaskInfo * taskInfo;

@property (strong) IBOutlet NSTabView *tabView;
@property (strong) IBOutlet NSView *toolBar;
@property (weak) IBOutlet NSButton *saveBtn;

@property (weak) IBOutlet NSTextField *projPathField;
@property (weak) IBOutlet NSTextField *archivePathField;

@property (weak) IBOutlet NSTextField *uploadUrlField;
@property (weak) IBOutlet NSTextField *appkeyField;
@property (weak) IBOutlet NSTextField *userKeyField;
@property (weak) IBOutlet NSPopUpButton *selectSubmitBtn;
@property (weak) IBOutlet NSTextField *bundleIDField;
@property (weak) IBOutlet NSTextField *profileField;

- (IBAction)selectProjPath:(id)sender;//本地工程目录

- (IBAction)selectDebug:(id)sender;
- (IBAction)selectArchivePath:(id)sender;

- (IBAction)closeAction:(id)sender;
- (IBAction)saveAction:(id)sender;
//选择发布环境
- (IBAction)selectSubmit:(id)sender;

@end
