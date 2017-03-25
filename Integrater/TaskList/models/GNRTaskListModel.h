//
//  GNRTaskListModel.h
//  Integrater
//
//  Created by LvYuan on 2017/3/25.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import "GNRObject.h"

@interface GNRTaskListModel : GNRObject

@property (nonatomic, copy) NSString * appName;
@property (nonatomic, copy) NSString * iconLetter;
@property (nonatomic, copy) NSString * statusMsg;
@property (nonatomic, copy) NSString * lastTime;
@property (nonatomic, assign) CGFloat progress;

@end
