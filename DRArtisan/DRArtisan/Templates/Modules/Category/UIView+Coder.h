//
//  UIView+Coder.h
//  CoderSummer
//
//  Created by ishpherdme on 8/4/15.
//  Copyright (c) 2015年 ishpherdme. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 设置自身x
#define SetX(value) self.x = value

/// 设置自身y
#define SetY(value) self.y = value

/// 设置自身centerX
#define SetCenterX(value) self.centerX = value

/// 设置自身centerY
#define SetCenterY(value) self.centerY = value

/// 设置自身center
#define SetCenter(x,y) SetCenterX(x); \
SetCenterY(y);

/// 设置自身宽度
#define SetWidth(value) self.w = value

/// 设置自身高度
#define SetHeight(value) self.h = value

/// 设置自身尺寸
#define SetSize(width,height) self.size = CGSizeMake(width,height)

/// 设置控件x
#define SetXForView(view,value) view.x = value

/// 设置控件y
#define SetYForView(view,value) view.y = value

/// 设置控件centerX
#define SetCenterXForView(view,value) view.centerX = value

/// 设置控件centerY
#define SetCenterYForView(view,value) view.centerY = value

/// 设置控件center
#define SetCenterForView(view,x,y) SetCenterXForView(view,x); \
SetCenterYForView(view,y);

/// 设置控件水平居中
#define AlignHorizontal(view) [view alignHorizontal]

/// 设置控件垂直居中
#define AlignVertical(view) [view alignVertical]

/// 设置控件宽度
#define SetWidthForView(view,value) view.w = value

/// 设置控件高度
#define SetHeightForView(view,value) view.h = value

/// 设置控件尺寸
#define SetSizeForView(view, width, height) view.size = CGSizeMake(width, height)

/** 快速添加子控件的宏定义 */
#define AddView(Class, property) [self addSubview:[Class class] propertyName:property]
#define AddViewForView(view, Class, property) [view addSubview:[Class class] propertyName:property]
/**
 *  Category about UIView class
 */
@interface UIView (Coder)

/**
 *  Return YES from the block to recurse into the subview.
 *  Set stop to YES to return the subview.
 */
- (UIView*)findViewRecursively:(BOOL(^)(UIView* subview, BOOL* stop))recurse;

@end

@interface UIView (frame)

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat w;
@property (nonatomic,assign) CGFloat h;

@property (nonatomic,assign) CGSize size;

@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

/** 水平居中 */
- (void)alignHorizontal;
/** 垂直居中 */
- (void)alignVertical;

@end
