//
//  GNRUploadTask.h
//  Integrater
//
//  Created by LvYuan on 2017/3/18.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRBaseTask.h"

@interface GNRUploadTask : GNRBaseTask

@property (nonatomic, copy)NSString * uploadUrl;
@property (nonatomic, copy)NSString * appkey;
@property (nonatomic, copy)NSString * userkey;
@property (nonatomic, copy)NSString * importIPAPath;

- (void)uploadIPAWithrogress:(void(^)(NSProgress *))progress completion:(void(^)(BOOL,id responseObject,NSError *))completion;

- (void)cancel;

@end
