//
//  SetMealTableView.h
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "MultidimensionTableView.h"

#define kTotalCellNums 4
#define kNewDecValues @[@"meal_cycle",@"settle_date",@"total_flow",@"used_flow"]

@interface SetMealTableView : FlexibleHeightMultiTableView
/**
 *  UIAlertController block
 */
@property (nonatomic,copy) void ((^alertBlock)(UIViewController *));

/**
 *  用于描述cell的详情字段的值的字典
 *  完整结构为:
 *  @{
 *     @"change":@"false",  // 是否变化,用于弹窗的显示
 *     @"new":@[
 *              @"meal_cycle":@"每 3 月",
 *              @"settle_date":@"每 1 日",
 *              @"total_flow":@"200 M"
 *              @"used_flow":@"8.8M"
 *            ]
 *  }
 */
@property (nonatomic,strong) NSDictionary *desc_dic;

@end
