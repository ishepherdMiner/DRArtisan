//
//  JXMealPersistent.h
//  Flow
//
//  Created by Jason on 8/20/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "JXBaseObject.h"

/**
 *  持久化
 */
@interface JXMealPersistent : JXBaseObject <NSCoding,JXCodingDelegate>

/// 套餐周期
@property (nonatomic,copy) NSString *meal_cycle;

/// 结算日期
@property (nonatomic,copy) NSString *settle_date;

/// 套餐流量
@property (nonatomic,copy) NSString *total_flow;

/// 已使用流量
@property (nonatomic,copy) NSString *used_flow;

/// 剩余流量
//@property (nonatomic,copy) NSString *left_flow;

/// 是否是老用户
@property (nonatomic,assign,getter=isOlder) BOOL older;

/**
 *  完成配置时写入的时间戳 - 用于计算设备的开机时间
 */
@property (nonatomic,assign) NSTimeInterval reg_timestamp;

/**
 *  完成配置时写入的运行时间 - 取当时的NSProgressInfo systemUpTime的值
 *  1.该值 小于 以后由NSProgressInfo获取的值时 证明重启过
 *  2.该值 大于 以后由NSProgressInfo获取的值时 running_time + 当前时间戳 - reg_timestamp 应该约等于运行时间 精读要求10分钟吧
 *  3.至于中间的重复关机的过程 没办法检测了
 */
@property (nonatomic,assign) NSTimeInterval running_time;

/// 当前月份
@property (nonatomic,assign) NSUInteger current_month;

/// 用于描述持久化的数据是否有被修改 - 设置界面使用
@property (nonatomic,copy) NSString *change_status;

/// 维护一张剩余流量表,用于计算流量结余
@property (nonatomic,strong) NSDictionary *flow_table;

// - 以下属性参与计算剩余流量

/// 本次开机消耗的流量 - 计算型
@property (nonatomic,assign) CGFloat cal_boot_flow;
/// 已使用流量 - 计算型
@property (nonatomic,assign) CGFloat cal_used_flow;
/// 流量结余 - 计算型
@property (nonatomic,assign) CGFloat cal_left_flow;

@end

UIKIT_EXTERN NSString *kMealCycle;
UIKIT_EXTERN NSString *kSettleDate;
UIKIT_EXTERN NSString *kTotalFlow;
UIKIT_EXTERN NSString *kUsedFlow;
UIKIT_EXTERN NSString *kLeftFlow;
UIKIT_EXTERN NSString *kCurrentMonth;


