//
//  GNRArchiveTask.m
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRArchiveTask.h"


@implementation GNRArchiveTask

- (void)setScriptFormat:(NSString *)scriptFormat{
    _scriptFormat = scriptFormat;
    if (scriptFormat) {
        _script = [[NSAppleScript alloc]initWithSource:scriptFormat];
    }
}

/**
 运行脚本
 */
- (NSDictionary *)runScrip{
    NSDictionary * error = nil;
    if (_script && canceled == NO) {
        error = [NSDictionary new];
        [self.script executeAndReturnError:&error];
    }
    return error;
}

- (void)cancel{
    [super cancel];
    _script = nil;
}

@end
