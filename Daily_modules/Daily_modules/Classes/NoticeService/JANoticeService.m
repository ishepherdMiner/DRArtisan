//
//  JANoticeService.m
//  Daily_modules
//
//  Created by Jason on 02/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JANoticeService.h"

@interface JANoticeService ()
@property (nonatomic,strong) id<JANoticeServcieDelegate> delegate;
@property (nonatomic,assign) JANoticeServiceType types;
@end

@implementation JANoticeService

+ (instancetype)sharedNoticeService {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (instancetype)registerNoticeServiceWithDelegate:(id<JANoticeServcieDelegate>)delegate {
    return [self registerNoticeServiceWithTypes:JANoticeServiceTypeAll delegate:delegate];
}

+ (instancetype)registerNoticeServiceWithTypes:(JANoticeServiceType)types delegate:(id<JANoticeServcieDelegate>)delegate {
    JANoticeService *service = [JANoticeService sharedNoticeService];
    service.delegate = delegate;
    service.types = types;
    
    if ([service.delegate respondsToSelector:@selector(noticeServiceWithTypes:)]) {
        [service.delegate noticeServiceWithTypes:service.types];
    }else {
        NSLog(@"delegate is nil or not responds noticeServiceWithTypes:");
    }
    
    return service;
}

+ (instancetype)noRegisterService {
    return [JANoticeService sharedNoticeService];
}

+ (NSString *)deviceToken:(NSData *)deviceTokenData {
     NSString *deviceTokenString = [NSString stringWithFormat:@"%@",deviceTokenData];
     return [[deviceTokenString substringWithRange:NSMakeRange(1, deviceTokenString.length - 2)] stringByReplacingOccurrencesOfString:@" " withString:@""];
}


- (void)postNoticeWithTitle:(NSString *)title
                       body:(NSString *)body
                   fireDate:(NSDate *)date {
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
        if ([self.delegate respondsToSelector:@selector(noticeServiceWithTitle:body:fireDate:)]) {
            UILocalNotification *noti = [self.delegate noticeServiceWithTitle:title body:body fireDate:date];
            
            if ([self.delegate respondsToSelector:@selector(launchWithLocalNoti:)]) {
                [self.delegate launchWithLocalNoti:noti];
            }
        }
    }else {
        NSLog(@"Greater than or equal to iOS10 use: postNoticeWithTitle:body:categoryId:attachments:request:willHandler:didHandler:withCompletionHandler");
    }
}

- (void)postNoticeWithTitle:(NSString *)title
                       body:(NSString *)body
                attachments:(NSArray<UNNotificationAttachment *>*)attachments
                    trigger:(UNNotificationTrigger *)trigger
                  requestId:(NSString *)requestId
             presentHandler:(void (^)(UNNotification *noticaiton))presentHandler
            receiverHandler:(void (^)(UNNotificationResponse *reponse))receiverHandler
      withCompletionHandler:(void (^)(NSError *error))handler{
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >=10.0) {
        if ([self.delegate respondsToSelector:@selector(noticeServiceWithTitle:body:attachments:trigger:requestId:withCompletionHandler:)]) {
            [self.delegate noticeServiceWithTitle:title body:body attachments:attachments trigger:trigger requestId:requestId withCompletionHandler:handler];
            
            if ([self.delegate respondsToSelector:@selector(launchWithPresented:received:)]) {
                [self.delegate launchWithPresented:presentHandler received:receiverHandler];
            }
            
        }
    }else {
        NSLog(@"Less than iOS10 use: postNoticeWithTitle:body:");
    }
}

@end
