//
//  GNRTaskListViewController.h
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRBaseViewController.h"
@class GNRTaskListModel;
@interface GNRTaskListViewController : GNRBaseViewController
#pragma mark - show detail
- (void)showDetail:(GNRTaskListModel *)model;
@end
