//
//  GNRBaseTask.m
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRBaseTask.h"

@implementation GNRBaseTask

- (void)dealloc{
    GLog(@"%@",_identifier);
}

- (void)cancel{
    canceled = YES;
}

@end
