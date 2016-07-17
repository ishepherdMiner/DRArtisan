//
//  UIView+Coder.m
//  CoderSummer
//
//  Created by ishpherdme on 8/4/15.
//  Copyright (c) 2015年 ishpherdme. All rights reserved.
//

#import "UIView+Coder.h"

@implementation UIView (Coder)

@end

@implementation UIView (frame)

- (CGFloat)x {
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)h {
    return self.frame.size.height;
}

- (void)setH:(CGFloat)h {
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}

- (CGFloat)w{
    return self.frame.size.width;
}

- (void)setW:(CGFloat)w{
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint point = self.center;
    point.x = centerX;
    self.center = point;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint point = self.center;
    point.y = centerY;
    self.center = point;
}

/** 水平居中 */
- (void)alignHorizontal
{
    self.x = (self.superview.w - self.w) * 0.5;
}

/** 垂直居中 */
- (void)alignVertical
{
    self.y = (self.superview.h - self.h) * 0.5;
}


@end
