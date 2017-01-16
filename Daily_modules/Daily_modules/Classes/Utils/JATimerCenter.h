//
//  TimerCenter.h
//  NSTimerTest
//
//  Created by Jason on 19/12/2016.
//  Copyright © 2016 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 TimerCenter *tc = [TimerCenter sharedTimerCenter];
 TimerProvider *provider = [[TimerProvider alloc] initWithDefaultTime:60];
 tc.delegate = provider;
 
 [tc createTimerWithUserinfo:@"tcA"];
 [tc createTimerWithUserinfo:@"tcB"];
 [tc createTimerWithUserinfo:@"tcC"];
 [tc createTimerWithUserinfo:@"tcD"];
 
 // tc.delegate = self;
 
 [tc fireTimerWithUserinfo:@"tcA"];
 sleep(3);
 [tc fireTimerWithUserinfo:@"tcB"];
 sleep(2);
 [tc fireTimerWithUserinfo:@"tcC"];
 dispatch_async(dispatch_queue_create(0, 0), ^{
    sleep(20);
    [tc invalidTimerWithUserinfo:@"tcB"];
 });
 sleep(3);
 [tc invalidTimerWithUserinfo:@"tcA"];
 */

@class JATimerCenter;
@protocol JATimerCenterDelegate <NSObject>

@optional

- (void)timerCenter:(JATimerCenter*)tc execTimer:(NSTimer *)timer;

- (void)timerCenter:(JATimerCenter*)tc didCreateTimerWithUserinfo:(NSString *)userinfo;
- (void)timerCenter:(JATimerCenter*)tc didFireTimerWithUserinfo:(NSString *)userinfo;
- (void)timerCenter:(JATimerCenter*)tc didInvalidTimerWithUserinfo:(NSString *)userinfo;

@end

@interface JATimerCenter : NSObject

@property (nonatomic,assign,readonly) int maxCount;
@property (nonatomic,strong) id<JATimerCenterDelegate> delegate;

+ (instancetype)sharedTimerCenter;
+ (instancetype)sharedTimerCenterWithMaxCount:(int)maxCount;

- (void)createTimerWithUserinfo:(NSString *)userinfo;
- (void)createTimerWithUserinfo:(NSString *)userinfo timeInterval:(NSTimeInterval)ti;
- (void)fireTimerWithUserinfo:(NSString *)userinfo;
- (void)invalidTimerWithUserinfo:(NSString *)userinfo;
- (NSArray *)allUserinfo;

@end
