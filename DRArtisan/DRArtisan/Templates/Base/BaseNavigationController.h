//
//  CODBaseNavigationController.h
//  Flow
//
//  Created by Jason on 7/5/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,NavRightType){
    NavRightTypeTitle,
    NavRightTypeImage,
    NavRightTypeSeg,
};

@interface BaseNavigationController : UINavigationController

/**
 * 导航条右侧添加单个视图
 *
 *  @param rightType 视图
 */
- (void)customRightViewWithType:(NavRightType)rightType content:(id)content;

- (void)customTitleView:(UISegmentedControl *)segmentedControl;

- (void)customPromptTitle:(NSString *)promptTitle;

@end
