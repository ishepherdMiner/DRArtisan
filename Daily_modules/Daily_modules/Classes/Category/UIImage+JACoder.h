//
//  UIImage+JACoder.h
//  Daily_modules
//
//  Created by Jason on 12/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JACoder)

/**
 生成圆角图片
 小于图片MIN(长,宽),绘制圆角
 若大于等于图片MIN(长,宽),绘制椭圆

 @param corner 圆角弧度
 @return 圆角图片
 */
- (UIImage *)ja_imageWithCorner:(CGFloat)corner;

/**
 生成UIImage对象

 @param color 颜色值
 @param size 尺寸
 @return UIImage对象
 */
+ (instancetype)ja_imageWithUIColor:(UIColor *)color size:(CGSize)size;
+ (instancetype)ja_imageWithCGColor:(CGColorRef)colorref size:(CGSize)size;

/**
 裁剪UIImage对象

 @param size 裁剪后尺寸
 @return UIImage对象
 */
- (UIImage *)ja_cropImageWithSize:(CGSize)size;

/// 旋转图片
- (UIImage*)ja_rotate:(UIImageOrientation)orient;

@end
