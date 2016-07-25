//
//  NetTool.h
//  流量监测
//
//  Created by 刘瑞龙 on 15/12/4.
//  Copyright © 2015年 刘瑞龙. All rights reserved.
//

#define ThisUseFlow     @"thisUseFlow"         // 本月使用的流量
#define AllUseFlow      @"allUseFlow"          // 总共使用的流量
#define kMonthChangeUse  @"monthChangeUseFlow" // 暂时还不理解
#define AllFlow         @"allFlow"             // 套餐总流量
#define Month           @"month"               // 记录更新月份
#define kUsedFlowUnit   @"usedFlowUnit"        // 已经使用的流量单位(M/G)
#define kFlowUnit       @"flowUnit"            // 套餐总流量的单位(M/月 | G/月)

#import <Foundation/Foundation.h>

/**
 *  虽然写得不错,但是不太存粹,需要修改
 *  本质上可以看成对流量的增删改查
 */
@interface JasFlowAnalytical : NSObject

/**
*  设置已使用的流量
*
*  @param useFlow 已使用的流量
*/
+ (void)setHasUsedFlow:(double)useFlow;

/**
 * @b 获取已经用的流量
 */
+ (double)hasUsedFlow;

/**
 *  设置流量套餐
 *
 *  @param allFlow 套餐中包含的总流量
 */
+ (void)setAllFlow:(double)allFlow;

/**
 * @b 获取流量套餐
 */
+ (double)allFlow;

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
