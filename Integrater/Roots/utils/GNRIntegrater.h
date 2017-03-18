//
//  GNRTaskManager.h
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRObject.h"
#import "GNRArchiveTask.h"
#import "GNRGitTask.h"
#import "GNRUploadTask.h"
#import "GNRTaskInfo.h"
@interface GNRIntegrater : GNRObject

/**
 初始化方法

 @param name 给我起个别名吧 有名了我才能加入队列
 @return self
 */
- (instancetype)initWithName:(NSString *)name;

/**
 执行打包任务

 @param taskInfo 打包信息
 @param completion 回调 成功 或 失败
 @return self
 */
- (GNRIntegrater *)runTaskInfo:(GNRTaskInfo *)taskInfo completion:(void(^)(BOOL,NSString *,GNRError *))completion;

@end
