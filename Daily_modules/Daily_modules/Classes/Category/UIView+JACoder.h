//
//  UIView+JACoder.h
//  Daily_modules
//
//  Created by Jason on 09/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JACoder)

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat w;
@property (nonatomic,assign) CGFloat h;

@property (nonatomic,assign) CGSize size;

@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

/**
 * 水平居中
 */
- (void)ja_alignHor;

/** 
 * 垂直居中 
 */
- (void)ja_alignVer;

/**
 *  Return YES from the block to recurse into the subview.
 *  Set stop to YES to return the subview.
 *  回调中返回 YES 继续查找,返回 NO,去检查 stop 的值,如果stop 为 YES,则返回找到的那个视图
 */
- (UIView*)ja_findViewRecursively:(BOOL(^)(UIView* subview, BOOL* stop))recurse;

@end

typedef NS_ENUM(NSUInteger,JASwingDirection){
    JASwingDirectionAround,  // 左右摇摆
    JASwingDirectionUpdown   // 上下摇摆
};

@interface UIView (JAAnimation)

/**
 *  摇摆动画
 *
 *  @param duration   动画时间
 *  @param direction  摇摆方向
 */
- (void)ja_swingAnimation:(CFTimeInterval)duration
                direction:(JASwingDirection)direction;

/**
 *  轨迹动画
 *
 *  @param boundingRect    轨迹 - 矩形
 *  @param duration        动画时间
 *  @param repeatCount     重复次数
 */
- (void)ja_trackingAnimation:(CGRect)boundingRect
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
- (void)ja_trackingAnimation:(CGRect)boundingRect
                    duration:(CFTimeInterval)duration
                 repeatCount:(float)repeatCount
             calculationMode:(NSString *)calculationMode
                rotationMode:(NSString *)rotationMode;
@end
