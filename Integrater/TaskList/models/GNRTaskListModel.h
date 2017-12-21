//
//  GNRTaskListModel.h
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRObject.h"

@interface GNRTaskListModel : GNRObject
@property (nonatomic, copy) NSString * Id;

@property (nonatomic, copy) NSString * taskName;
@property (nonatomic, copy) NSString * appName;

@property (nonatomic, copy) NSString * iconLetter;

@property (nonatomic, copy) NSString * statusMsg;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * lastTime;

@property (nonatomic, copy) NSColor * textColor;

@property (nonatomic, assign) BOOL submit_formal;//发布到线上？
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) NSString * downloadUrl;

- (instancetype)initWithId:(NSString *)Id taskName:(NSString *)taskName appName:(NSString *)appName;

@end
