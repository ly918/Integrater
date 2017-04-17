//
//  NSObject+Extension.h
//  Integrater
//
//  Created by LvYuan on 2017/3/27.
//  Copyright © 2017年 LvYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Extension)

/* 获取对象的所有属性和属性内容 */
- (NSDictionary *)getAllPropertiesAndVaules;
/* 获取对象的所有属性 */
- (NSArray *)getAllProperties;
/* 获取对象的所有方法 */
- (void)getAllMethods;

@end
