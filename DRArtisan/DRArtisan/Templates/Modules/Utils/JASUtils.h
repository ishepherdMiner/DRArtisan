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

/// 远程通知工具方法
@interface JASUtils (RemotePush)

/// 向苹果服务器申请远程通知的服务
+ (void)registerPushService;

/// 将得到的deviceToken进行处理并发送相应的通知 1 => 将返回值保存起来 2.通过通知得到
+ (NSString *)postDeviceToken:(NSData *)deviceToken;

/// 发送处理后的deviceToken的通知
UIKIT_EXTERN const NSString *RegisterDeviceToken;

@end

#pragma mark - Waiting
typedef NS_ENUM(NSUInteger,ObservedOptions){
    ObservedOptionsBrightness = 1 << 0,  // 设备的屏幕亮度
    ObservedOptionsVolumn = 1 << 1,      //
};
/// 设备相关的工具方法
@interface JASUtils (Device)

// + (void)monitorWithObserver:(id)observer selector:(SEL)sel option:(ObservedOptions)options;

@end

