//
//  JXBaseViewController.h
//  Flow
//
//  Created by Jason on 7/5/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXBaseTableViewDelegate;

@interface JXBaseViewController : UIViewController

@property (nonatomic,strong) id<JXBaseTableViewDelegate> table_v_impl;

@end
