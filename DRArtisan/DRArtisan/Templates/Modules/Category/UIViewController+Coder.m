//
//  UIViewController+Coder.m
//  Market
//
//  Created by jxon on 4/4/16.
//  Copyright © 2016 jxon. All rights reserved.
//

#import "UIViewController+Coder.h"
#import <objc/message.h>
#import "JXBaseObject.h"
#import "JXSwitch.h"

#define kTargetVCFromPresent  13579  // 目标控制器是被present的
#define kTargetVCFromPush     24689  // 目标控制器是被push的

@implementation UIViewController (Coder)

+ (void)load {
    
    [JXBaseObject hookMethod:self OriginSelector:@selector(viewDidLoad)  SwizzledSelector:@selector(jx_viewDidLoad)];
    
    [JXBaseObject hookMethod:self OriginSelector:@selector(viewWillAppear:) SwizzledSelector:@selector(jx_viewWillAppear:)];
    
     [JXBaseObject hookMethod:self OriginSelector:@selector(viewDidAppear:) SwizzledSelector:@selector(jx_viewDidAppear:)];
    
    [JXBaseObject hookMethod:self OriginSelector:@selector(viewWillDisappear:) SwizzledSelector:@selector(jx_viewWillDisappear:)];
    
    [JXBaseObject hookMethod:self OriginSelector:@selector(viewDidDisappear:) SwizzledSelector:@selector(jx_viewDidDisappear:)];
    
    [JXBaseObject hookMethod:self OriginSelector:@selector(pushViewController:animated:) SwizzledSelector:@selector(jx_pushViewController:animated:)];
    
    [JXBaseObject hookMethod:self OriginSelector:@selector(presentViewController:animated:completion:) SwizzledSelector:@selector(jx_presentViewController:animated:completion:)];
    
}

- (void)jx_viewDidLoad {
     JXLog(@"%@|视图加载|%s",self.class,__func__);
    [self jx_viewDidLoad];
}

- (void)jx_viewWillAppear:(BOOL)animate {
     JXLog(@"%@|视图即将出现|%s",self.class,__func__);
    [self jx_viewWillAppear:animate];
}

- (void)jx_viewDidAppear:(BOOL)animate {
     JXLog(@"%@|视图已经出现|%s",self.class,__func__);
    [self jx_viewDidAppear:animate];
}

- (void)jx_viewWillDisappear:(BOOL)animate {
     JXLog(@"%@|视图即将消失|%s",self.class,__func__);
    [self jx_viewWillDisappear:animate];
}

- (void)jx_viewDidDisappear:(BOOL)animate {
     JXLog(@"%@|视图已经消失|%s",self.class,__func__);
    [self jx_viewDidDisappear:animate];
}

- (void)jx_pushViewController:(UIViewController *)vc animated:(BOOL)animated{
    if ([self isKindOfClass:UINavigationController.class]) {
         JXLog(@"%@|push视图控制器|%s",self.class,__func__);
        [self jx_pushViewController:vc animated:animated];
        vc.view.tag = kTargetVCFromPush;
    }
}

- (void)jx_presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^ __nullable)(void))completion{
    if ([self isKindOfClass:UINavigationController.class]) {
         JXLog(@"%@|pop视图控制器|%s",self.class,__func__);
        [self jx_presentViewController:vc animated:animated completion:completion];
        vc.view.tag = kTargetVCFromPresent;
    }
}

#pragma mark - 兼容iOS10
- (void)jx_hiddenNavigationBarBackGround{
    for(UIView *subview in self.navigationController.navigationBar.subviews) {
        if([subview isKindOfClass:UIImageView.class]) {
            [subview setHidden:YES];
        }
        if ([subview isKindOfClass:[UIView class]] && CGRectGetHeight(subview.frame) == 64) {
            subview.hidden = YES;
        }
    }
}

@end
