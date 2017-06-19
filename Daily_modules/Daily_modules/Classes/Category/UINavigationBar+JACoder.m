//
//  UINavigationBar+JACoder.m
//  Summary
//
//  Created by Jason on 03/05/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "UINavigationBar+JACoder.h"

@implementation UINavigationBar (JACoder)

+ (void)whiteAppearance {
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 导航栏字体颜色
    [navBar setTitleTextAttributes:@{
                                     NSForegroundColorAttributeName:[UIColor whiteColor]
                                     }];
    
    /*
     * 当使用背景图时设置是无效
     
    // 导航栏标题颜色
    // [navBar setBarTintColor:[UIColor colorWithRed:1.0 green:31/255.0 blue:66/255.0 alpha:1.0]];
    
    // 导航栏背景色
    // navBar.tintColor = [UIColor whiteColor];
     */
}

@end
