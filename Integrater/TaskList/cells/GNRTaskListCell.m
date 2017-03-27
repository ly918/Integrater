//
//  GNRTaskListCell.m
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskListCell.h"

@interface GNRTaskListCell ()<NSMenuDelegate>

@end

@implementation GNRTaskListCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (void)setModel:(GNRTaskListModel *)model{
    _model = model;
    if (model) {
        _nameL.stringValue = model.appName;
        _iconL.stringValue = model.iconLetter;
        _statusMsgL.stringValue = model.statusMsg;
        _updateTimeL.stringValue = model.lastTime;
        _progressIndicator.doubleValue = model.progress;
    }
}



@end
