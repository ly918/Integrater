//
//  GNRRootViewController.m
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRRootViewController.h"
#import "GNRIntegrater.h"

@interface GNRRootViewController ()
@property (nonatomic, strong)GNRTaskInfo * taskInfo;
@property (nonatomic, strong)GNRIntegrater * integrater;
@property (nonatomic, assign)BOOL runing;

@end

@implementation GNRRootViewController

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
    self.runing = NO;
    [self initIntegrater];
}

- (void)initIntegrater{
    self.taskInfo.platform = GNRTaskInfoPlatform_iOS;
}

//选择路径按钮
- (IBAction)selectPath:(id)sender{
    NSButton * button = sender;
    NSString * path = [self openPanelForCanCreateDir:button.tag==1||button.tag==2];
    [self selectPathWithTag:button.tag
                       path:path];
}

//文件选择面板
- (NSString *)openPanelForCanCreateDir:(BOOL)canCreateDir{
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel setMessage:canCreateDir?@"请选择文件夹":@"请选择文件"];
    [panel setPrompt:@"确定"];
    [panel setCanChooseDirectories:canCreateDir];//是否可选择目录
    [panel setCanCreateDirectories:canCreateDir];//是否可创建目录
    [panel setCanChooseFiles:!canCreateDir];//是否可选择文件
    NSString * path = nil;
    NSInteger result = [panel runModal];
    if (result == NSFileHandlingPanelOKButton) {
        path = [panel URL].path;
    }
    return path;
}

//选择路径
- (void)selectPathWithTag:(NSInteger)tag path:(NSString *)path{
    if ([self validPath:path]==NO) {
        return;
    }
    switch (tag) {
        case 0://project path
        {
            _taskInfo.projectPath = path;
            _pathProjectField.stringValue = path;
        }
            break;
        case 1://archive path
        {
            _taskInfo.archivePath = path;
            _pathArchiveField.stringValue = path;
        }
            break;
        case 2://ipa path
        {
            _pathIPAField.stringValue = path;
        }
            break;
        default:
            break;
    }
}

- (BOOL)validPath:(NSString *)path{
    return path.length;
}

//选择debug release 触发
- (IBAction)selectDebug:(id)sender{
    _taskInfo.configuration = [(NSMenu *)sender title];
}

//MARK: - 开始点击 事件
- (IBAction)startAction:(id)sender {
    if (_runing==NO) {
        [self startTask];
    }else{
        [self stopTask];
    }
}

- (IBAction)closeAction:(id)sender {
    [self dismissController:nil];
}

- (void)startTask{
    self.runing = YES;
    _taskInfo.schemeName = _schemeNameField.stringValue;
    _integrater = [[GNRIntegrater new]initWithTaskInfo:_taskInfo];
    
    WEAK_SELF;
    [_integrater runTask];
    [_integrater taskStatusCallback:^(GNRTaskStatus * taskStatus) {
        wself.printTextView.string = taskStatus.statusMsg;
    }];
}

- (void)stopTask{
    self.runing = NO;
}

- (void)setRuning:(BOOL)runing{
    _runing = runing;
    [self updateStartBtnState];
}

- (void)updateStartBtnState{
    [_startBtn setTitle:_runing?@"执行中，点击停止":@"开始执行"];
}

@end
