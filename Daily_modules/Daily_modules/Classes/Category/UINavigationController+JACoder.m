//
//  UINavigationController+JACoder.m
//  Daily_modules
//
//  Created by Jason on 20/04/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "UINavigationController+JACoder.h"
#import "NSObject+JACoder.h"

@implementation UINavigationController (JACoder)

+ (void)load {
    [self ja_hookMethod:[self class] OriginSelector:@selector(pushViewController:animated:) SwizzledSelector:@selector(ja_pushViewController:animated:)];
    [self ja_hookMethod:[self class] OriginSelector:@selector(popViewControllerAnimated:) SwizzledSelector:@selector(ja_popViewControllerAnimated:)];
}

- (void)ja_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.topViewController.hidesBottomBarWhenPushed = true;
    
    [self ja_pushViewController:viewController animated:animated];
}

- (UIViewController *)ja_popViewControllerAnimated:(BOOL)animated {
    NSUInteger index = [self.viewControllers indexOfObject:self.topViewController];
    if (index == 1) {
        self.viewControllers[index - 1].hidesBottomBarWhenPushed = false;
    }else {
        self.viewControllers[index - 1].hidesBottomBarWhenPushed = true;
    }
    return [self ja_popViewControllerAnimated:true];
}
@end
