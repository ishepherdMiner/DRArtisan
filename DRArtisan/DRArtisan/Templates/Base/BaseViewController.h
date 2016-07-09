//
//  BaseViewController.h
//  Flow
//
//  Created by Jason on 7/5/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseTableViewProtocol;

@interface BaseViewController : UIViewController

@property (nonatomic,strong) id<BaseTableViewProtocol> table_v_impl;

@end
