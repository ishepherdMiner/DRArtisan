//
//  UIView+JXCoder.h
//  DRArtisan
//
//  Created by Jason on 8/24/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,JXSwingDirection){
    JXSwingDirectionAround,  // 左右摇摆
    JXSwingDirectionUpdown   // 上下摇摆
};
@interface UIView (JXCoder)

/**
 *  摇摆动画
 *
 *  @param duration   动画时间
 *  @param direction  摇摆方向
 */
- (void)swingAnimation:(CFTimeInterval)duration
             direction:(JXSwingDirection)direction;

/**
 *  轨迹动画
 *
 *  @param boundingRect    轨迹 - 矩形
 *  @param duration        动画时间
 *  @param repeatCount     重复次数
 */
- (void)trackingAnimation:(CGRect)boundingRect
                 duration:(CFTimeInterval)duration
              repeatCount:(float)repeatCount;
/**
 *  轨迹动画
 *
 *  @param boundingRect    轨迹 - 矩形
 *  @param duration        动画时间
 *  @param repeatCount     重复次数
 *  @param calculationMode 动画计算模式
 *  @param rotationMode    动画旋转模式
 */
- (void)trackingAnimation:(CGRect)boundingRect
                 duration:(CFTimeInterval)duration
              repeatCount:(float)repeatCount
          calculationMode:(NSString *)calculationMode
             rotationMode:(NSString *)rotationMode;
@end
