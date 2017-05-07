//
//  UIColor+JACoder.m
//  Summary
//
//  Created by Jason on 06/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "UIColor+JACoder.h"

@implementation UIColor (JACoder)

- (NSArray *)colorComponents {
    NSUInteger num = CGColorGetNumberOfComponents(self.CGColor);
    const CGFloat *colorComponents = CGColorGetComponents(self.CGColor);
    NSMutableArray *components = [NSMutableArray arrayWithCapacity:num];
    for (int i = 0; i < num; ++i) {
        [components addObject:@(colorComponents[i])];
    }
    return [components copy];
}

- (UIColor *)incrementDiffWithRed:(CGFloat)rEfficient
                            green:(CGFloat)gEfficient
                             blue:(CGFloat)bEfficient
                            alpha:(CGFloat)aEfficient{
    
    NSArray *colors = [self colorComponents];
    NSAssert(colors.count >= 4, @"当前不是RGB颜色空间,不能使用该方法");
    UIColor *color = [UIColor colorWithRed:[colors[0] doubleValue] * rEfficient green:[colors[1] doubleValue] * gEfficient blue:[colors[2] doubleValue] * bEfficient alpha:aEfficient];
    return color;
}

@end
