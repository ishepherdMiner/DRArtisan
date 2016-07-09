//
//  UIView+Coder.h
//  CoderSummer
//
//  Created by ishpherdme on 8/4/15.
//  Copyright (c) 2015年 ishpherdme. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Category about UIView class
 */
@interface UIView (Coder)

@end

@interface UIView (frame)

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat w;
@property (nonatomic,assign) CGFloat h;

@property (nonatomic,assign) CGSize size;

@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

@end
