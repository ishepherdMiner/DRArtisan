//
//  UIViewController+Coder.m
//  Market
//
//  Created by jason on 4/4/16.
//  Copyright © 2016 jason. All rights reserved.
//

#import "UIViewController+Coder.h"
#import <objc/message.h>

#define kTargetVCFromPresent  13579  // 目标控制器是被present的
#define kTargetVCFromPush     24689  // 目标控制器是被push的

@implementation UIViewController (Coder)

+ (void)load {
    
    [JXBaseObject hookMethod:self OriginSelector:@selector(viewDidLoad)  SwizzledSelector:@selector(jas_viewDidLoad)];
    
    [JXBaseObject hookMethod:self OriginSelector:@selector(viewWillAppear:) SwizzledSelector:@selector(jas_viewWillAppear:)];
    
     [JXBaseObject hookMethod:self OriginSelector:@selector(viewDidAppear:) SwizzledSelector:@selector(jas_viewDidAppear:)];
    
    [JXBaseObject hookMethod:self OriginSelector:@selector(viewWillDisappear:) SwizzledSelector:@selector(jas_viewWillDisappear:)];
    
    [JXBaseObject hookMethod:self OriginSelector:@selector(viewDidDisappear:) SwizzledSelector:@selector(jas_viewDidDisappear:)];
    
    [JXBaseObject hookMethod:self OriginSelector:@selector(pushViewController:animated:) SwizzledSelector:@selector(jas_pushViewController:animated:)];
    
    [JXBaseObject hookMethod:self OriginSelector:@selector(presentViewController:animated:completion:) SwizzledSelector:@selector(jas_presentViewController:animated:completion:)];
    
}

- (void)jas_viewDidLoad {
     XcLog(@"%@|视图加载|%s",self.class,__func__);
    [self jas_viewDidLoad];
}

- (void)jas_viewWillAppear:(BOOL)animate {
     XcLog(@"%@|视图即将出现|%s",self.class,__func__);
    [self jas_viewWillAppear:animate];
}

- (void)jas_viewDidAppear:(BOOL)animate {
     XcLog(@"%@|视图已经出现|%s",self.class,__func__);
    [self jas_viewDidAppear:animate];
}

- (void)jas_viewWillDisappear:(BOOL)animate {
     XcLog(@"%@|视图即将消失|%s",self.class,__func__);
    [self jas_viewWillDisappear:animate];
}

- (void)jas_viewDidDisappear:(BOOL)animate {
     XcLog(@"%@|视图已经消失|%s",self.class,__func__);
    [self jas_viewDidDisappear:animate];
}

- (void)jas_pushViewController:(UIViewController *)vc animated:(BOOL)animated{
    if ([self isKindOfClass:UINavigationController.class]) {
         XcLog(@"%@|push视图控制器|%s",self.class,__func__);
        [self jas_pushViewController:vc animated:animated];
        vc.view.tag = kTargetVCFromPush;
    }
}

- (void)jas_presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^ __nullable)(void))completion{
    if ([self isKindOfClass:UINavigationController.class]) {
         XcLog(@"%@|pop视图控制器|%s",self.class,__func__);
        [self jas_presentViewController:vc animated:animated completion:completion];
        vc.view.tag = kTargetVCFromPresent;
    }
}

@end
