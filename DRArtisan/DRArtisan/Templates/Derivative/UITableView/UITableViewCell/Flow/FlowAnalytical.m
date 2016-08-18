//
//  NetTool.m
//  流量监测
//
//  Created by 刘瑞龙 on 15/12/4.
//  Copyright © 2015年 刘瑞龙. All rights reserved.
//

#import "FlowAnalytical.h"

#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#include <arpa/inet.h>
/**
 *  原来的逻辑有些地方我不太明白,我整理下我现在的业务逻辑,然后着手修改
 *  每次进入页面的时候:
 *      1.获取信息
 *          1.1.从文件中读取,本次开机的使用流量
 *          1.2.从文件中读取,累计使用的流量(因为有开关机的影响)
 *          1.3.通过系统方法得到本次开机使用的流量
 *          1.4.从文件中读取获取指定月份剩余流量的,比如选择了3个月周期的,那就读取前2个月的剩余流量
 *      2.判断
 *          2.1.有剩余流量时
 *              2.1.1.当文件中的本地流量 > 系统方法读取的本地流量 => 重启过
 *              2.1.2.当文件中的本地流量 < 系统方法读取的本地流量 => 1.正常累加,修改本地文件的记录 2.重启过,而且还满足2.1.1(通过扩展的能力应该能解决)
 2.1.3.该写文件的写文件 => 以前的剩余流量,本次开机流量 => 流量使用占比:(剩余流量 + 本次开机流量) / 月份改变时的流量(包括套餐流量 + 本次剩余的流量)
 *          2.2 没有剩余流量
 *               2.2.1. 同2.1.1
 *               2.2.2. 同2.1.2
 *               2.2.3. 流量使用占比 => 本次开机流量 / 套餐流量
 *
 */
@implementation FlowAnalytical

/**
 *  更新流量统计
 */
+ (void)updateUseFlow{
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    
    // 获取本次开机使用流量的本地记录
    double theUse = [userDefaults doubleForKey:kThisUseFlow];
    
    // 获取本次开机使用的流量
    double thisUse = [[JXUtils flowUsage:FlowUsageTypeWwan direction:FlowDirectionOptionUp | FlowDirectionOptionDown] doubleValue];
    
    // 获取所有使用量
    double allUse = [[userDefaults objectForKey:kAllUseFlow] doubleValue];
    
    // 上次月份改变时,剩余流量
    double monthChangeUse = [userDefaults doubleForKey:kMonthChangeUse];
    
    if (monthChangeUse > 0) {
        if (thisUse > monthChangeUse) {
            // 更新全部使用流量
            double nowAllUse = allUse + thisUse - monthChangeUse;
            [userDefaults setObject:[NSString stringWithFormat:@"%.2f",nowAllUse] forKey:kAllUseFlow];
        }else if(thisUse < monthChangeUse){
            //
            [userDefaults setDouble:0.0 forKey:kMonthChangeUse];
            [userDefaults setObject:[NSString stringWithFormat:@"%.2f",thisUse] forKey:kThisUseFlow];
            
            // 更新全部使用的流量
            double nowAllUse = allUse + thisUse;
            nowAllUse = [[NSString stringWithFormat:@"%.2f",nowAllUse] doubleValue];
            [userDefaults setDouble:nowAllUse forKey:kAllUseFlow];
        }
    }else{
        // 本次开机使用流量大于本地记录的流量
        if (thisUse > theUse) {
            double nowAllUse = 0.0;
            if ([userDefaults objectForKey:kFirstSetting]) {
                // 更新本地存储的本次开机流量
                [userDefaults setObject:[NSString stringWithFormat:@"%.2f",thisUse] forKey:kThisUseFlow];
                // 更新全部使用流量
                nowAllUse = allUse + thisUse - theUse;
            }else {
                nowAllUse = allUse;
                [userDefaults setObject:@"true" forKey:kFirstSetting];
                [userDefaults setObject:@(thisUse).stringValue forKey:kThisUseFlow];
            }
            [userDefaults setObject:[NSString stringWithFormat:@"%.2f",nowAllUse] forKey:kAllUseFlow];
        }else if (thisUse < theUse){
            // 当统计出本次开机使用的流量小于本地本次流量时, 说明开机重新启动
            // 将本次开机流量同步到本地
            [userDefaults setObject:[NSString stringWithFormat:@"%.2f",thisUse] forKey:kThisUseFlow];
            // 更新全部使用的流量
            double nowAllUse = allUse + thisUse;
            [userDefaults setObject:[NSString stringWithFormat:@"%.2f",nowAllUse] forKey:kAllUseFlow];
        }
    }
}

