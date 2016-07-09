//
//  UIImage+Coder.h
//  CoderSummer
//
//  Created by ishpherdme on 27/3/15.
//  Copyright (c) 2015年 ishpherdme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Coder)

/**
 *  调整图片大小
 *
 *  @param imgName 图片名
 */
+ (instancetype)resizeImage:(NSString *)imgName;

/**
 *  图形变圆并加上边框
 *
 *  @param name        图片名
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
+ (instancetype)circleImageWithName:(NSString *)name
                        borderWidth:(CGFloat)borderWidth
                        borderColor:(UIColor *)borderColor;


+ (instancetype)captureWithView:(UIView *)view;

/**
 *  打水印并合并输出
 *
 *  @param mask 水印图像
 *  @param rect 位置
 *
 *  @return 返回合成后的图片
 */
- (UIImage *)imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect;


/**
 *  绘制圆形图片
 *
 *  @return 返回绘制好的圆形图片
 */
- (UIImage *)cirleImage;

/**
 *  绘制指定尺寸的图片
 *
 *  @param size 指定尺寸
 *
 *  @return 指定大小的图片
 */
- (UIImage *)cirleImageWithSize:(CGSize)size;


/**
 *  图片缩放
 *
 *  @param sourceImage 源图片
 *  @param size        目标尺寸
 *
 *  @return 缩放后的图片
 */
- (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;

/**
 *  按照 高 等比例缩放
 *
 *  @param sourceImage  来源图片
 *  @param defineHeight 目标高度
 *
 *  @return 缩放后的图片
 */
- (UIImage *)imageCompressForHeight:(UIImage *)sourceImage targetHeight:(CGFloat)defineHeight;

/**
 *  按照宽等比 缩放
 *
 *  @param sourceImage 来源图片
 *  @param defineWidth 目标宽度
 *
 *  @return 缩放后的图片对象
 */
- (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;


@end
