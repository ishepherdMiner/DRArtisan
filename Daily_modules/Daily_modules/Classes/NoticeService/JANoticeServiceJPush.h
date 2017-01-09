//
//  JANoticeServiceJPush.h
//  Daily_modules
//
//  Created by Jason on 02/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JANoticeService.h"

UIKIT_EXTERN NSString *const kJANetworkIsConnectingNotification;       // 正在连接中
UIKIT_EXTERN NSString *const kJANetworkDidSetupNotification;           // 建立连接
UIKIT_EXTERN NSString *const kJANetworkDidCloseNotification;           // 关闭连接
UIKIT_EXTERN NSString *const kJANetworkDidRegisterNotification;        // 注册成功
UIKIT_EXTERN NSString *const kJANetworkFailedRegisterNotification;     // 注册失败
UIKIT_EXTERN NSString *const kJANetworkDidLoginNotification;           // 登陆成功
UIKIT_EXTERN NSString *const kJANetworkDidReceiveMessageNotification;  // 收到消息(非APNS)
UIKIT_EXTERN NSString *const kJAServiceErrorNotification;              // 错误提示

@interface JANoticeServiceJPush : NSObject <JANoticeServcieDelegate>

/*!
 * @abstract 启动SDK
 *
 * @param launchingOption 启动参数.
 * @param appKey 一个JPush 应用必须的,唯一的标识. 请参考 JPush 相关说明文档来获取这个标识.
 * @param channel 发布渠道. 可选.
 * @param isProduction 是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
 *
 * @discussion 提供SDK启动必须的参数, 来启动 SDK.
 * 此接口必须在 App 启动时调用, 否则 JPush SDK 将无法正常工作.
 */
+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction;

/*!
 * @abstract 启动SDK
 *
 * @param launchingOption 启动参数.
 * @param appKey 一个JPush 应用必须的,唯一的标识. 请参考 JPush 相关说明文档来获取这个标识.
 * @param channel 发布渠道. 可选.
 * @param isProduction 是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
 * @param advertisingId 广告标识符（IDFA） 如果不需要使用IDFA，传nil.
 *
 * @discussion 提供SDK启动必须的参数, 来启动 SDK.
 * 此接口必须在 App 启动时调用, 否则 JPush SDK 将无法正常工作.
 */
+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction
  advertisingIdentifier:(NSString *)advertisingId;


/**
 注册极光通知的事件

 @param notificationEvent 极光通知的事件
 @param execBlock 事件对应的回调block
 */
- (void)regJPushNotication:(NSString *)notificationEvent
                 execBlock:(void (^)(NSNotification *notification))execBlock;

@end
