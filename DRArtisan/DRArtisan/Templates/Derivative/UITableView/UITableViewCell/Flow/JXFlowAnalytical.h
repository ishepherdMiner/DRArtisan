//
//  NetTool.h
//  流量监测
//
//  Created by 刘瑞龙 on 15/12/4.
//  Copyright © 2015年 刘瑞龙. All rights reserved.
//


@class JXMealPersistent;

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
@interface JXFlowAnalytical : NSObject

/**
 *  更新流量使用情况
 */
+ (void)execUpdateFlow;


/**
 *  保存/更新 流量配置
 *
 *  @param v_persistent 流量模型对象
 */
+ (void)saveOrUpdateConfig:(JXMealPersistent *)pst_param;

/**
 *  重置流量配置
 */
+ (void)resetAll;

/**
 *  下次更新日期 && 距今多少天
 */
+ (NSArray <NSString *>*)execUpdateDay:(NSUInteger)updateDay;





@end
