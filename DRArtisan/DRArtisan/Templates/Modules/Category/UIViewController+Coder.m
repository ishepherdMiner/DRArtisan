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
    Method originMethod = class_getInstanceMethod(self.class, @selector(viewDidLoad));
    Method swissMethod = class_getInstanceMethod(self.class, @selector(jas_viewDidLoad));
    method_exchangeImplementations(originMethod, swissMethod);
    
    originMethod = class_getInstanceMethod(self.class, @selector(viewWillAppear:));
    swissMethod = class_getInstanceMethod(self.class, @selector(jas_viewWillAppear:));
    method_exchangeImplementations(originMethod, swissMethod);
    
    originMethod = class_getInstanceMethod(self.class, @selector(viewDidAppear:));
    swissMethod = class_getInstanceMethod(self.class, @selector(jas_viewDidAppear:));
    method_exchangeImplementations(originMethod, swissMethod);
    
    originMethod = class_getInstanceMethod(self.class, @selector(viewWillDisappear:));
    swissMethod = class_getInstanceMethod(self.class, @selector(jas_viewWillDisappear:));
    method_exchangeImplementations(originMethod, swissMethod);
    
    originMethod = class_getInstanceMethod(self.class, @selector(viewDidDisappear:));
    swissMethod = class_getInstanceMethod(self.class, @selector(jas_viewDidDisappear:));
    method_exchangeImplementations(originMethod, swissMethod);
    
    originMethod = class_getInstanceMethod(self.class,@selector(pushViewController:animated:));
    swissMethod = class_getInstanceMethod(self.class,@selector(jas_pushViewController:animated:));
    method_exchangeImplementations(originMethod,swissMethod);
    
    originMethod = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
    swissMethod  = class_getInstanceMethod(self.class, @selector(jas_presentViewController:animated:completion:));
    method_exchangeImplementations(originMethod,swissMethod);
}

- (void)jas_viewDidLoad {
    // JasLog(@"%@|视图加载|%s",self.class,__func__);
    [self jas_viewDidLoad];
}

- (void)jas_viewWillAppear:(BOOL)animate {
    // JasLog(@"%@|视图即将出现|%s",self.class,__func__);
    [self jas_viewWillAppear:animate];
}

- (void)jas_viewDidAppear:(BOOL)animate {
    // JasLog(@"%@|视图已经出现|%s",self.class,__func__);
    [self jas_viewDidAppear:animate];
}

- (void)jas_viewWillDisappear:(BOOL)animate {
    // JasLog(@"%@|视图即将消失|%s",self.class,__func__);
    [self jas_viewWillDisappear:animate];
}

- (void)jas_viewDidDisappear:(BOOL)animate {
    // JasLog(@"%@|视图已经消失|%s",self.class,__func__);
    [self jas_viewDidDisappear:animate];
}

- (void)jas_pushViewController:(UIViewController *)vc animated:(BOOL)animated{
    if ([self isKindOfClass:UINavigationController.class]) {
        // JasLog(@"%@|push视图控制器|%s",self.class,__func__);
        [self jas_pushViewController:vc animated:animated];
        vc.view.tag = kTargetVCFromPush;
    }
}

- (void)jas_presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^ __nullable)(void))completion{
    if ([self isKindOfClass:UINavigationController.class]) {
        // JasLog(@"%@|pop视图控制器|%s",self.class,__func__);
        [self jas_presentViewController:vc animated:animated completion:completion];
        vc.view.tag = kTargetVCFromPresent;
    }
}

@end
