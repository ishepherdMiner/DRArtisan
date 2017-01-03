//
//  JAComConfig.m
//  Daily_modules_set
//
//  Created by Jason on 17/12/2016.
//  Copyright © 2016 Jason. All rights reserved.
//

#import "ComConfig.h"

@implementation ComConfig

- (NSArray *)dataList {
    if (_dataList == nil) {
        _dataList = @[
                      @{
                          @"name":@"推送",
                          @"ctrl":@"NoticeServiceController",
                        },                      
                      ];
    }
    return _dataList;
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
