//
//  NoticeServiceController.m
//  Daily_modules
//
//  Created by Jason on 02/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "NoticeServiceController.h"
#import "JANoticeServiceKit.h"


@interface NoticeServiceController ()

@end

@implementation NoticeServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    JANoticeService *service = [JANoticeService noRegisterService];
    if ([service.delegate isKindOfClass:[JANoticeServiceNative class]]) {
        JANoticeServiceNative *native = (JANoticeServiceNative *)service.delegate;
        native.soundName = @"sound.caf";
        native.userinfo = @{@"id":@1,@"user":@"Jason"};
        native.alertAction = @"晚上好";
    }
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"invited_3_02@2x" ofType:@"png"];
        UNNotificationAttachment *attach = [UNNotificationAttachment attachmentWithIdentifier:@"abc" URL:[NSURL fileURLWithPath:path] options:nil error:nil];
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];;
        
        [service postNoticeWithTitle:@"嘿" body:@"小妞" attachments:@[attach] trigger:trigger requestId:@"go" presentHandler:^(UNNotification *noticaiton) {
            
            NSLog(@"展现通知");
            
        } receiverHandler:^(UNNotificationResponse *reponse) {
            
            NSLog(@"点击通知");
            
        } withCompletionHandler:^(NSError *error) {
            
            if(error) {
                NSLog(@"%@",error);
            }
        }];
        
    }else if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
        
        // 本地推送 应用必须在后台
        [service postNoticeWithTitle:@"嘿" body:@"大牛" fireDate:[NSDate dateWithTimeIntervalSinceNow:7]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
