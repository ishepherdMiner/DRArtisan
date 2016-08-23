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

/// 当我想要截取数值又不想采用截取字符串的方式时,找到的方法
+ (instancetype)notRounding:(CGFloat)price afterPoint:(int)position{
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:false raiseOnOverflow:false raiseOnUnderflow:false raiseOnDivideByZero:false];
    
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return roundedOunces;
    
}

@end
