//
//  TimerHelper.h
//  NSTimerTest
//
//  Created by Jason on 19/12/2016.
//  Copyright © 2016 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JATimerCenter.h"

@interface JATimerProvider : NSObject <JATimerCenterDelegate>

- (instancetype)initWithDefaultTime:(NSTimeInterval)t;

- (NSString *)timeWithUserinfo:(NSString *)userinfo;

@end
