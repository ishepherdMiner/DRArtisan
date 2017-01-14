//
//  NSDate+JACoder.m
//  Daily_modules
//
//  Created by Jason on 13/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "NSDate+JACoder.h"

@implementation NSDate (JACoder)
static NSDateFormatter *dateFormatter;

+ (NSDateFormatter *)defaultFormatter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [dateFormatter setTimeZone:timeZone];
    });
    return dateFormatter;
}

+ (NSDate *)dateFromString:(NSString *)timeStr
                    format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [NSDate defaultFormatter];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    return date;
}

+ (NSInteger)cTimestampFromDate:(NSDate *)date{
    return (long)[date timeIntervalSince1970];
}

+ (NSInteger)cTimestampFromString:(NSString *)timeStr
                           format:(NSString *)format
{
    NSDate *date = [NSDate dateFromString:timeStr format:format];
    return [NSDate cTimestampFromDate:date];
}

+ (NSString *)dateStrFromCstampTime:(NSInteger)timeStamp
                     withDateFormat:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    return [NSDate datestrFromDate:date withDateFormat:format];
}

+ (NSString *)datestrFromDate:(NSDate *)date
               withDateFormat:(NSString *)format
{
    NSDateFormatter* dateFormat = [NSDate defaultFormatter];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}

+ (NSDateComponents *)currentComponents {
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    return [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
}

@end
