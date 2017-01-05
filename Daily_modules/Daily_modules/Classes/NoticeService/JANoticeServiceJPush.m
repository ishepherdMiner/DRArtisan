//
//  JANoticeServiceJPush.m
//  Daily_modules
//
//  Created by Jason on 02/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JANoticeServiceJPush.h"
#import "JPUSHService.h"

@implementation JANoticeServiceJPush

- (void)noticeServiceWithTypes:(JANoticeServiceType)types {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotice:) name:kJPFNetworkIsConnectingNotification object:nil];
    
    
    
}

@end
