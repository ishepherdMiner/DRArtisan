//
//  JASUtils.h
//  DRArtisan
//
//  Created by Jason on 7/17/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseObject.h"

@interface JASUtils : BaseObject

#if DEBUG

/**
 *  输出指定view的层级结构
 *
 *  @param view 被指定的view对象
 */
+ (void)logViewRecursive:(UIView *)view;

/**
 *  输出指定vc的层级结构
 *
 *  @param vc 被指定的vc对象
 */
+ (void)logViewCtrlRecursive:(UIViewController *)vc;

#endif

@end
