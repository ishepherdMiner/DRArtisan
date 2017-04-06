//
//  UIView+JACoder.m
//  Daily_modules
//
//  Created by Jason on 09/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "UIView+JACoder.h"

@implementation UIView (JACoder)

- (UIView*)ja_findViewRecursively:(BOOL(^)(UIView* subview, BOOL* stop))recurse{
    for( UIView* subview in self.subviews ) {
        BOOL stop = true;
        if(recurse(subview,&stop)) {
            return [subview ja_findViewRecursively:recurse];
        } else if( stop ) {
            return subview;
        }
    }    
    return nil;
}

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

/** 
 * 水平居中 
 */
- (void)ja_alignHor{
    self.x = (self.superview.w - self.w) * 0.5;
}

/** 
 * 垂直居中 
 */
- (void)ja_alignVer{
    self.y = (self.superview.h - self.h) * 0.5;
}

@end

@implementation UIView (JAAnimation)

- (void)ja_swingAnimation:(CFTimeInterval)duration
                direction:(JASwingDirection)direction {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    if (direction == JASwingDirectionAround) {
        animation.keyPath = @"position.x";
    }else {
        animation.keyPath = @"position.y";
    }
    
    animation.values = @[@0, @10, @(-10), @10, @0];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    animation.duration = duration;
    animation.additive = true;
    [self.layer addAnimation:animation forKey:@"ja_swing"];
}

- (void)ja_trackingAnimation:(CGRect)boundingRect
                    duration:(CFTimeInterval)duration
                 repeatCount:(float)repeatCount
             calculationMode:(NSString *)calculationMode
                rotationMode:(NSString *)rotationMode {
    
    CAKeyframeAnimation *orbit = [CAKeyframeAnimation animation];
    orbit.keyPath = @"position";
    orbit.path = CFAutorelease(CGPathCreateWithEllipseInRect(boundingRect, NULL));
    orbit.duration = duration;
    orbit.additive = true;
    orbit.repeatCount = HUGE_VALF;
    orbit.calculationMode = calculationMode;
    orbit.rotationMode = rotationMode;
    [self.layer addAnimation:orbit forKey:@"ja_track"];
}

- (void)ja_trackingAnimation:(CGRect)boundingRect
                 duration:(CFTimeInterval)duration
              repeatCount:(float)repeatCount {
    
    [self ja_trackingAnimation:boundingRect
                      duration:duration
                   repeatCount:repeatCount
               calculationMode:kCAAnimationPaced
                  rotationMode:nil]; // kCAAnimationRotateAutoReverse
}

@end
