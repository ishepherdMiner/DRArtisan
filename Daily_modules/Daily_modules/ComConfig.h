//
//  JAComConfig.h
//  Daily_ui_objc_set
//
//  Created by Jason on 17/12/2016.
//  Copyright © 2016 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComConfig : NSObject

@property (nonatomic,strong) NSDictionary *menu;
@property (nonatomic,copy) NSString *moduleName;

+ (instancetype)sharedConfig;
@end
