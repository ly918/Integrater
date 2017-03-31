//
//  GNRTaskListViewController.m
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskListViewController.h"
#import "GNRTaskDetailViewController.h"

#import "GNRTaskListCell.h"
#import "GNRTaskManager.h"
#import "GNRDBManager.h"

@interface GNRTaskListViewController ()<NSTableViewDelegate,NSTableViewDataSource,GNRTaskManagerDelegate,GNRTaskListCellDelegate>
{
    NSString * kTaskLiskCellID;
}
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *addTaskBtn;
@property (nonatomic, strong) NSMutableArray * models;

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
    [[GNRTaskManager manager] readTaskInfoListFromDB];
    _models = [[GNRTaskManager manager] taskListModels];
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
    return _models.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    GNRTaskListCell * cell = (GNRTaskListCell *)[tableView makeViewWithIdentifier:kTaskLiskCellID owner:self];
    GNRTaskListModel * model = [_models objectAtIndex:row];
    cell.model = model;
    cell.delegate= self;
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 80.f;
}

- (CGFloat)tableView:(NSTableView *)tableView sizeToFitWidthOfColumn:(NSInteger)column{
    return tableView.bounds.size.width;
}

- (void)reloadRow:(NSInteger)row{
    [self.tableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row] columnIndexes:[NSIndexSet indexSetWithIndex:0]];
}

#pragma mark - task manager delegate
- (void)manager:(GNRTaskManager *)manager addTask:(GNRIntegrater *)task taskListModel:(GNRTaskListModel *)taskListModel{
    [self reloadData];
    WEAK_SELF;
    [task taskStatusCallback:^(GNRTaskStatus * status) {
        [[GNRTaskManager manager] updateListModel:taskListModel status:status];
        [wself reloadRow:[_models indexOfObject:taskListModel]];
    }];
}

- (void)manager:(GNRTaskManager *)manager readTask_DB:(GNRIntegrater *)task taskListModel:(GNRTaskListModel *)taskListModel{
    [self reloadData];
    WEAK_SELF;
    [task taskStatusCallback:^(GNRTaskStatus * status) {
        [[GNRTaskManager manager] updateListModel:taskListModel status:status];
        [wself reloadRow:[_models indexOfObject:taskListModel]];
    }];
}

- (void)manager:(GNRTaskManager *)manager removeTask:(GNRIntegrater *)task taskListModel:(GNRTaskListModel *)taskListModel{
    [self reloadData];
}

- (void)cell:(GNRTaskListCell *)cell editTaskListModel:(GNRTaskListModel *)model{
    [self showDetail:model];
}

- (void)cell:(GNRTaskListCell *)cell deleteTaskListModel:(GNRTaskListModel *)model{
    [GNRUtil alertMessage:@"您确认删除么？" completion:^(NSModalResponse returnCode) {
        if (returnCode==1000) {
            GNRIntegrater * task = [[GNRTaskManager manager]getTaskWithModel:model];
            [[GNRTaskManager manager]removeTask:task];
        }
    }];
}

#pragma mark - show detail
- (void)showDetail:(GNRTaskListModel *)model{
    GNRIntegrater * task = [[GNRTaskManager manager]getTaskWithModel:model];
    
    NSStoryboard * SB = [NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    GNRTaskDetailViewController * detail = (GNRTaskDetailViewController *)[SB instantiateControllerWithIdentifier:@"GNRTaskDetailViewController"];
    detail.taskInfo = task.taskInfo;
    [self presentViewControllerAsSheet:detail];
}

@end
