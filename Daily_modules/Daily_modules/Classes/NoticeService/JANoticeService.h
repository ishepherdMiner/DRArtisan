//
//  JANoticeService.h
//  Daily_modules
//
//  Created by Jason on 02/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
 #import <UserNotifications/UserNotifications.h>
#endif

typedef NS_ENUM(NSUInteger,JANoticeServiceType){
    JANoticeServiceTypeAll = 1 << 0,
    JANoticeServiceTypeAlert = 1 << 1,
    JANoticeServiceTypeBadge = 1 << 2,
    JANoticeServiceTypeSound = 1 << 3
};

@protocol JANoticeServcieDelegate <NSObject>

- (void)noticeServiceWithTypes:(JANoticeServiceType)types;

/**
 配置本地通知
 
 @param title 标题
 @param body  内容
 @param attachments 附件
 @param trigger 通知触发器
 @param requestId 通知请求标记
 @param handler 回调方法
 */
- (void)noticeServiceWithTitle:(NSString *)title
                          body:(NSString *)body
                   attachments:(NSArray<UNNotificationAttachment *> *)attachments
                       trigger:(UNNotificationTrigger *)trigger
                     requestId:(NSString *)requestId
         withCompletionHandler:(void (^)(NSError *))handler  __IOS_AVAILABLE(10.0);


/**
 发送
 
 @param recvHandler 收到通知的回调
 @param selectedHandler  点击通知的回调
 */
- (void)launchWithRecv:(void (^)())recvHandler
              selected:(void (^)())selectedHandler __IOS_AVAILABLE(10.0);

/**
 配置本地通知
 
 @param title 标题
 @param body 内容
 @param date 触发时间
 @return 通知对象
 */
- (UILocalNotification *)noticeServiceWithTitle:(NSString *)title
                                           body:(NSString *)body
                                       fireDate:(NSDate *)date __IOS_DEPRECATED(7.0, 9.0, "iOS10上使用noticeServiceWithTitle:body:attachment:trigger:requestid:request:withCompletionHandler:");

/**
 发送通知
 */
- (void)launchWithLocalNoti:(UILocalNotification *)noti __IOS_DEPRECATED(7.0, 9.0,"iOS10上使用launchWithRecv:selected替代");

@end

@interface JANoticeService : NSObject

@property (nonatomic,strong,readonly) id<JANoticeServcieDelegate> delegate;
@property (nonatomic,assign,readonly) JANoticeServiceType types;

/// 默认选择所有通知类型
+ (instancetype)registerNoticeServiceWithDelegate:(id<JANoticeServcieDelegate>)delegate __IOS_AVAILABLE(7.0);

/**
 注册通知服务

 @param types 注册的通知类型(badge,alert,sound)
 @param delegate 实现通知功能的代理对象
 @return JANoticeService对象
 */
+ (instancetype)registerNoticeServiceWithTypes:(JANoticeServiceType)types
                                      delegate:(id<JANoticeServcieDelegate>)delegate __IOS_AVAILABLE(7.0);


/**
 仅为发送通知

 @return JANoticeService对象
 */
+ (instancetype)noRegisterService;

/**
 发送本地通知(应用需要退到后台)
 */
- (void)postNoticeWithTitle:(NSString *)title
                       body:(NSString *)body
                   fireDate:(NSDate *)date __IOS_DEPRECATED(7.0, 9.0, "iOS10上使用postNoticeWithTitle:body:attachments:trigger:requestId:recvHandler:selectedHandler:withCompletionHandler:替代");


/**
 发送本地通知

 @param title 标题
 @param body 内容
 @param attachments 附件
 @param trigger 通知触发器
 @param requestId 通知请求
 @param recvHandler 收到通知的回调(应用要处于前台)
 @param selectedHandler 点击通知的回调
 @param handler 回调
 */
- (void)postNoticeWithTitle:(NSString *)title
                       body:(NSString *)body
                attachments:(NSArray<UNNotificationAttachment *>*)attachments
                    trigger:(UNNotificationTrigger *)trigger
                  requestId:(NSString *)requestId
                recvHandler:(void (^)())recvHandler
            selectedHandler:(void (^)())selectedHandler
      withCompletionHandler:(void (^)(NSError *error))handler __IOS_AVAILABLE(10.0);

/**
 将APNs发回的deviceToken处理成字符串类型
 
 @param deviceTokenData 从APNs服务器获得的二进制类型的deviceToken
 */
+ (NSString *)deviceToken:(NSData *)deviceTokenData;

@end
