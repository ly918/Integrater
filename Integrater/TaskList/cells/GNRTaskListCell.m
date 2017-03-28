//
//  GNRTaskListCell.m
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskListCell.h"
#import "GNRTaskManager.h"

@interface GNRTaskListCell ()<NSMenuDelegate>

@end

@implementation GNRTaskListCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (void)setModel:(GNRTaskListModel *)model{
    _model = model;
    if (model) {
        _nameL.stringValue = _model.appName;
        _iconL.stringValue = _model.iconLetter;
        _statusMsgL.stringValue = _model.statusMsg;
        _updateTimeL.stringValue = [NSString stringWithFormat:@"最后更新：%@",_model.lastTime];
        _statusMsgL.textColor = _model.textColor;
        _progressIndicator.doubleValue = _model.progress;
        _progressIndicator.hidden = _model.progress==_progressIndicator.maxValue?YES:NO;
    }
}

@end
