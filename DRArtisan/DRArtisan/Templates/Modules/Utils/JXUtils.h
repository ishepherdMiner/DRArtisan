//
//  JXUtils.h
//  DRArtisan
//
//  Created by Jason on 7/17/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXBaseObject.h"

typedef NS_ENUM(NSUInteger,FlowUsageType){
    FlowUsageTypeWifi,
    FlowUsageTypeWwan
};

typedef NS_ENUM(NSUInteger,FlowDirectionOption){
    FlowDirectionOptionUp = 1 << 0,
    FlowDirectionOptionDown = 1 << 1
};

@interface JXUtils : JXBaseObject

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

/**
 *  返回当前时间戳
 *
 *  @return 当前时间戳
 */
+ (NSTimeInterval)timestamp;

@end

/**
 *  网络相关的类方法
 */
@interface JXUtils (Network)

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

@interface JXUtils (Encrypt)

/**
 *  密码表
 *
 *  @return a string array
 */
+ (NSArray *)encryptTable:(NSUInteger )length;

@end

/// 推送相关的工具方法
@interface JXUtils (Push)

/// 向苹果服务器申请通知的服务 会弹出申请框要求用户授权
+ (void)registerPushService;

/// 将得到的deviceToken进行处理并发送相应的通知 1 => 将返回值保存起来 2.通过通知得到
+ (NSString *)postDeviceToken:(NSData *)deviceToken;

/**
 *  配置本地通知参数
 *
 *  @param alertBody       通知内容
 *  @param fireDate        执行时间
 *  @param launchImageName 启动图片名称
 *  @param soundName       声音名称
 *  @param extra           额外信息
 *  @param repeat          重复间隔
 */
+ (UILocalNotification *)configureLocalPush:(NSString *)alertBody
                                   fireDate:(NSDate *)fireDate
                            launchImageName:(NSString *)launchImageName
                                  soundName:(NSString *)soundName
                                      extra:(NSDictionary *)extra
                             repeatInterval:(NSCalendarUnit)repeat;

/// 发送处理后的deviceToken的通知
UIKIT_EXTERN const NSString *RegisterDeviceToken;

@end

#pragma mark - Waiting
typedef NS_ENUM(NSUInteger,ObservedOptions){
    ObservedOptionsBrightness = 1 << 0,  // 设备的屏幕亮度
    ObservedOptionsVolumn = 1 << 1,      //
};
/// 设备相关的工具方法
@interface JXUtils (Device)

// + (void)monitorWithObserver:(id)observer selector:(SEL)sel option:(ObservedOptions)options;

@end

