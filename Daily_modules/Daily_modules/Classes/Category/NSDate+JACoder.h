//
//  NSDate+JACoder.h
//  Daily_modules
//
//  Created by Jason on 13/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JACoder)
/**
 *  字符串转NSDate
 *
 *  @param timeStr 字符串时间
 *  @param format  转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 日期格式
 */
+ (NSDate *)ja_dateFromString:(NSString *)timeStr
                       format:(NSString *)format;

/**
 *  NSDate转时间戳
 *
 *  @param date 字符串时间
 *
 *  @return 返回时间戳
 */
+ (NSInteger)ja_cTimestampFromDate:(NSDate *)date;

/**
 *  时间戳转Date字符串
 *
 *  @param timeStamp 时间戳
 *  @param format    转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)ja_dateStrFromCstampTime:(NSInteger)timeStamp
                        withDateFormat:(NSString *)format;

/**
 *  字符串转时间戳
 *
 *  @param timeStr 字符串时间
 *  @param format  转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回时间戳的字符串
 */
+ (NSInteger)ja_cTimestampFromString:(NSString *)timeStr
                          format:(NSString *)format;

/**
 *  NSDate转字符串
 *
 *  @param date   NSDate时间
 *  @param format 转化格式 如yyyy-MM-dd HH:mm:ss,即2015-07-15 15:00:00
 *
 *  @return 返回字符串格式时间
 */
+ (NSString *)ja_datestrFromDate:(NSDate *)date
                  withDateFormat:(NSString *)format;

/**
 *  返回当前的日期信息
 *
 *  @return NSDateComponents
 */
+ (NSDateComponents *)ja_currentComponents;


/**
 将16进制的字符串转换为NSData对象

 @param str 16进制字符串
 @return NSData对象
 */
+ (NSData *)ja_dataWithHexString:(NSString *)str;

/**
 判断是否同一天(依赖本地时间)

 @return 是否是同一个天
 */
+ (BOOL)ja_isDiffDay;

@end
