//
//  JXCircleShapeLayer.h
//  DRArtisan
//
//  Created by Jason on 7/18/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

/**
 *  CAShapeLayer是一个通过矢量图形而不是bitmap来绘制的图层子类。
 *  指定颜色和线宽等属性,用CGPath来定义要绘制的图形,最后CAShapeLayer就自动渲染出来了
 *  优点:
 *    * 渲染快速,使用了硬件加速
 *    * 高效使用内存,CAShapeLayer不需要想普通CALayer一样创建一个寄宿图,所以不会占用大内存
 *    * 不会被图层边界裁减掉。一个CAShapeLayer可以在边界之外绘制
 *    * 不会出现像素化
 */
@interface JXCircleShapeLayer : CAShapeLayer

@property (nonatomic,assign) NSTimeInterval elapsedTime;

@property (nonatomic,assign) NSTimeInterval timeLimit;

/// 百分比
@property (nonatomic,assign,readonly) double percent;

/// 进度条的颜色
@property (nonatomic,strong) UIColor *progressColor;

@end
