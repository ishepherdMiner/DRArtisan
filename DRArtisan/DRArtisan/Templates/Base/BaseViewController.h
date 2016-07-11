//
//  BaseViewController.h
//  Flow
//
//  Created by Jason on 7/5/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseTableViewDelegate;

@interface BaseViewController : UIViewController

@property (nonatomic,strong) id<BaseTableViewDelegate> table_v_impl;

@end
