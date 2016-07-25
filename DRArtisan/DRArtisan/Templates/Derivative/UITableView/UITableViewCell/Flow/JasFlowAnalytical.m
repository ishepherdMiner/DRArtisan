//
//  NetTool.m
//  流量监测
//
//  Created by 刘瑞龙 on 15/12/4.
//  Copyright © 2015年 刘瑞龙. All rights reserved.
//

#import "JasFlowAnalytical.h"

#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#include <arpa/inet.h>

@interface JasFlowAnalytical ()

// @property (nonatomic,strong) NSUserDefaults *userDefaults;

@end

@implementation JasFlowAnalytical

// SingletonClassMethod(FlowAnalytical)

/**
 *  更新流量统计
 */
+ (void)updateUseFlow{
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    // 获取本次开机使用流量的本地记录
    double theUse = [userDefaults doubleForKey:ThisUseFlow];
    
    // 获取本次开机使用的流量
    double thisUse = [[JASUtils flowUsage:FlowUsageTypeWwan direction:FlowDirectionOptionUp | FlowDirectionOptionDown] doubleValue];
    
    // 获取所有使用量
    double allUse = [userDefaults doubleForKey:AllUseFlow];
    
    double monthChangeUse = [userDefaults doubleForKey:kMonthChangeUse];
    
    if (monthChangeUse > 0) {
        if (thisUse > monthChangeUse) {
            // 更新全部使用流量
            double nowAllUse = allUse + thisUse - monthChangeUse;
            nowAllUse = [[NSString stringWithFormat:@"%.2f",nowAllUse] doubleValue];
            [userDefaults setDouble:nowAllUse forKey:AllUseFlow];
        }else if(thisUse < monthChangeUse){
            //
            [userDefaults setDouble:0.0 forKey:kMonthChangeUse];
            [userDefaults setDouble:thisUse forKey:ThisUseFlow];
            
            // 更新全部使用的流量
            double nowAllUse = allUse + thisUse;
            nowAllUse = [[NSString stringWithFormat:@"%.2f",nowAllUse] doubleValue];
            [userDefaults setDouble:nowAllUse forKey:AllUseFlow];
        }
    }else{
        // 本次开机使用流量大于本地记录的流量
        if (thisUse > theUse) {
            // 更新本地存储的本次开机流量
            [userDefaults setDouble:thisUse forKey:ThisUseFlow];
            
            // 更新全部使用流量
            double nowAllUse = allUse + thisUse - theUse;
            nowAllUse = [[NSString stringWithFormat:@"%.2f",nowAllUse] doubleValue];
            [userDefaults setDouble:nowAllUse forKey:AllUseFlow];
        }else if (thisUse < theUse){
            // 当统计出本次开机使用的流量小于本地本次流量时, 说明开机重新启动
            
            // 将本次开机流量同步到本地
            [userDefaults setDouble:thisUse forKey:ThisUseFlow];
            
            // 更新全部使用的流量
            double nowAllUse = allUse + thisUse;
            nowAllUse = [[NSString stringWithFormat:@"%.2f",nowAllUse] doubleValue];
            [userDefaults setDouble:nowAllUse forKey:AllUseFlow];
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
    double approUseFlow = [[NSString stringWithFormat:@"%.2f",useFlow] doubleValue];
    [userDefaults setDouble:approUseFlow forKey:AllUseFlow];
    [userDefaults setObject:[NSString stringWithFormat:@"%.2f",useFlow] forKey:AllUseFlow];
}

/**
 *  设置总的套餐流量
 *
 *  @param allFlow 总的套餐流量数据
 */
+ (void)setAllFlow:(double)allFlow{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    double approAllFlow = [[NSString stringWithFormat:@"%.2f",allFlow] doubleValue];
    [userDefaults setDouble:approAllFlow forKey:AllFlow];
}

+ (void)setMealCycle:(NSUInteger)cycleMonths {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    [userDefaults setInteger:cycleMonths forKey:@"cycleMonths"];
}

+ (NSUInteger)mealCycle{
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    return [userDefault integerForKey:@"cycleMonths"];
}

/**
 *  获得用户已经使用的流量
 *
 *  @return 已经使用的流量
 */
+ (double)hasUsedFlow{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    // return [userDefaults doubleForKey:AllUseFlow];
    return [[userDefaults objectForKey:AllUseFlow] doubleValue];
}

/**
 *  获得总的套餐数据
 *
 *  @return 总的套餐数据
 */
+ (double)allFlow{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    return [userDefaults doubleForKey:AllFlow];
}

+ (void)setCurMonth:(NSInteger)month {
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    [userDefaults setInteger:month forKey:Month];
}
+ (NSInteger)curMonth{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
    return [userDefaults integerForKey:Month];
}

#pragma mark - 获得到下个月1号的天数
+ (NSString *)remainDays{
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    comps.day = 1;
    
    // 当发现月份变化数量大于套餐的更新月份时, 所有已用数据清空
    if (comps.month > [JasFlowAnalytical curMonth] + [JasFlowAnalytical mealCycle]) {
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.lrl"];
        [userDefaults setInteger:comps.month forKey:Month];
        [userDefaults setDouble:0.0 forKey:AllUseFlow];
        [userDefaults setDouble:0.0 forKey:ThisUseFlow];
        
        // 获取本次开机使用的流量
        double thisUse = [[JASUtils flowUsage:FlowUsageTypeWwan direction:FlowDirectionOptionUp | FlowDirectionOptionDown] doubleValue];
        
        // [JasFlowAnalytical getDataWithB:[arr[2] longLongValue] + [arr[3] longLongValue]];
        // 本次开机使用流量
        [userDefaults setDouble:thisUse forKey:kMonthChangeUse];
    }
    
    comps.month = comps.month + 1;
    // NSLog(@"%ld -- %ld",comps.month, [self.class curMonth]);
    NSDate *firstDay = [cal dateFromComponents:comps];
    
    NSTimeInterval time = [firstDay timeIntervalSinceDate:now];
    return [NSString stringWithFormat:@"%d天", (int)ceilf(time/60/60/24)];
}

/// 刷新流量的日期
+ (NSString *)refreshFlowDay {
    return nil;
}

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