/**
 *  设置用户已经使用的流量
 *
 *  @param useFlow 已经使用的流量数据
 */
+ (void)setHasUsedFlow:(double)useFlow{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    useFlow -= [[userDefaults objectForKey:kThisUseFlow] doubleValue];
    [userDefaults setObject:[NSString stringWithFormat:@"%.2f",useFlow] forKey:kAllUseFlow];
}


/**
 *  获得用户已经使用的流量
 *
 *  @return 已经使用的流量
 */
+ (NSString *)hasUsedFlow{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    return [userDefaults objectForKey:kAllUseFlow];
}

/**
 *  获得总的套餐数据
 *
 *  @return 总的套餐数据
 */
+ (NSString *)allFlow{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    return [userDefaults objectForKey:kAllFlow];
}

/**
 *  设置总的套餐流量
 *
 *  @param allFlow 总的套餐流量数据
 */
+ (void)setAllFlow:(double)allFlow{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    return [userDefaults setObject:[NSString stringWithFormat:@"%.2f",allFlow] forKey:kAllFlow];
}

+ (void)setCurMonth:(NSInteger)month {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    [userDefaults setObject:@(month).stringValue forKey:kMonth];
}
+ (NSInteger)curMonth{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    return [[userDefaults objectForKey:kMonth] integerValue];
}

+ (void)setMealCycle:(NSUInteger)cycleMonths {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    [userDefaults setObject:@(cycleMonths) forKey:@"cycleMonths"];
}

+ (NSUInteger)mealCycle{
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    return [[userDefault objectForKey:@"cycleMonths"] integerValue];
}

#pragma mark - 获得到下个月1号的天数
+ (NSString *)remainDays{
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    comps.day = 1;
    
    // 当发现月份变化数量大于套餐的更新月份时, 所有已用数据清空
    if (comps.month > [FlowAnalytical curMonth] + [FlowAnalytical mealCycle]) {
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
        [userDefaults setInteger:comps.month forKey:kMonth];
        [userDefaults setObject:@"0.0" forKey:kAllUseFlow];
        [userDefaults setObject:@"0.0" forKey:kThisUseFlow];
        
        // 获取本次开机使用的流量
        double thisUse = [[JXUtils flowUsage:FlowUsageTypeWwan direction:FlowDirectionOptionUp | FlowDirectionOptionDown] doubleValue];
        
        // [FlowAnalytical getDataWithB:[arr[2] longLongValue] + [arr[3] longLongValue]];
        // 本次开机使用流量
        [userDefaults setObject:[NSString stringWithFormat:@"%.2f",thisUse] forKey:kMonthChangeUse];
    }
    
    comps.month = comps.month + 1;
    // NSLog(@"%ld -- %ld",comps.month, [self.class curMonth]);
    NSDate *firstDay = [cal dateFromComponents:comps];
    
    NSTimeInterval time = [firstDay timeIntervalSinceDate:now];
    return [NSString stringWithFormat:@"%d天", (int)ceilf(time/60/60/24)];
}

/// 刷新流量的日期
//+ (NSString *)refreshFlowDay {
//    return nil;
//}

//- (NSUserDefaults *)userDefaults {
//    if (!_userDefaults) {
//        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
//    }
//    return _userDefaults;
//}

//+ (NSString *)getLeftFlowStr{
//    double leftTime = [self getLeftTime];
//    int leftDay = leftTime;
//    double hour = [[NSString stringWithFormat:@"%.1f", (leftTime - leftDay) * 24] doubleValue];
//    NSString *str = [NSString stringWithFormat:@"到下月1号还有:   %d天%.1f小时\n剩   余   流   量:   %.2fM", leftDay, hour, [self allFlow] - [self hasUsedFlow]];
//    return str;
//}

//+ (NSString *)getDataStringWithB:(long long)dataCount{
//    double mData = datgetLeftFlowStraCount/1024.0/1024.0;
//    if (mData > 0) {
//        return [NSString stringWithFormat:@"%.2lfM", mData];
//    }else{
//        return @"0M";
//    }
//
//}
//
//+ (double)getDataWithB:(long long)data{
//    double mData = data/1024.0/1024.0;
//    if (mData > 0) {
//        return [[NSString stringWithFormat:@"%.2lfM", mData] doubleValue];
//    }else{
//        return 0.0;
//    }
//}

@end
