//
//  JANoticeServiceNative.m
//  Daily_modules
//
//  Created by Jason on 02/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JANoticeServiceNative.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    #import <UserNotifications/UserNotifications.h>
#endif

@interface JANoticeServiceNative () <UNUserNotificationCenterDelegate>

@property (nonatomic,copy) void (^recvHandler)();
@property (nonatomic,copy) void (^selectedHandler)();
@property (nonatomic,strong) UILocalNotification *noti;
@property (nonatomic) UNAuthorizationOptions options;
@property (nonatomic) BOOL canSound;
@end

@implementation JANoticeServiceNative

- (void)noticeServiceWithTypes:(JANoticeServiceType)types {
    // iOS10
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0){
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    UNAuthorizationOptions options = UNAuthorizationOptionNone;
    
    if (types & JANoticeServiceTypeAll) {
        options = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
        self.canSound = true;
    }else {
        if (types & JANoticeServiceTypeAlert) {
            options = options | UNAuthorizationOptionAlert;
        }
        
        if (types & JANoticeServiceTypeBadge) {
            options = options | UNAuthorizationOptionBadge;
        }
        
        if (types & JANoticeServiceTypeSound) {
            options = options | UNAuthorizationOptionSound;
            self.canSound = true;
        }
    }
    
    self.options = options;
    
    // 必须写代理，不然无法监听通知的接收与点击
    center.delegate = self;
    [center requestAuthorizationWithOptions:(options) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            // 点击允许
            NSLog(@"授权成功");
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                // NSLog(@"%@", settings);
            }];
        } else {
            // 点击不允许
            NSLog(@"授权失败");
        }
    }];
    }else if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        // iOS8,9
        UIUserNotificationType options = UIUserNotificationTypeNone;
        if (types & JANoticeServiceTypeAll) {
            options = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        }else {
            if (types & JANoticeServiceTypeAlert) {
                options = options | UIUserNotificationTypeAlert;
            }
            
            if (types & JANoticeServiceTypeBadge) {
                options = options | UIUserNotificationTypeBadge;
            }
            
            if (types & JANoticeServiceTypeSound) {
                options = options | UIUserNotificationTypeSound;
            }
        }
        // 1.注册UserNotification,以获取推送通知的权限
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:options categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        // 2.注册远程推送
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        // iOS8之前,注册远程推送的方法
#ifndef NSFoundationVersionNumber_iOS_8_0
        UIRemoteNotificationType options = UIRemoteNotificationTypeNone;
        if (types & JANoticeServiceTypeAll) {
            options = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
        }else {
            if (types & JANoticeServiceTypeAlert) {
                options = options | UIRemoteNotificationTypeAlert;
            }
            
            if (types & JANoticeServiceTypeBadge) {
                options = options | UIRemoteNotificationTypeBadge;
            }
            
            if (types & JANoticeServiceTypeSound) {
                options = options | UIRemoteNotificationTypeSound;
            }
        }
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:options];
#endif
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    UNNotificationPresentationOptions preOptions = [JANoticeServiceNative reverseOptions:self.options];
    completionHandler(preOptions);
    self.recvHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    completionHandler();
    self.selectedHandler();
}

- (UILocalNotification *)noticeServiceWithTitle:(NSString *)title
                                           body:(NSString *)body
                                       fireDate:(NSDate *)date {
    
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.2) {
        noti.alertTitle = title;
    }
    
    noti.alertBody = body;
    noti.fireDate = date;
    
    if (self.repeatInterval) {
        noti.repeatInterval = self.repeatInterval;
    }else {
        noti.repeatInterval = NSCalendarUnitEra;
    }
    
    // 允许声音提醒
    if (self.canSound) {
        if (self.soundName) {
            noti.soundName = self.soundName;
        }else {
            noti.soundName = UILocalNotificationDefaultSoundName;
        }
    }
    
    if (self.userinfo) {
        noti.userInfo = self.userinfo;
    }
    
    if (self.alertAction) {
        noti.alertAction = self.alertAction;
    }
    
    if (self.alertLaunchImage) {
        noti.alertLaunchImage = self.alertLaunchImage;
    }
    
    self.noti = noti;
    
    return noti;
}

- (void)noticeServiceWithTitle:(NSString *)title
                          body:(NSString *)body
                   attachments:(NSArray<UNNotificationAttachment *> *)attachments
                       trigger:(UNNotificationTrigger *)trigger
                     requestId:(NSString *)requestId
         withCompletionHandler:(void (^)(NSError *))handler {
    
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.body = body;
    
    if (self.userinfo) {
        content.userInfo = self.userinfo;
    }
    
    if (self.canSound) {
        if (self.soundName) {
            content.sound = [UNNotificationSound soundNamed:self.soundName];
        }else {
            content.sound = [UNNotificationSound defaultSound];
        }
    }
    
    if (self.alertLaunchImage) {
        content.launchImageName = self.alertLaunchImage;
    }
    
    // 添加附件
    if (attachments && attachments.count > 0) {
        content.attachments = attachments;
    }
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestId content:content trigger:trigger];
    
    // 请求
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:handler];
}

- (void)launchWithRecv:(void (^)())recvHandler selected:(void (^)())selectedHandler {
    self.recvHandler = recvHandler;
    self.selectedHandler = selectedHandler;
}

- (void)launchWithLocalNoti:(UILocalNotification *)noti {
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

+ (UNNotificationPresentationOptions)reverseOptions:(UNAuthorizationOptions)options {
    UNNotificationPresentationOptions preOptions = UNNotificationPresentationOptionNone;
    if (options & UNAuthorizationOptionBadge) {
        preOptions = preOptions | UNNotificationPresentationOptionBadge;
    }
    
    if (options & UNAuthorizationOptionSound) {
        preOptions = preOptions | UNNotificationPresentationOptionSound;
    }
    
    if (options & UNAuthorizationOptionAlert) {
        preOptions = preOptions | UNNotificationPresentationOptionAlert;
    }
    return preOptions;
}

@end
