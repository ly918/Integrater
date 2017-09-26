//
//  GNRTaskDetailViewController.m
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskDetailViewController.h"
#import "GNRTaskManager.h"
#import "GNRTaskInfo.h"

@interface GNRTaskDetailViewController ()
{
    //临时存储
    NSString * _apikey_local;
    NSString * _userkey_local;
    NSString * _apikey_formal;
    NSString * _userkey_formal;
}

@property (nonatomic, assign)BOOL isEdit;

@end

@implementation GNRTaskDetailViewController

- (void)dealloc{
    GLog(@"dealloc");
}

//getter
- (GNRTaskInfo *)taskInfo{
    if (!_taskInfo) {
        _taskInfo = [GNRTaskInfo new];
    }
    return _taskInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self installUI];
}

- (void)initData{
    _apikey_local = @"";
    _userkey_local = @"";
    _apikey_formal = @"";
    _userkey_formal = @"";
}

- (void)installUI{
    [self.view addSubview:self.toolBar];
    self.toolBar.frame = CGRectMake((self.view.bounds.size.width - _toolBar.bounds.size.width)/2.0, (self.view.bounds.size.height - _toolBar.bounds.size.height)/2.0 - 8.f, self.view.bounds.size.width, self.view.bounds.size.height);
    [self showEditForTaskInfo];
}



//MARK: - proj path
- (IBAction)selectProjPath:(id)sender {
    NSString * path = [GNRUtil openPanelForCanCreateDir:YES canChooseDir:YES canChooseFiles:NO];
    _projPathField.stringValue = path;
}

- (IBAction)selectDebug:(id)sender {
    self.taskInfo.configuration = [(NSMenu *)sender title];
}

- (IBAction)selectArchivePath:(id)sender {
    NSString * path = [GNRUtil openPanelForCanCreateDir:YES canChooseDir:YES canChooseFiles:NO];
    _archivePathField.stringValue = path;
}

//MARK: - toolbar
- (IBAction)closeAction:(id)sender {
    [self dismissController:nil];
}

- (IBAction)saveAction:(id)sender {
    if ([GNRHelper validPath:_projPathField.stringValue]==NO) {
        [GNRUtil alertMessage:@"请选择本地工程目录"];
        return;
    }
    if ([GNRHelper validPath:_archivePathField.stringValue]==NO) {
        [GNRUtil alertMessage:@"请archive输出目录"];
        return;
    }

    if ([_selectSubmitBtn.selectedItem.title isEqualToString:@"本地"]) {
        _apikey_local = _appkeyField.stringValue;
        _userkey_local = _userKeyField.stringValue;
    }else{
        _apikey_formal = _appkeyField.stringValue;
        _userkey_formal = _userKeyField.stringValue;
    }
    
    self.taskInfo.projectDir = _projPathField.stringValue;//本地工程目录
    self.taskInfo.archivePath = _archivePathField.stringValue;
    self.taskInfo.uploadURL = _uploadUrlField.stringValue;
    self.taskInfo.appkey = _apikey_local;
    self.taskInfo.userkey = _userkey_local;
    self.taskInfo.appkey_formal = _apikey_formal;
    self.taskInfo.userkey_formal = _userkey_formal;
    self.taskInfo.bundleId = _bundleIDField.stringValue;
    self.taskInfo.profile_dev = _profileField.stringValue;
    
    [self.taskInfo configValues];

    if (![self check]) {
        return;
    }

    [self saveTask];
}

//MARK: - 保存该任务
- (void)saveTask{
    GLog(@"%@",self.taskInfo);
    if (_isEdit) {
        //编辑保存操作
        //更新task & taskInfo & DB
        [[GNRTaskManager manager] updateTaskInfo:self.taskInfo];
        [self dismissController:nil];
    }else{
        if ([[GNRTaskManager manager] isExsitsTask:self.taskInfo.taskName] == NO) {
            GNRIntegrater * task = [[GNRIntegrater alloc]initWithTaskInfo:self.taskInfo];
            [[GNRTaskManager manager] addTask:task];
            [self dismissController:nil];
        }else{
            [GNRUtil alertMessage:@"该任务已存在！"];
        }
    }
}

- (BOOL)check{
    if (!self.taskInfo.taskName.length||
        !self.taskInfo.schemeName.length||
        !self.taskInfo.bundleId.length||
        !self.taskInfo.profile_dev.length) {
        [GNRUtil alertMessage:@"请完善Project选项卡！"];
        return NO;
    }
    return YES;
}

//编辑任务信息
- (void)showEditForTaskInfo{
    
    if (_taskInfo) {
        _isEdit = YES;
        _apikey_local = _taskInfo.appkey?:@"";
        _userkey_local = _taskInfo.userkey?:@"";
        _apikey_formal = _taskInfo.appkey_formal?:@"";
        _userkey_formal = _taskInfo.userkey_formal?:@"";
        _projPathField.stringValue = _taskInfo.projectDir?:@"";
        _archivePathField.stringValue = _taskInfo.archivePath?:@"";
        _uploadUrlField.stringValue = _taskInfo.uploadURL?:@"";
        _appkeyField.stringValue = _apikey_local?:@"";
        _userKeyField.stringValue = _userkey_local?:@"";
        _bundleIDField.stringValue = _taskInfo.bundleId?:@"";
        _profileField.stringValue = _taskInfo.profile_dev?:@"";
    }
    
    [_saveBtn setTitle:_isEdit?@"应用":@"添加"];
    [_projPathField setRefusesFirstResponder:_isEdit];
    [_archivePathField setRefusesFirstResponder:_isEdit];
    [_uploadUrlField setRefusesFirstResponder:_isEdit];
    [_appkeyField setRefusesFirstResponder:_isEdit];
    [_userKeyField setRefusesFirstResponder:_isEdit];
    [_bundleIDField setRefusesFirstResponder:_isEdit];
    [_profileField setRefusesFirstResponder:_isEdit];
}

- (IBAction)selectSubmit:(id)sender {
    if ([[(NSMenu *)sender title] isEqualToString:@"本地"]) {//本地
        _apikey_formal = _appkeyField.stringValue;
        _userkey_formal = _userKeyField.stringValue;
        _appkeyField.stringValue = _apikey_local;
        _userKeyField.stringValue = _userkey_local;
        _appkeyField.placeholderString = @"请填写本地ApiKey";
        _userKeyField.placeholderString = @"请填写本地UserKey";
    }else{//线上
        _apikey_local = _appkeyField.stringValue;
        _userkey_local = _userKeyField.stringValue;
        _appkeyField.stringValue = _apikey_formal;
        _userKeyField.stringValue = _userkey_formal;
        _appkeyField.placeholderString = @"请填写线上ApiKey";
        _userKeyField.placeholderString = @"请填写线上UserKey";
    }
}

@end
