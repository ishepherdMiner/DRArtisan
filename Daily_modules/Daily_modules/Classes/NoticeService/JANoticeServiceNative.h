//
//  JANoticeServiceNative.h
//  Daily_modules
//
//  Created by Jason on 02/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JANoticeService.h"

@interface JANoticeServiceNative : NSObject <JANoticeServcieDelegate>

@property (nonatomic,strong) NSDictionary *userinfo;  // 通知的额外信息,默认为nil
@property (nonatomic,copy) NSString *soundName;       // 声音名
@property (nonatomic,copy) NSString *alertAction;     // 解锁后显示的状态
@property (nonatomic,copy) NSString *alertLaunchImage;// 通过通知进入应用后的启动屏
@property(nonatomic) NSCalendarUnit repeatInterval;   // 重复频率

/**
 iOS10以下
 // category identifer of the local notification, as set on a UIUserNotificationCategory and passed to +[UIUserNotificationSettings settingsForTypes:categories:]
 iOS10上 等价于 categoryIdentifier
 // The identifier for a registered UNNotificationCategory that will be used to determine the appropriate actions to display for the notification.
 */
@property (nonatomic,copy) NSString *category;

@end
