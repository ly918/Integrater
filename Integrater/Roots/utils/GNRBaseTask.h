//
//  GNRBaseTask.h
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRObject.h"
#import "GNRHeader.h"
@interface GNRBaseTask : GNRObject
{
    BOOL canceled;//已取消
}
@property (nonatomic, strong)NSString * identifier;//任务标识
- (void)cancel;//子类实现
@end
