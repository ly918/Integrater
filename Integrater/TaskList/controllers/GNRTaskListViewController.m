//
//  GNRTaskListViewController.m
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskListViewController.h"
#import "GNRTaskListCell.h"
#import "GNRTaskManager.h"
#import "GNRDBManager.h"

@interface GNRTaskListViewController ()<NSTableViewDelegate,NSTableViewDataSource,GNRTaskManagerDelegate>
{
    NSString * kTaskLiskCellID;
}
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *addTaskBtn;

@end

@implementation GNRTaskListViewController
//getter
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self configUI];
}

- (void)initData{
    [[GNRTaskManager manager] setDelegate:self];
    [self reloadData];
}

- (void)reloadData{
    [self refreshUI];

}

- (void)configUI{
    kTaskLiskCellID = @"GNRTaskListCell";
    NSNib * nib = [[NSNib alloc]initWithNibNamed:kTaskLiskCellID bundle:nil];
    [self.tableView registerNib:nib forIdentifier:kTaskLiskCellID];
}

- (void)refreshUI{
    [self.tableView reloadData];

    if ([[GNRTaskManager manager] taskListModels].count) {
        _addTaskBtn.hidden = YES;
    }else{
        _addTaskBtn.hidden = NO;
    }
}

#pragma mark - table delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [[GNRTaskManager manager] taskListModels].count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    GNRTaskListCell * cell = (GNRTaskListCell *)[tableView makeViewWithIdentifier:kTaskLiskCellID owner:self];
    GNRTaskListModel * model = [[[GNRTaskManager manager] taskListModels] objectAtIndex:row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 80.f;
}

- (CGFloat)tableView:(NSTableView *)tableView sizeToFitWidthOfColumn:(NSInteger)column{
    return tableView.bounds.size.width;
}

- (void)updateListModel:(GNRTaskListModel *)model status:(GNRTaskStatus *)status{
    
    if (status && model) {
        model.statusMsg = status.statusMsg;
        model.progress = status.progress;
        model.lastTime = status.showTime;
        if (status.taskStatus<0) {
            model.textColor = [NSColor redColor];
        }else if(status.taskStatus>0){
            model.textColor = [NSColor greenColor];
        }
    }
}

- (void)reloadRow:(NSInteger)row{
    [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
}

#pragma mark - task manager delegate
- (void)manager:(GNRTaskManager *)manager addTask:(GNRIntegrater *)task taskListModel:(GNRTaskListModel *)taskListModel{
    [self reloadData];
    WEAK_SELF;
    [task taskStatusCallback:^(GNRTaskStatus * status) {
        [wself updateListModel:taskListModel status:status];
        [wself reloadRow:[[[GNRTaskManager manager] taskListModels] indexOfObject:taskListModel]];
    }];
}

- (void)manager:(GNRTaskManager *)manager removeTask:(GNRIntegrater *)task taskListModel:(GNRTaskListModel *)taskListModel{
    [self reloadData];
}

@end
