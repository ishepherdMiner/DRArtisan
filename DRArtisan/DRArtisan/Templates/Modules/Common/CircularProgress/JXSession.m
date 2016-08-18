//
//  JXSession.m
//  DRArtisan
//
//  Created by Jason on 7/18/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXSession.h"

@implementation JXSession

- (NSTimeInterval)progressTime {
    // 设置了finishDate 即返回开始时间与结束时间的时间差
    if(_finishDate) {
        return [_finishDate timeIntervalSinceDate:self.startDate];
    }else {
        // 没有就返回当前时间与开始时间的时间差
        return [[NSDate date] timeIntervalSinceDate:self.startDate];
    }
}

@end
