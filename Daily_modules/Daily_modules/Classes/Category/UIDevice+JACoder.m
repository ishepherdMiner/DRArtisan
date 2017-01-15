//
//  UIDevice+JACoder.m
//  Daily_modules
//
//  Created by Jason on 14/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "UIDevice+JACoder.h"

#import <objc/message.h>
#import <CoreMotion/CoreMotion.h>

const char *gyroKey = "gyroKey";

@implementation UIDevice (JACoder)

+ (instancetype)sharedDevice {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

#if DEBUG
+ (void)gyroWithStartBlock:(void (^)(CMGyroData *gyroData,NSError *error))handler {
    
    CMMotionManager *manager = nil;
    if (objc_getAssociatedObject([self sharedDevice], gyroKey)) {
        manager = objc_getAssociatedObject([self sharedDevice], gyroKey);
    }else {
        // 初始化全局管理对象
        manager = [[CMMotionManager alloc] init];
        objc_setAssociatedObject([self sharedDevice], gyroKey, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSMutableArray *rs = [NSMutableArray array];
    if (manager.deviceMotionAvailable) {
        [rs addObjectsFromArray:@[@(manager.gyroData.rotationRate.x),@(manager.gyroData.rotationRate.y),@(manager.gyroData.rotationRate.z)]];
    }
    
    // 判断陀螺仪可不可以，判断陀螺仪是不是开启
    if ([manager isGyroAvailable]){
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        manager.gyroUpdateInterval = 0.5;
        
        // Push方式获取和处理数据
        [manager startGyroUpdatesToQueue:queue
                             withHandler:^(CMGyroData *gyroData, NSError *error)
         {
             handler(gyroData,error);
         }];
    }
}

#endif
@end
