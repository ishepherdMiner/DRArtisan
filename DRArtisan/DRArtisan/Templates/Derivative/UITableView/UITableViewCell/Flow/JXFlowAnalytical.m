//
//  NetTool.m
//  流量监测
//
//  Created by 刘瑞龙 on 15/12/4.
//  Copyright © 2015年 刘瑞龙. All rights reserved.
//

#import "JXFlowAnalytical.h"

#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#include <arpa/inet.h>

#import "JXMealPersistent.h"
#import "JXSetMealTableView.h"

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
@implementation JXFlowAnalytical

+ (void)saveOrUpdateConfig:(JXMealPersistent *)pst_param{
    JXMealPersistent *pst = [JXMealPersistent accessModel];
    
    // 当pst为nil代表是首次 => 存储操作 否则为更新操作
    if (pst == nil) {
        pst = [[JXMealPersistent alloc] init];
    }
    
    if (pst_param.cal_total_flow) {
        if (pst.cal_total_flow != pst_param.cal_total_flow) {
            pst.cal_total_flow = pst_param.cal_total_flow;
        }else {
            pst.cal_total_flow = 0;
        }
    }
    
    if (pst_param.cal_total_flow_unit) {
        if (![pst.cal_total_flow_unit isEqualToString:pst_param.cal_total_flow_unit]) {
            pst.cal_total_flow_unit = pst_param.cal_total_flow_unit;
        }else {
            pst.cal_total_flow_unit = @"MB";
        }
    }

    if (pst_param.cal_used_flow) {
        if (pst.cal_used_flow != pst_param.cal_used_flow) {
            pst.cal_used_flow = [[NSNumber notRounding:pst_param.cal_used_flow afterPoint:1] doubleValue];
        }else {
            pst.cal_used_flow = 0;
        }
    }
    
    if (pst_param.cal_used_flow_unit) {
        if (![pst.cal_used_flow_unit isEqualToString:pst_param.cal_used_flow_unit]) {
            pst.cal_used_flow_unit = pst_param.cal_used_flow_unit;
        }else {
            pst.cal_used_flow_unit = @"MB";
        }
    }
    
    if (pst.cal_left_flow != pst_param.cal_left_flow) {
        if (pst_param.cal_left_flow) {
            pst.cal_left_flow = [[NSNumber notRounding:pst_param.cal_left_flow afterPoint:1] doubleValue];
        }else {
            pst.cal_left_flow = 0;
        }
    }
    
    if (pst_param.cal_left_flow_unit) {
        if (![pst.cal_left_flow_unit isEqualToString:pst_param.cal_left_flow_unit]) {
            pst.cal_left_flow_unit = pst_param.cal_left_flow_unit;
        }else {
            pst.cal_left_flow_unit = @"MB";
        }
    }
    
    if (pst_param.cal_settle_date) {
        if (pst.cal_settle_date != pst_param.cal_settle_date) {
            pst.cal_settle_date = pst_param.cal_settle_date;
        }else {
            pst.cal_settle_date = 0;
        }
    }
    
    // 首次安装的若干操作
    if (pst.reg_timestamp == 0) {
        pst.older = true;
        pst.reg_timestamp = [JXUtils timestamp];
        pst.init_running_time = [[[NSProcessInfo alloc] init] systemUptime];
        pst.min_running_time = pst.init_running_time;
        // 检测用户配置中的当前月份是否为空,为空的话,写入一次
        if (pst.current_month == kZero) {
            NSDateComponents *comps = [NSDate currentComponents];
            pst.current_month = comps.month;
        }
        
        // 将剩余流量默认为是上一个月留下来的
        if (pst.left_flow_month_dic == nil) {
            NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
            [dicM setObject:![pst_param.left_flow isEqualToString:@""]?pst_param.left_flow : @"0.0" forKey:@((pst.current_month - 1)%12)];
            pst.left_flow_month_dic = [dicM copy];
        }
        
        
    }
    if (pst.cal_not_clear_flow != pst_param.cal_not_clear_flow) {
        // 如果没有设置,则默认为2
        if (pst.cal_not_clear_flow == 0) {
            pst.cal_not_clear_flow = 2;
        }else {
            pst.cal_not_clear_flow = pst_param.cal_not_clear_flow;
        }
    }
    // 写入文件
    [JXMealPersistent storeModel:pst];
}

/**
 *  更新流量统计
 */
