//
//  GNRTaskListCell.h
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GNRTaskListModel.h"

@class GNRTaskListCell;
@protocol GNRTaskListCellDelegate <NSObject>

- (void)cell:(GNRTaskListCell *)cell editTaskListModel:(GNRTaskListModel *)model;
- (void)cell:(GNRTaskListCell *)cell deleteTaskListModel:(GNRTaskListModel *)model;

@end

@interface GNRTaskListCell : NSTableCellView

@property (nonatomic, weak)id<GNRTaskListCellDelegate> delegate;

@property (weak) IBOutlet NSTextField *iconL;
@property (weak) IBOutlet NSTextField *nameL;
@property (weak) IBOutlet NSTextField *statusMsgL;
@property (weak) IBOutlet NSTextField *updateTimeL;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (weak) IBOutlet NSTextField *submitL;

@property (weak) IBOutlet NSButton *checkErrorBtn;

@property (nonatomic, strong)GNRTaskListModel * model;


@end
