//
//  NSArray+JACoder.h
//  Daily_modules
//
//  Created by Jason on 09/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSArray (JACoder)
/**
 *  根据文件路径 输出所有文件名
 *
 *  @param dirString 文件路径
 *
 *  @return 所有文件
 */
- (NSArray *)allFilesAtPath:(NSString*)dirString;

/**
 *  交集:数组A与数组B共同拥有的集合元素
 *
 *  @param listB 当前与哪个数组进行求交集的操作
 *
 *  @return 交集
 */
- (NSArray *)interSet:(NSArray *)listB;

/**
 *  并集:既属于集合A又属于集合B的元素
 *
 *  @param listB 当前与哪个数组进行并集的操作
 *
 *  @return 并集
 */
- (NSArray *)unionSet:(NSArray *)listB;

/**
 *  差集:属于本身却不属于listB数组的集合 元素
 *
 *  @param listB 当前与哪个数组进行差集操作
 *
 *  @return 差集
 */
- (NSArray *)differenceSet:(NSArray *)listB;

/**
 *  指定数组是否内含于本身
 *
 *  @param listB 指定数组
 *
 *  @return 是否内含
 */
- (BOOL)isContains:(NSArray *)listB;

@end
