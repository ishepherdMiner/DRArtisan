//
//  RMTabBarViewController.h
//  RssMoney
//
//  Created by Jason on 11/04/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JATabBarControllerDelegate <NSObject>

@required

/**
 提供``RMTabBarViewController``的TabBar的内容元素
 
 @param titles 标题数组
 @param imgs 正常状态下的图片数组
 @param selectedImgs 选中状态下的图片数组
 */
- (void)customizeTabBarWithTitles:(NSArray *)titles
                           images:(NSArray <UIImage *> *)imgs
                   selectedImages:(NSArray <UIImage *> *)selectedImgs;

/**
 提供``RMTabBarViewController``的控制器数组
 
 @param vcs tabBarController的控制器数组
 */
- (void)customizeTabBarWithControllers:(NSArray <UIViewController *> *) vcs;

@end

@interface JATabBarController : UITabBarController <JATabBarControllerDelegate>

@property (nonatomic,strong,readonly) NSArray <UITabBarItem *> *items;

@end
