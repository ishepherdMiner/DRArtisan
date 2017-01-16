//
//  TimerHelper.m
//  NSTimerTest
//
//  Created by Jason on 19/12/2016.
//  Copyright © 2016 Jason. All rights reserved.
//

#import "JATimerProvider.h"

@interface JATimerProvider ()

@property (nonatomic,strong) NSMutableDictionary *timerDicM;
@property (nonatomic,assign) NSTimeInterval defaultTime;
@end

@implementation JATimerProvider

- (NSString *)timeWithUserinfo:(NSString *)userinfo {
    return [self.timerDicM objectForKey:userinfo];
}

- (instancetype)initWithDefaultTime:(NSTimeInterval)t {
    if (self = [super init]) {
        self.defaultTime = t;
    }
    return self;
}

- (void)timerCenter:(JATimerCenter *)tc execTimer:(NSTimer *)timer {
    //
    [self.timerDicM enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:timer.userInfo]) {
            if ([obj integerValue] > 0) {
                [self.timerDicM setObject:@([obj integerValue] - 1) forKey:key];
                NSLog(@"%s%@",__func__,@([obj integerValue]));
            }else if([obj integerValue] == 0){
                // Timer倒计时已经到0 可进行具体操作
                NSLog(@"%s%@",__func__,@"倒计时结束");
            }
        }
    }];
}

- (void)timerCenter:(JATimerCenter *)tc didCreateTimerWithUserinfo:(NSString *)userinfo {
    NSLog(@"%s",__func__);
    [self.timerDicM setObject:@(self.defaultTime) forKey:userinfo];
}

- (void)timerCenter:(JATimerCenter *)tc didFireTimerWithUserinfo:(NSString *)userinfo {
    // 发送通知 -- 对应的Timer已经启动
    NSLog(@"%s",__func__);
}

- (void)timerCenter:(JATimerCenter *)tc didInvalidTimerWithUserinfo:(NSString *)userinfo {
    NSLog(@"%s",__func__);
    [self.timerDicM removeObjectForKey:userinfo];
}

- (NSMutableDictionary *)timerDicM {
    if (_timerDicM == nil) {
        _timerDicM = [NSMutableDictionary dictionary];
    }
    return _timerDicM;
}


@end
