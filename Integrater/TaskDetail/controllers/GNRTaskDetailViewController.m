//
//  GNRTaskDetailViewController.m
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRTaskDetailViewController.h"
#import "GNRTaskManager.h"

@interface GNRTaskDetailViewController ()

@property (nonatomic, strong) GNRTaskInfo * taskInfo;

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
    [self installUI];
}

- (void)installUI{
    [self.view addSubview:self.toolBar];
    self.toolBar.frame = CGRectMake((self.view.bounds.size.width - _toolBar.bounds.size.width)/2.0, (self.view.bounds.size.height - _toolBar.bounds.size.height)/2.0 - 8.f, self.view.bounds.size.width, self.view.bounds.size.height);
    
    
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
    if ([GNRHelper validPath:_uploadUrlField.stringValue]==NO) {
        [GNRUtil alertMessage:@"请填写ipa上传URL"];
        return;
    }
    if ([GNRHelper validPath:_appkeyField.stringValue]==NO) {
        [GNRUtil alertMessage:@"请填写appkey"];
        return;
    }
    if ([GNRHelper validPath:_userKeyField.stringValue]==NO) {
        [GNRUtil alertMessage:@"请填写userkey"];
        return;
    }
    
    self.taskInfo.projectDir = _projPathField.stringValue;//本地工程目录
    self.taskInfo.archivePath = _archivePathField.stringValue;
    self.taskInfo.uploadURL = _uploadUrlField.stringValue;
    self.taskInfo.appkey = _appkeyField.stringValue;
    self.taskInfo.userkey = _userKeyField.stringValue;

    [self saveTask];
}

//MARK: - 保存该任务
- (void)saveTask{
    [self.taskInfo configValues];
    GLog(@"%@",self.taskInfo);
    GNRIntegrater * task = [[GNRIntegrater alloc]initWithTaskInfo:self.taskInfo];
    [[GNRTaskManager manager] addTask:task];
    [self dismissController:nil];
}

@end
