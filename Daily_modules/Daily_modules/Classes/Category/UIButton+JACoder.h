//
//  UIButton+JACoder.h
//  RssMoney
//
//  Created by Jason on 19/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (JACoder)

@end

// - 来自 Demo_ButtonImageTitleEdgeInsets
typedef NS_ENUM(NSInteger, JAMImagePosition) {
    JAMImagePositionLeft = 0,              //图片在左，文字在右，默认
    JAMImagePositionRight = 1,             //图片在右，文字在左
    JAMImagePositionTop = 2,               //图片在上，文字在下
    JAMImagePositionBottom = 3,            //图片在下，文字在上
};

@interface UIButton (JAMImagePosition)

/**
 *  利用UIButton的titleEdgeInsets和imageEdgeInsets来实现文字和图片的自由排列
 *  注意：这个方法需要在设置图片和文字之后才可以调用，且button的大小要大于 图片大小+文字大小+spacing
 *
 *  @param spacing 图片和文字的间隔
 */
- (void)setImagePosition:(JAMImagePosition)postion spacing:(CGFloat)spacing;

@end
