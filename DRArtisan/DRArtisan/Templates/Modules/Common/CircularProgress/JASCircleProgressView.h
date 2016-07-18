//
//  JASCircleProgressView.h
//  DRArtisan
//
//  Created by Jason on 7/18/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  
 * To observe or modify the dispatch of action messages to targets for particular events
 
 * To do this, override sendAction:to:forEvent:, evaluate the passed-in selector, target object, or UIControlEvents bit mask, and proceed as required.
 
 * To provide custom tracking behavior (for example, to change the highlight appearance)
 
 * To do this, override one or all of the following methods: beginTrackingWithTouch:withEvent:, continueTrackingWithTouch:withEvent:,endTrackingWithTouch:withEvent:.
 
 * 当需要一个自定义类似UIButton控件,也可自定义响应事件,可以继承UIControl类
 */
@interface JASCircleProgressView : UIControl

@property (nonatomic,assign) NSTimeInterval elapsedTime;

@property (nonatomic,assign) NSTimeInterval timeLimit;

@property (nonatomic,copy) NSString *status;

@property (nonatomic,assign,readonly) double percent;

@end
