//
//  GNRArchiveTask.h
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRBaseTask.h"

@interface GNRArchiveTask : GNRBaseTask

@property (nonatomic, strong)NSString * scriptFormat;//脚本格式字符串
@property (nonatomic, strong, readonly)NSAppleScript * script;//脚本

/**
 运行脚本
 
 @return error
 */
- (NSDictionary *)runScrip;

- (void)stop;

@end
