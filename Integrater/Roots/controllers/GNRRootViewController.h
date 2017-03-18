//
//  GNRRootViewController.h
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRBaseViewController.h"

@interface GNRRootViewController : GNRBaseViewController

@property (weak) IBOutlet NSTextField *pathProjectField;
@property (weak) IBOutlet NSTextField *schemeNameField;
@property (weak) IBOutlet NSTextField *pathArchiveField;
@property (weak) IBOutlet NSTextField *pathIPAField;
@property (weak) IBOutlet NSButton *startBtn;

@property (unsafe_unretained) IBOutlet NSTextView *printTextView;

//选择路径按钮
- (IBAction)selectPath:(id)sender;
//scheme 输入框改变 事件
- (IBAction)schemTextFieldAction:(id)sender;
//选择debug release 触发
- (IBAction)selectDebug:(id)sender;

//开始部署按钮事件
- (IBAction)startAction:(id)sender;

@end
