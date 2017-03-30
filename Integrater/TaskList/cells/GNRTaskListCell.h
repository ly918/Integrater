//
//  GNRTaskListCell.h
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GNRTaskListModel.h"

@interface GNRTaskListCell : NSTableCellView

@property (weak) IBOutlet NSTextField *iconL;
@property (weak) IBOutlet NSTextField *nameL;
@property (weak) IBOutlet NSTextField *statusMsgL;
@property (weak) IBOutlet NSTextField *updateTimeL;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@property (weak) IBOutlet NSButton *errorLogBtn;

@property (nonatomic, strong)GNRTaskListModel * model;


@end