+ (void)execUpdateFlow{
    JXMealPersistent *pst = [JXMealPersistent accessModel];
    
//    if (pst.source == JXRefreshSourceWidght) {
//        pst.source = JXRefreshSourceApp;
//        [JXMealPersistent storeModel:pst];
//        return;
//    }
    
    // 当月份变化时,已使用流量要根据条件确定是否要转化为剩余流量
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    // 因为不想比较年份 所以采用月份不相等就认为升级 - 年份暂时不去考虑
    if (comps.month != pst.current_month) {
        pst.cal_left_flow = 0;
        NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:pst.left_flow_month_dic];
        // 现在月份以前的流量舍弃
        for (NSNumber *month in pst.left_flow_month_dic.allKeys) {
            if ([month integerValue] < comps.month - pst.cal_not_clear_flow) {
                [dicM setObject:@"0.0" forKey:month];
            }else {
                pst.cal_left_flow += [[dicM objectForKey:month] doubleValue];
            }
        }
        // 重新设置当前月份
        pst.current_month = comps.month;
        
        // 本月剩余流量
        CGFloat add_left_flow = 0.0;
        if ([pst.cal_total_flow_unit isEqualToString:@"GB"] && [pst.cal_used_flow_unit isEqualToString:@"GB"]) {
            add_left_flow = (pst.cal_total_flow - pst.cal_used_flow) * kMoreMagnitude;
        }
        
        if ([pst.cal_total_flow_unit isEqualToString:@"MB"] && [pst.cal_used_flow_unit isEqualToString:@"MB"]) {
            add_left_flow = (pst.cal_total_flow - pst.cal_used_flow);
        }
        
        if ([pst.cal_total_flow_unit isEqualToString:@"GB"] && [pst.cal_used_flow_unit isEqualToString:@"MB"]) {
            add_left_flow = pst.cal_total_flow * kMoreMagnitude - pst.cal_used_flow;
        }
        
        pst.cal_left_flow += add_left_flow;
        [dicM setObject:@(pst.cal_total_flow - pst.cal_used_flow) forKey:@(pst.current_month)];
        
        // 本月已使用流量清空
        pst.cal_used_flow = 0.0;
        
        pst.left_flow_month_dic = [dicM copy];
    }
    
    // 获取本次开机使用的流量
    // - 精度问题 - 搞了半天NSNumber转成doubleValue后有些数就是无法表示了
    CGFloat thisUse =  [[JXUtils flowUsage:FlowUsageTypeWwan direction:FlowDirectionOptionUp | FlowDirectionOptionDown] doubleValue];
    
    // 重启过-情形1:没有关机过,写入的running_time应该要小于后面的值,该情况比较明显
    NSTimeInterval api_running_time = [[[NSProcessInfo alloc] init] systemUptime];
    
    // 避免2~N次重启后重复进入判断 这样判断条件会越来越苛刻的 有漏洞
    if (pst.min_running_time > api_running_time) {
        // 尝试从Extension的公共文件中读取运行时间 如果有
        
        // 至少要求两次重启并打开应用的时间不超过1小时
        pst.min_running_time = api_running_time > 3600 ? api_running_time : 3600;
        if (pst.init_running_time > api_running_time) {
            // 这次得到的流量,需要全部减去
            if (pst.cal_left_flow > kZero) {
                if (pst.cal_left_flow > thisUse) {
                    pst.cal_left_flow -= thisUse;
                    
                    [self updateLeftFlow:thisUse type:0];
                    
                }else {
                    pst.cal_left_flow = 0;
                    
                    [self updateLeftFlow:thisUse type:1];
                    
                    pst.cal_used_flow += (thisUse - pst.cal_left_flow);
                }
            }else {
                pst.cal_used_flow += thisUse;
            }
            
            // 记录本次开机消耗的流量
            pst.cal_boot_flow = thisUse;
            
        }else{
            
            // 当2~N次重启后当 本次开机时间 > 运行时间 也可能是重启过的
            // 重启过-情形2:初始运行时间 + 当前时间戳 - 注册时间戳  > 运行时间 + 600 600代表可以接受10分钟的误差
            // 当前时间戳 - 注册时间戳 => 理论上增加的运行时间
            if(pst.init_running_time + ([JXUtils timestamp] - pst.reg_timestamp) > api_running_time + 60){
                
                // 这次得到的流量,需要全部减去
                if (pst.cal_left_flow > kZero) {
                    if (pst.cal_left_flow > thisUse) {
                        pst.cal_left_flow -= thisUse;
                        [self updateLeftFlow:thisUse type:0];
                    }else {
                        pst.cal_left_flow = 0;
                        [self updateLeftFlow:thisUse type:1];
                        pst.cal_used_flow -= (thisUse - pst.cal_left_flow);
                    }
                }else {
                    pst.cal_used_flow += thisUse;
                }
                
                // 记录本次开机消耗的流量
                pst.cal_boot_flow = thisUse;
            }
        }
    }else {
        
        // 假定为0时,是首次
        if (pst.cal_boot_flow == kZero) {
            pst.cal_boot_flow = thisUse;
        }
        
        // 默认为没有进行重启设备的操作
        // 有剩余流量
        if (pst.cal_left_flow > kZero) {
            // 剩余流量 > 本次使用的流量
            if (pst.cal_left_flow > thisUse) {
                pst.cal_left_flow -= (thisUse - pst.cal_boot_flow);
                [self updateLeftFlow:thisUse type:0];
            }else {
                pst.cal_left_flow = kZero;
                [self updateLeftFlow:thisUse type:1];
                pst.cal_used_flow += (thisUse - pst.cal_boot_flow - pst.cal_left_flow);
            }
        }else {
            if (thisUse > pst.cal_boot_flow) {
                pst.cal_used_flow += (thisUse - pst.cal_boot_flow);
            }
        }
        if (thisUse > pst.cal_boot_flow) {            
            // 记录本次开机消耗的流量
            pst.cal_boot_flow += (thisUse - pst.cal_boot_flow);
        }
    }
    
    // pst.source = JXRefreshSourceApp;
    
    [JXMealPersistent storeModel:pst];
}

