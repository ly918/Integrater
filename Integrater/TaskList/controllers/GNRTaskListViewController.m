//
//  GNRTaskListViewController.m
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskListViewController.h"
#import "GNRTaskListCell.h"


@interface GNRTaskListViewController ()<NSTableViewDelegate,NSTableViewDataSource>
{
    NSString * kTaskLiskCellID;
}
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSButton *addTaskBtn;
@property (nonatomic, strong)NSMutableArray * taskList;

@end

@implementation GNRTaskListViewController
//getter
- (NSMutableArray *)taskList{
    if (!_taskList) {
        _taskList = [NSMutableArray array];
    }
    return _taskList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self configUI];

}

- (void)initData{
    kTaskLiskCellID = @"GNRTaskListCell";
    for (int i=0; i<26; i++) {
        GNRTaskListModel * model = [GNRTaskListModel new];
        NSString * ch = [NSString stringWithFormat:@"%c",i+'A'];
        model.appName = [NSString stringWithFormat:@"%@ app name",ch];
        model.iconLetter = ch;
        model.statusMsg = @"状态描述";
        model.lastTime = [GNRUtil showDetailTime:[[NSDate date] timeIntervalSince1970]];
        model.progress = rand()%100;
        [self.taskList addObject:model];
    }
    [self refreshUI];
}

- (void)configUI{
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
    return self.taskList.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    GNRTaskListCell * cell = (GNRTaskListCell *)[tableView makeViewWithIdentifier:kTaskLiskCellID owner:self];
    GNRTaskListModel * model = [self.taskList objectAtIndex:row];
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
