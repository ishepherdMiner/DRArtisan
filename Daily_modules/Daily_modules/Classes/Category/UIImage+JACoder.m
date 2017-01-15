//
//  UIImage+JACoder.m
//  Daily_modules
//
//  Created by Jason on 12/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "UIImage+JACoder.h"

@implementation UIImage (JACoder)

- (UIImage *)cropImageWithSize:(CGSize)size {
    CGFloat WH = MIN(size.width, size.height);
    CGRect rect = CGRectMake(0, 0, WH, WH);
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    [self drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageWithCorner:(CGFloat)corner{
    CGFloat WH = MIN(self.size.width, self.size.height);
    CGRect rect = CGRectMake(0, 0, WH, WH);
    UIGraphicsBeginImageContextWithOptions(self.size, false, 0);
    UIBezierPath *path = nil;
    if (corner < WH * 0.5) {
        path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:corner];
    }else {
        path = [UIBezierPath bezierPathWithOvalInRect:rect];
    }
    [path addClip];
    [self drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (instancetype)imageWithUIColor:(UIColor *)color size:(CGSize)size{
    return [self imageWithCGColor:color.CGColor size:size];
}
+ (instancetype)imageWithCGColor:(CGColorRef)colorref size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, colorref);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
