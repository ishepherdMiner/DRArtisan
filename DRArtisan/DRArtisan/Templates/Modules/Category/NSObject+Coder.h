//
//  NSObject+Coder.h
//
//  Copyright (c) 2015年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Coder)

+ (instancetype)objWithDic:(NSDictionary *)dic;

/**
 *  返回类的属性列表
 */
+ (NSArray *)jas_propertyList;

/**
 *  返回类的方法列表
 *
 *  @param cls 类
 */
+ (void)jas_methodList:(Class )cls;

@end

@interface NSObject (Deprecated)

@end
