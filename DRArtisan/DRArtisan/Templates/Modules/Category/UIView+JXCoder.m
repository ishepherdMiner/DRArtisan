//
//  UIView+JXCoder.m
//  DRArtisan
//
//  Created by Jason on 8/24/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "UIView+JXCoder.h"

@implementation UIView (JXCoder)

- (void)swingAnimation:(CFTimeInterval)duration
             direction:(JXSwingDirection)direction {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    if (direction == JXSwingDirectionAround) {
        animation.keyPath = @"position.x";
    }else {
        animation.keyPath = @"position.y";
    }
    
    animation.values = @[@0, @10, @(-10), @10, @0];
    animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1];
    animation.duration = duration;
    animation.additive = true;
    [self.layer addAnimation:animation forKey:@"jx_swing"];
}

- (void)trackingAnimation:(CGRect)boundingRect
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
    [self.layer addAnimation:orbit forKey:@"jx_track"];
}

- (void)trackingAnimation:(CGRect)boundingRect
                 duration:(CFTimeInterval)duration
              repeatCount:(float)repeatCount {
    
    [self trackingAnimation:boundingRect
                   duration:duration
                repeatCount:repeatCount
            calculationMode:kCAAnimationPaced
               rotationMode:nil]; // kCAAnimationRotateAutoReverse
}

@end
