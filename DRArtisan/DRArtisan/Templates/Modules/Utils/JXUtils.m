//
//  JXUtils.m
//  DRArtisan
//
//  Created by Jason on 7/17/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXUtils.h"

// 网络相关
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#include <arpa/inet.h>

#import <AVFoundation/AVFoundation.h>

#define kWiFiSent     kZero
#define kWiFiReceived kOne
#define kWWANSent     kTwo
#define kWWANReceived kThree


@implementation JXUtils
+ (void)logViewRecursive:(UIView *)view {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

    JXLog(@"%@",[view performSelector:@selector(recursiveDescription)]);
    
#pragma clang diagnostic pop
}

+ (void)logViewCtrlRecursive:(UIViewController *)vc {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    JXLog(@"%@",[vc performSelector:@selector(_printHierarchy)]);
    
#pragma clang diagnostic pop
}

+ (NSTimeInterval)timestamp {
    NSDate* date = [NSDate date];
    return (NSTimeInterval)[date timeIntervalSince1970];
}
@end

@implementation JXUtils (Network)

+ (NSArray *)flowCounters {

    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    long long WiFiSent = 0;      // wifi网络 上行数据量
    long long WiFiReceived = 0;  // wifi网络 下行数据量
    long long WWANSent = 0;      // wwan网络 上行数据量
    long long WWANReceived = 0;  // wwan网络 下行数据量
    
    NSString *name = @"";
    
    if (getifaddrs(&addrs) == kStatusSuccess){
        cursor = addrs;
        while (cursor != NULL){
            name = [NSString stringWithFormat:@"%s",cursor->ifa_name];
            // JXLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            if (cursor->ifa_addr->sa_family == AF_LINK){
                // wifi
                if ([name hasPrefix:@"en"]){
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent += networkStatisc->ifi_obytes;
                    WiFiReceived += networkStatisc->ifi_ibytes;
                    
                    // JXLog(@"WiFiSent %lld == %d",WiFiSent,networkStatisc->ifi_obytes);
                    // JXLog(@"WiFiReceived %lld == %d",WiFiReceived,networkStatisc->ifi_ibytes);
                }else if([name hasPrefix:@"pdp_ip"]){
                    // wwan
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent += networkStatisc->ifi_obytes;
                    WWANReceived += networkStatisc->ifi_ibytes;
                    
                    // JXLog(@"WWANSent %lld == %d",WWANSent,networkStatisc->ifi_obytes);
                    // JXLog(@"WWANReceived %lld == %d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    
    JXLog(@"WiFiSent %lld",WiFiSent);
    JXLog(@"WiFiReceived %lld",WiFiReceived);
    JXLog(@"WWANSent %lld",WWANSent);
    JXLog(@"WWANReceived %lld",WWANReceived);
    
    return @[@(WiFiSent), @(WiFiReceived),@(WWANSent),@(WWANReceived)];
}

+ (NSString *)flowUsage:(FlowUsageType)usageType direction:(FlowDirectionOption)directionOption {
    double usage = 0.0;
    if (usageType == FlowUsageTypeWifi) {
        if (directionOption & FlowDirectionOptionUp) {
            usage += [[self unitConversion:[self flowCounters][kWiFiSent]] doubleValue];
        }
        if (directionOption & FlowDirectionOptionDown) {
            usage += [[self unitConversion:[self flowCounters][kWiFiReceived]] doubleValue];
        }
    }else {
        if (directionOption & FlowDirectionOptionUp) {
           usage += [[self unitConversion:[self flowCounters][kWWANSent]] doubleValue];
        }
        if (directionOption & FlowDirectionOptionDown) {
           usage += [[self unitConversion:[self flowCounters][kWWANReceived]] doubleValue];
        }
    }
    return @(usage).stringValue;
}

+ (NSString *)unitConversion:(NSNumber *)flow {
    return @([flow longLongValue] / kMoreMagnitude / kMoreMagnitude).stringValue;
}

@end

@implementation JXUtils (Encrypt)

+ (NSArray *)encryptTable:(NSUInteger )length {
    NSArray *elements = @[@"0",@"1",@"2",@"3",@"4",
                          @"5",@"6",@"7",@"8",@"9",
                          @"a",@"b",@"c",@"d",@"e",
                          @"f"];
    NSMutableArray *tablesM = [NSMutableArray arrayWithCapacity:length];
    NSMutableString *output = [NSMutableString string];
    for (int i = 0; i < length; ++i) {
         int firstInt = arc4random() % [elements count];
         int lastInt = arc4random() % [elements count];
        NSString *tableElement = [NSString stringWithFormat:@"%@%@ ",elements[firstInt],elements[lastInt]];
        if (i % 20 == 0) {
            [output appendString:@"\n"];
        }
        [output appendString:tableElement];
        [tablesM addObject:tableElement];
    }
    JXLog(@"%@",output);
    return [tablesM copy];
}

@end

NSString *RegisterDeviceToken = @"RegisterDeviceToken";
@implementation JXUtils (RemotePush)

+ (void)registerPushService {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 90000
    UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                            settingsForTypes:(UIUserNotificationTypeBadge
                                                              |UIUserNotificationTypeSound
                                                              |UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
#else 
    #if __IPHONE_OS_VERSION_MAX_ALLOWED > 80000
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|
                                UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert) categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    #else 
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    
    #endif
#endif
}

+ (NSString *)postDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@",deviceToken];
    deviceTokenString = [[deviceTokenString substringWithRange:NSMakeRange(1, deviceTokenString.length - 2)] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RegisterDeviceToken object:deviceTokenString];
    
    return deviceTokenString;
    
    // 发送到服务器上
    //    NSDictionary *params = @{@"deviceToken":deviceToken};
    //    [NetworkManager requestJSON:GET URLString:@"api/queryOrder?" Parameters:params Completion:^(id result) {
    //        NSLog(@"%@",result);
    //    }];
    
    ///应用程序处在打开状态，且服务器有推送消息过来时，以及通过推送打开应用程序，走的是这个方法
    //    -(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    //    {
    //        for (id key in userInfo) {
    //            NSLog(@"%@:%@",key, [userInfo objectForKey:key]);
    //        }
    //        
    //        ///Icon推送数量设为0
    //        //  application.applicationIconBadgeNumber=0;
    //    }
}

@end

@implementation JXUtils (LocalPush)

+ (UILocalNotification *)configureLocalPush:(NSString *)alertBody
                                   fireDate:(NSDate *)fireDate
                            launchImageName:(NSString *)launchImageName
                                  soundName:(NSString *)soundName
                                      extra:(NSDictionary *)extra
                             repeatInterval:(NSCalendarUnit)repeat {
    //初始化
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    //设置推送内容
    localNotification.alertBody = alertBody;
    // @"miss you";
    
    //执行时间
    localNotification.fireDate = fireDate;
    // [NSDate dateWithTimeInterval:3 sinceDate:[NSDate date]];
    
    //点击通知进入 app的时候 启动图片
    localNotification.alertLaunchImage = launchImageName;
    // @"VoiceSearchFeedback014@2x.png";
    
#if 0
    // 设置声音
    localNotification.soundName = UILocalNotificationDefaultSoundName;
#endif
    
    // 自定义声音,格式最好是wav,不能超过30秒
    localNotification.soundName = soundName;
    // @"shake_sound_male.wav";
    
    // 添加附加信息
    localNotification.userInfo = extra;
    
    // @{kNotificationKey:@"wekeUpNotificationValue"};
    
    //重复时间(每分钟收到一个本地推送)
    localNotification.repeatInterval = repeat;

    return localNotification;
}

@end

@implementation JXUtils (Device)

//+ (void)monitorWithObserver:(id)observer selector:(SEL)sel option:(ObservedOptions)options{
//    
//    // Remeber remove observer in - dealloc method
//    if (options & ObservedOptionsBrightness) {
//        [[UIScreen mainScreen] addObserver:observer forKeyPath:@"brightness" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
//    }
//    
//    if (options & ObservedOptionsVolumn) {
//        NSError *error;
//        // Active audio session before you listen to the volume change event.
//        // It must be called first.
//        // The old style code equivalent to the line below is:
//        //
//        // AudioSessionInitialize(NULL, NULL, NULL, NULL);
//        // AudioSessionSetActive(YES);
//        //
//        // Now the code above is deprecated in iOS 7.0, you should use the new
//        // code here.
//        [[AVAudioSession sharedInstance] setActive:YES error:&error];
//        
//        // add event handler, for this example, it is `volumeChange:` method
//        [[NSNotificationCenter defaultCenter] addObserver:observer selector:sel name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
//    }
//}

@end