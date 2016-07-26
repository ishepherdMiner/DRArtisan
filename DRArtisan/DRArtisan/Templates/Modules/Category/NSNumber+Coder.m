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
@end
