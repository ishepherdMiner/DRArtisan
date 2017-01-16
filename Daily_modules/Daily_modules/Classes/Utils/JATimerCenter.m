//
//  TimerCenter.m
//  NSTimerTest
//
//  Created by Jason on 19/12/2016.
//  Copyright © 2016 Jason. All rights reserved.
//

#import "JATimerCenter.h"

@interface JATimerCenter ()

@property (nonatomic,strong) NSMutableArray *timerListM;
@property (nonatomic,assign) int maxCount;
@end

@implementation JATimerCenter

- (void)invalidTimerWithUserinfo:(NSString *)userinfo {
    NSTimer *t = [self searchTimerWithUserinfo:userinfo];
    if (t) {
        
        [self.timerListM removeObject:t];
        [t invalidate];
        t = nil;
        if([self.delegate respondsToSelector:@selector(timerCenter:didInvalidTimerWithUserinfo:)]) {
            [self.delegate timerCenter:self didInvalidTimerWithUserinfo:userinfo];
        }
        
    }else {
        NSLog(@"未找到useinfo对应的timer对象");
    }
}

- (void)fireTimerWithUserinfo:(NSString *)userinfo {
    NSTimer *t = [self searchTimerWithUserinfo:userinfo];
    if (t) {
        [t fire];
        if([self.delegate respondsToSelector:@selector(timerCenter:didFireTimerWithUserinfo:)]) {
            [self.delegate timerCenter:self didFireTimerWithUserinfo:userinfo];
        }
    }else {
        NSLog(@"未找到useinfo对应的timer对象");
    }
}

- (NSTimer *)searchTimerWithUserinfo:(NSString *)userinfo {
    for (NSTimer *timer in self.timerListM) {
        if ([timer.userInfo isEqualToString:userinfo]) {
            return timer;
        }
    }
    return nil;
}

- (void)createTimerWithUserinfo:(NSString *)userinfo {
    [self createTimerWithUserinfo:userinfo timeInterval:1.0];
}

- (void)createTimerWithUserinfo:(NSString *)userinfo timeInterval:(NSTimeInterval)ti {
    if ([self maxCount] > [[self timerListM] count]) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(execTimer:) userInfo:userinfo repeats:true];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [self.timerListM addObject:timer];
        
        if ([self.delegate respondsToSelector:@selector(timerCenter:didCreateTimerWithUserinfo:)]) {
            [self.delegate timerCenter:self didCreateTimerWithUserinfo:userinfo];
        }
    }
}

- (NSArray *)allUserinfo {
    NSMutableArray *userinfos = [NSMutableArray array];
    for (NSTimer *timer in self.timerListM) {
        [userinfos addObject:timer.userInfo];
    }
    return userinfos;
}

+ (instancetype)sharedTimerCenter{
    static JATimerCenter *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

+ (instancetype)sharedTimerCenterWithMaxCount:(int)maxCount {
    static JATimerCenter *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    instance.maxCount = maxCount;
    
    return instance;
}

- (void)execTimer:(NSTimer *)t {
    if ([self.delegate respondsToSelector:@selector(timerCenter:execTimer:)]) {
        [self.delegate timerCenter:self execTimer:t];
    }
}

- (int)maxCount {
    if (_maxCount == 0) {
        _maxCount = 3; // 默认3个
    }
    return _maxCount;
}

- (NSMutableArray *)timerListM {
    if (_timerListM == nil) {
        _timerListM = [NSMutableArray array];
    }
    
    return _timerListM;
}
@end
