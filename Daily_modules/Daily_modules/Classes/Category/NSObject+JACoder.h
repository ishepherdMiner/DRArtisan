//
//  NSObject+JACoder.h
//  Daily_modules
//
//  Created by Jason on 09/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

// Decide by developer
#define JADEBUG DEBUG

/*============================
 *           列表
 *============================
 * 交换方法
 * 属性列表
 * 变量列表
 * 方法列表
 * 清空缓存列表
 *============================*/

@interface NSObject (JACoder)

#if JADEBUG

/**
 交换方法

 @param cls 类
 @param originSel 原始方法
 @param swizzlSel 目标方法
 */
+ (void)hookMethod:(Class)cls OriginSelector:(SEL)originSel SwizzledSelector:(SEL)swizzlSel;

/**
 属性列表
 
 @param recursive 是否递归
 @return 属性列表
 */
- (NSArray *)p_propertyList:(BOOL)recursive;

/**
 变量列表
 
 @param recursive 是否递归
 @return 变量列表
 */
- (NSArray *)p_ivarList:(BOOL)recursive;

/**
 * 方法列表
 *
 * @param recursive 是否递归
 */
- (NSArray *)p_methodList:(BOOL)recursive;


/**
 清空缓存列表
 */
- (void)p_cleanCacheList;

#endif

@end
