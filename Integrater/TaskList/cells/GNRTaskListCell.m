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
{
    GNRIntegrater * _theTask;
}
@property (weak) IBOutlet NSMenuItem *startItem;
@property (weak) IBOutlet NSMenuItem *editItem;
@property (weak) IBOutlet NSMenuItem *deleteItem;

@end

@implementation GNRTaskListCell

- (IBAction)startMenuAction:(id)sender {
    if (_theTask) {
        if (_theTask.running) {
            [_theTask stopTask];
        }else{
            [_theTask runTask];
        }
        [_startItem setTitle:_theTask.running?@"停止任务":@"开始任务"];
    }
}

- (IBAction)editMenuAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(cell:editTaskListModel:)]) {
        [_delegate cell:self editTaskListModel:_model];
    }
}

- (IBAction)deleteMenuAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(cell:deleteTaskListModel:)]) {
        [_delegate cell:self deleteTaskListModel:_model];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}


- (void)setModel:(GNRTaskListModel *)model{
    _model = model;
    if (model) {
        _nameL.stringValue = _model.appName;
        _iconL.stringValue = _model.iconLetter;
        _statusMsgL.stringValue = _model.statusMsg;
        _updateTimeL.stringValue = [self showTime];
        _statusMsgL.textColor = _model.textColor;
        _progressIndicator.doubleValue = _model.progress;
        _progressIndicator.hidden = _model.progress==_progressIndicator.maxValue?YES:NO;
        
        _theTask = self.theTask;
        _checkErrorBtn.hidden = _theTask.taskStatus.taskStatus>=0;
        [_startItem setTitle:_theTask.running?@"停止任务":@"开始任务"];
    }
}

- (GNRIntegrater *)theTask{
    GNRIntegrater * task = nil;
    if (_model) {
        task = [[GNRTaskManager manager]getTaskWithModel:_model];
    }
    return task;
}

- (NSString *)showTime{
    NSString * timeStr = _model.lastTime.length?_model.lastTime:_model.createTime;
    timeStr = [GNRUtil showDetailTime:timeStr.integerValue];
    return [NSString stringWithFormat:@"%@：%@",_model.lastTime.length?@"最后更新":@"创建时间",timeStr];
}

- (IBAction)errorLogAction:(id)sender {
    NSString * error = @"Unkown error！";
    if (_theTask) {
        NSError * tErr = _theTask.taskStatus.error;
        error = [NSString stringWithFormat:@"error code %d\n\n%@",(int)tErr.code,tErr.description];
        
    }
    [GNRUtil alertMessage:error];
}

@end
