//
//  UIColor+JACoder.h
//  Summary
//
//  Created by Jason on 06/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JACoder)

/**
 在指定颜色空间的值 [表述有些问题,我知道,但是我对这方面的知识不够]
 比如 RGB中
 color components 0: 1.000000
 color components 1: 0.121569
 color components 2: 0.258824
 color components 3: 1.000000
 @return 颜色空间中的值的数组
 */
- (NSArray *)colorComponents;


/**
 将原来颜色RGB值都乘以一个系数,生成新的颜色,主要是在给自定义的UIButton提供高粱颜色时使用

 @param rEfficient 红的缩放比例
 @param gEfficient 绿的缩放比例
 @param bEfficient 蓝的缩放比例
 @param aEfficient 透明度的缩放比例
 @return 颜色对象
 */
- (UIColor *)incrementDiffWithRed:(CGFloat)rEfficient
                            green:(CGFloat)gEfficient
                             blue:(CGFloat)bEfficient
                            alpha:(CGFloat)aEfficient;

@end
