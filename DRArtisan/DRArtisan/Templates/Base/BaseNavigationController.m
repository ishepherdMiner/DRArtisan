//
//  CODBaseNavigationController.m
//  Flow
//
//  Created by Jason on 7/5/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    
    // [self.navigationBar setBarTintColor:Jas_HexRGB(0xff0000)];
    
    // 设置导航栏的字体的颜色,字体大小等
    NSDictionary *navigationBarStyle = @{
                                         NSForegroundColorAttributeName:Jas_HexRGB(0xffffff),
                                         NSFontAttributeName:[UIFont boldSystemFontOfSize:20]
                                       };
    
    [self.navigationBar setTitleTextAttributes:navigationBarStyle];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
