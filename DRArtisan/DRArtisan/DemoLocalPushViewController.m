//
//  DemoLocalPushViewController.m
//  DRArtisan
//
//  Created by Jason on 8/19/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "DemoLocalPushViewController.h"
#import "JXUtils.h"

// 本地通知的key
static const NSString *kNotificationKey = @"localNotification";
@implementation DemoLocalPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"本地推送";
    
    NSDate *date = [NSDate dateWithTimeInterval:3 sinceDate:[NSDate date]];
    NSDictionary *extra = @{kNotificationKey:@"wakeUpNotificationValue"};
    
    UILocalNotification *localNoti = [JXUtils configureLocalPush:@"Hello world"
                                                        fireDate:date
                                                 launchImageName:@"VoiceSearchFeedback014@2x.png"
                                                       soundName:@"shake_sound_male.wav"
                                                           extra:extra
                                                  repeatInterval:NSCalendarUnitMinute];
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNoti];
}

@end
