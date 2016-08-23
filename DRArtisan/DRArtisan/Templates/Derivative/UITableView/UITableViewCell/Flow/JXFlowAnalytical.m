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
    
    if (pst_param.cal_left_flow) {
        if (pst.cal_left_flow != pst_param.cal_left_flow) {
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
        pst.running_time = [[[NSProcessInfo alloc] init] systemUptime];
        // 检测用户配置中的当前月份是否为空,为空的话,写入一次
        if (pst.current_month == kZero) {
            NSDateComponents *comps = [NSDate currentComponents];
            pst.current_month = comps.month;
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
    
    // 当月份变化时,已使用流量要根据条件确定是否要转化为剩余流量
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    if (comps.month > pst.current_month) {
        
    }
    
    // 获取本次开机使用的流量
    // - 精度问题 - 搞了半天NSNumber转成doubleValue后有些数就是无法表示了
    CGFloat thisUse =  [[JXUtils flowUsage:FlowUsageTypeWwan direction:FlowDirectionOptionUp | FlowDirectionOptionDown] doubleValue];
    
    // 重启过-情形1:没有关机过,写入的running_time应该要小于后面的值,该情况比较明显
    if (pst.running_time > [[[NSProcessInfo alloc] init] systemUptime]) {
        
        // 这次得到的流量,需要全部减去
        if (pst.cal_left_flow > kZero) {
            if (pst.cal_left_flow > thisUse) {
                pst.cal_left_flow -= thisUse;
            }else {
                pst.cal_left_flow = 0;
                pst.cal_used_flow -= (thisUse - pst.cal_left_flow);
            }
        }else {
           pst.cal_used_flow -= thisUse;
        }
        
    }else{
        
        // 重启过-情形2:初始运行时间 + 当前时间戳 - 注册时间戳 - 600 <= 运行时间 600代表可以接受10分钟的误差
        // 当前时间戳 - 注册时间戳 => 理论上增加的运行时间
        if(pst.running_time + [JXUtils timestamp] - pst.reg_timestamp - 600 <= [[[NSProcessInfo alloc] init] systemUptime]){
            
            // 这次得到的流量,需要全部减去
            if (pst.cal_left_flow > kZero) {
                if (pst.cal_left_flow > thisUse) {
                    pst.cal_left_flow -= thisUse;
                }else {
                    pst.cal_left_flow = 0;
                    pst.cal_used_flow -= (thisUse - pst.cal_left_flow);
                }
            }else {
                pst.cal_used_flow -= thisUse;
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
                }else {
                    pst.cal_left_flow = kZero;
                    pst.cal_used_flow -= (thisUse - pst.cal_boot_flow - pst.cal_left_flow);
                }
            }else {
                pst.cal_used_flow -= (thisUse - pst.cal_boot_flow);
            }
            
            // 记录本次开机消耗的流量
            pst.cal_boot_flow += thisUse;
        }
    }
    
    [JXMealPersistent storeModel:pst];
}

+ (NSString *)execUpdateDay:(NSUInteger)updateDay{
    NSDate *now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    if (updateDay == kZero) {
        comps.day = kOne;
    }
    comps.day = updateDay;
    
    comps.month = comps.month + kOne;
    NSDate *firstDay = [cal dateFromComponents:comps];
    
    NSTimeInterval time = [firstDay timeIntervalSinceDate:now];
    return [NSString stringWithFormat:@"%d 天", (int)ceilf(time/60/60/24)];
}

@end
