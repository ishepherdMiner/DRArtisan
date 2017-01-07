//
//  JANoticeServiceJPush.m
//  Daily_modules
//
//  Created by Jason on 02/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JANoticeServiceJPush.h"
#import "JPUSHService.h"

NSString *const kJANetworkIsConnectingNotification = @"kJPFNetworkIsConnectingNotification";
NSString *const kJANetworkDidSetupNotification = @"kJPFNetworkDidSetupNotification";
NSString *const kJANetworkDidCloseNotification = @"kJPFNetworkDidCloseNotification";
NSString *const kJANetworkDidRegisterNotification = @"kJPFNetworkDidRegisterNotification";
NSString *const kJANetworkFailedRegisterNotification = @"kJPFNetworkFailedRegisterNotification";
NSString *const kJANetworkDidLoginNotification = @"kJPFNetworkDidLoginNotification";
NSString *const kJANetworkDidReceiveMessageNotification = @"kJPFNetworkDidReceiveMessageNotification";
NSString *const kJAServiceErrorNotification = @"kJPFServiceErrorNotification";

@interface JANoticeServiceJPush ()
@property (nonatomic,copy) void (^networkDidLoginBlock)(NSNotification *);
@property (nonatomic,copy) void (^networkIsConnectingBlock)(NSNotification *);
@property (nonatomic,copy) void (^networkDidSetupBlock)(NSNotification *);
@property (nonatomic,copy) void (^networkDidRegisterBlock)(NSNotification *);
@property (nonatomic,copy) void (^serviceErrorBlock)(NSNotification *);
@property (nonatomic,copy) void (^networkDidCloseBlock)(NSNotification *);
@property (nonatomic,copy) void (^networkFailedRegisterBlock)(NSNotification *);
@property (nonatomic,copy) void (^netowrkdidReceiveMessageBlock)(NSNotification *);
@end

@implementation JANoticeServiceJPush

- (void)noticeServiceWithTypes:(JANoticeServiceType)types {
    
}

- (void)launchWithLocalNoti:(UILocalNotification *)noti  {
    
}

- (UILocalNotification *)noticeServiceWithTitle:(NSString *)title body:(NSString *)body fireDate:(NSDate *)date {
    return nil;
}

/*!
 * @abstract 启动SDK
 *
 * @param launchingOption 启动参数.
 * @param appKey 一个JPush 应用必须的,唯一的标识. 请参考 JPush 相关说明文档来获取这个标识.
 * @param channel 发布渠道. 可选.
 * @param isProduction 是否生产环境. 如果为开发状态,设置为 NO; 如果为生产状态,应改为 YES.
 * @param advertisingIdentifier 广告标识符（IDFA） 如果不需要使用IDFA，传nil.
 *
 * @discussion 提供SDK启动必须的参数, 来启动 SDK.
 * 此接口必须在 App 启动时调用, 否则 JPush SDK 将无法正常工作.
 */
+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction {
    
    [JPUSHService setupWithOption:launchingOption appKey:appKey channel:channel apsForProduction:isProduction];
}


+ (void)setupWithOption:(NSDictionary *)launchingOption
                 appKey:(NSString *)appKey
                channel:(NSString *)channel
       apsForProduction:(BOOL)isProduction
  advertisingIdentifier:(NSString *)advertisingId {
    
    [JPUSHService setupWithOption:launchingOption appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:advertisingId];
}


- (void)regJPushNotication:(NSString *)notificationEvent
                 execBlock:(void (^)(NSNotification *notification))execBlock {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushNotificationEvent:) name:notificationEvent object:nil];
    
    NSMutableDictionary *notiDic = [self notificationDic];
    
    for (NSString *notiKey in [notiDic allKeys]) {
        if ([notiKey isEqualToString:notificationEvent]) {
            notiDic[notiKey] = execBlock;
        }
    }
    
}

- (void)jpushNotificationEvent:(NSNotification *)noti {
    
    NSMutableDictionary *notiDic = [self notificationDic];
    
    for (NSString *notiKey in [notiDic allKeys]) {
        if ([notiKey isEqualToString:noti.name]) {
            void (^execBlock)(NSNotification *) = notiDic[notiKey];
            if(execBlock) {
                execBlock(noti);
            }
        }
    }
    
}

- (NSMutableDictionary *)notificationDic {
    NSMutableDictionary *notiDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                        kJANetworkIsConnectingNotification:self.networkIsConnectingBlock,
                                        kJANetworkDidSetupNotification:self.networkDidSetupBlock,
                                        kJANetworkDidCloseNotification:self.networkDidCloseBlock,
                                        kJANetworkDidRegisterNotification:self.networkDidRegisterBlock,
                                        kJANetworkFailedRegisterNotification:self.networkFailedRegisterBlock,
                                        kJANetworkDidLoginNotification:self.networkDidLoginBlock,
                                        kJANetworkDidReceiveMessageNotification:self.netowrkdidReceiveMessageBlock,
                                        kJAServiceErrorNotification:self.serviceErrorBlock,
                                   }];
    return notiDic;
}

@end
