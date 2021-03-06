//
//  JAComConfig.m
//  Daily_modules_set
//
//  Created by Jason on 17/12/2016.
//  Copyright © 2016 Jason. All rights reserved.
//

#import "ComConfig.h"

@implementation ComConfig

- (NSDictionary *)menu {
    return @{
             @"app":@[
                     @{
                         @"name":@"推送",
                         @"ctrl":@"NoticeServiceController",
                         },
                     @{
                         @"name":@"摇一摇",
                         @"ctrl":@"ShakeController"
                         },
                     @{
                         @"name":@"3D-Touch Peek",
                         @"ctrl":@"PeekViewController"
                         },
                     @{
                         @"name":@"Touch ID",
                         @"ctrl":@"_TtC13Daily_modules21TouchIDViewController"
                         }
                     ],
             @"system":@[
                     ],
             @"framworks":@[
                     ],
             };
}

- (NSString *)moduleName {
    if (_moduleName == nil) {
        _moduleName = @"Daily_modules_set";
    }
    return _moduleName;
}

+ (instancetype)sharedConfig {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}
@end
