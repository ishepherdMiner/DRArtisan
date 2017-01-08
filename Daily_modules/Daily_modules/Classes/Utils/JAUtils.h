//
//  JAUtils.h
//  Daily_modules
//
//  Created by Jason on 09/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,FlowUsageType){
    FlowUsageTypeWifi,
    FlowUsageTypeWwan
};

typedef NS_ENUM(NSUInteger,FlowDirectionOption){
    FlowDirectionOptionUp = 1 << 0,
    FlowDirectionOptionDown = 1 << 1
};

@interface JAUtils : NSObject
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
 *  @param directionOption up/down(上行/下行)
 *
 *  @return 指定方式的流量使用情况
 */
+ (NSString *)flowUsage:(FlowUsageType)usageType direction:(FlowDirectionOption)directionOption;
@end
