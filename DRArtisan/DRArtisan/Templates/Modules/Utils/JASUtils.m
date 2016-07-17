//
//  JASUtils.m
//  DRArtisan
//
//  Created by Jason on 7/17/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JASUtils.h"

@implementation JASUtils
+ (void)logViewRecursive:(UIView *)view {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

    JasLog(@"%@",[view performSelector:@selector(recursiveDescription)]);
    
#pragma clang diagnostic pop
}

+ (void)logViewCtrlRecursive:(UIViewController *)vc {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    JasLog(@"%@",[vc performSelector:@selector(_printHierarchy)]);
    
#pragma clang diagnostic pop
}
@end
