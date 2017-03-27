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

@interface GNRTaskListViewController ()<NSTableViewDelegate,NSTableViewDataSource>
{
    NSString * kTaskLiskCellID;
    NSMutableArray * _taskList;
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
    _taskList = [[GNRTaskManager manager]taskListModels];
    [self refreshUI];
}

- (void)configUI{
    kTaskLiskCellID = @"GNRTaskListCell";
    NSNib * nib = [[NSNib alloc]initWithNibNamed:kTaskLiskCellID bundle:nil];
    [self.tableView registerNib:nib forIdentifier:kTaskLiskCellID];
}

- (void)refreshUI{
    [self.tableView reloadData];
    
    if (_taskList.count) {
        _addTaskBtn.hidden = YES;
    }else{
        _addTaskBtn.hidden = NO;
    }
}

#pragma mark - table delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return _taskList.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    GNRTaskListCell * cell = (GNRTaskListCell *)[tableView makeViewWithIdentifier:kTaskLiskCellID owner:self];
    GNRTaskListModel * model = [_taskList objectAtIndex:row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 80.f;
}

- (CGFloat)tableView:(NSTableView *)tableView sizeToFitWidthOfColumn:(NSInteger)column{
    return tableView.bounds.size.width;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    NSLog(@"%@",tableColumn);
}

@end