+ (NSArray <NSString *>*)execUpdateDay:(NSUInteger)updateDay{
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    if (updateDay == kZero) {
        comps.day = kOne;
    }
    comps.day = updateDay;
    if (comps.month + kOne > 12) {
        comps.year += 1;
    }
    comps.month = comps.month + kOne > 12 ? (comps.month + kOne) % 12 : (comps.month + kOne);
    NSDate *firstDay = [cal dateFromComponents:comps];
    
    NSTimeInterval time = [firstDay timeIntervalSinceDate:now];
    return @[[NSString stringWithFormat:@"%zd 月 %zd 日",comps.month,comps.day],[NSString stringWithFormat:@"%d 天", (int)ceilf(time/60/60/24)]];
}

+ (void)resetAll:(void(^)())clearCallback {
    JXMealPersistent *pst = [[JXMealPersistent alloc] init];
    pst.cal_meal_cycle = 0;
    pst.cal_settle_date = 0;
    pst.cal_not_clear_flow = 0;
    pst.cal_used_flow = 0.0;
    pst.cal_total_flow = 0.0;
    pst.cal_boot_flow = 0.0;
    pst.cal_total_flow_unit = @"";
    pst.cal_used_flow_unit = @"";
    pst.cal_left_flow_unit = @"";
    pst.cal_left_flow = 0.0;
    [JXMealPersistent storeModel:pst];
    clearCallback();
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMealFlowNotification" object:nil];
}

+ (void)updateLeftFlow:(CGFloat)thisUse type:(CGFloat)type{
    
    JXMealPersistent *pst = [JXMealPersistent accessModel];
    NSMutableDictionary *dicM = [NSMutableDictionary dictionaryWithDictionary:pst.left_flow_month_dic];
    
    // mark - 找到"最小"的月份 如果剩余流量不是0.0,先用那个以此类推
    
    // 剩余流量足够用于本次更新
    if (type == 0) {
        NSUInteger cur_month = pst.current_month > pst.cal_not_clear_flow ? pst.current_month :  12 + pst.current_month;
        for (int i = (cur_month - pst.cal_not_clear_flow) % 12; i < cur_month; ++i) {
            if([[dicM objectForKey:@(i%12)] isEqualToString:@"0.0"]){
                continue;
            }else {
                if([[dicM objectForKey:@(i%12)] doubleValue] - thisUse > 0){
                    // 保存剩余流量
                    [dicM setObject:@([[dicM objectForKey:@(i%12)] doubleValue] - thisUse).stringValue forKey:@(i%12)];
                    break;
                }else {
                    [dicM setObject:@"0.0" forKey:@(i%12)];
                }
            }
        }
    }else {
        for (NSNumber *month in dicM.allKeys) {
            [dicM setObject:@"0.0" forKey:month];
        }
    }
    
    pst.left_flow_month_dic = [dicM copy];
    
    [JXMealPersistent storeModel:pst];
}

@end
