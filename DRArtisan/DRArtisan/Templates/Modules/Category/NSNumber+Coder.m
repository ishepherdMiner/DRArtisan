//
//  NSNumber+Coder.m
//  DRArtisan
//
//  Created by Jason on 7/25/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "NSNumber+Coder.h"

@implementation NSNumber (Coder)
+ (instancetype)randomNumber:(NSUInteger)from to:(NSUInteger)to {
    return @(from + (arc4random() % (to - from + 1)));
}

/// 当我在测试想让图片每次都不缓存时,可以使用这个,在url末尾添加?@(xxx).stringValue
+ (instancetype)randomTimestamp:(NSUInteger)from to:(NSUInteger)to {
    NowTimestamp
    // int value  = arc4random() % (大数 - 小数 + 1) + 小数
    return [NSNumber randomNumber:(timestamp() - from) to:(timestamp() + to)];
}

@end
