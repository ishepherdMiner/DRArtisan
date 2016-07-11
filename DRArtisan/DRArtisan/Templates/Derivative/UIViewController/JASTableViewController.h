//
//  JASTableViewController.h
//  Flow
//
//  Created by Jason on 7/12/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "BaseViewController.h"

@interface JASTableViewController : BaseViewController <BaseTableViewDelegate>

@property (nonatomic,strong) NSArray *table_datas;

@end
