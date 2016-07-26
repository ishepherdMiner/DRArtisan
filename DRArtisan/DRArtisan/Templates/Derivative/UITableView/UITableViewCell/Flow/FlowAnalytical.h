//
//  NetTool.h
//  流量监测
//
//  Created by 刘瑞龙 on 15/12/4.
//  Copyright © 2015年 刘瑞龙. All rights reserved.
//
#define kFirstSetting    @"firstSetting"        // 是否是首次
#define kThisUseFlow     @"thisUseFlow"         // 本月使用的流量
#define kAllUseFlow      @"allUseFlow"          // 本月总共使用的流量
#define kMonthChangeUse  @"monthChangeUseFlow"  // 当月份改变时,记录下本月使用的流量
#define kAllFlow         @"allFlow"             // 套餐总流量
#define kMonth           @"month"               // 记录更新月份
#define kUsedFlowUnit    @"usedFlowUnit"        // 已经使用的流量单位(M/G)
#define kFlowUnit        @"flowUnit"            // 套餐总流量的单位(M/月 | G/月)

#import <Foundation/Foundation.h>

/**
 *  App界面:
 *      首次:
 *          输入套餐总流量与已使用的流量
 *
 *      N+1次:
 *          退下界面: 显示已消耗的流量占比的视图
 *          修改流量套餐与已使用的流量能正常显示
 *      
 *      月份切换时:能正常显示
 *
 *  Ext界面:
 *
 */
@interface FlowAnalytical : NSObject

/**
*  设置已使用的流量
*
*  @param useFlow 已使用的流量
*/
+ (void)setHasUsedFlow:(double)useFlow;

/**
 * @b 获取已经用的流量
 */
+ (NSString *)hasUsedFlow;

/**
 *  设置流量套餐
 *
 *  @param allFlow 套餐中包含的总流量
 */
+ (void)setAllFlow:(double)allFlow;

/**
 * @b 获取流量套餐
 */
+ (NSString *)allFlow;

/**
 *  设置流量套餐更新周期
 *
 *  @param cycleMonths 几个月
 */
+ (void)setMealCycle:(NSUInteger)cycleMonths;


+ (void)setCurMonth:(NSInteger)month;

/**
 *  更新流量使用情况
 */
+ (void)updateUseFlow;


/**
 *  获取流量更新月份
 *
 *  @return 1~12
 */
+ (NSInteger)curMonth;


/**
 * @b 获取到下个月1号的天数
 */
+ (NSString *)remainDays;

/**
 * @b 获取到下个月1号剩余流量的提示语;
 */
// + (NSString *)getLeftFlowStr;


//+(NSString *)getDataStringWithB:(long long)dataCount;
//
//+(double)getDataWithB:(long long)data;

@end
