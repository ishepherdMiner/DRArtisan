//
//  JASUtils.h
//  DRArtisan
//
//  Created by Jason on 7/17/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseObject.h"

typedef NS_ENUM(NSUInteger,FlowUsageType){
    FlowUsageTypeWifi,
    FlowUsageTypeWwan
};

typedef NS_ENUM(NSUInteger,FlowDirectionOption){
    FlowDirectionOptionUp = 1 << 0,
    FlowDirectionOptionDown = 1 << 1
};

@interface JASUtils : BaseObject

#if DEBUG

/**
 *  输出指定view的层级结构
 *
 *  @param view 被指定的view对象
 */
+ (void)logViewRecursive:(UIView *)view;

/**
 *  输出指定vc的层级结构
 *
 *  @param vc 被指定的vc对象
 */
+ (void)logViewCtrlRecursive:(UIViewController *)vc;

#endif

@end

/**
 *  网络相关的类方法
 */
@interface JASUtils (Network)

/**
 *  获取Wifi && WWAN的使用量(仅包含本次开机的)
 *
 *  @return 网络流量的数组
 */
+ (NSArray *)flowCounters;

/**
 *  流量的使用情况(仅能计算本次开机的情况)
 *
 *  @param usageType  wifi/wwan
 *  @param direction up/down(上行/下行)
 *
 *  @return 指定方式的流量使用情况
 */
+ (NSString *)flowUsage:(FlowUsageType)usageType direction:(FlowDirectionOption)directionOption;

@end

@interface JASUtils (Encrypt)

/**
 *  密码表
 *
 *  @return a string array
 */
+ (NSArray *)encryptTable:(NSUInteger )length;

@end

