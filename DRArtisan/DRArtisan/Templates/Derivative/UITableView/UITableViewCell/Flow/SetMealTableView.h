//
//  SetMealTableView.h
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//


#define kMealCycleMonths @[ \
                    @"每 1 月",@"每 2 月",@"每 3 月",@"每 4 月",@"每 5 月",@"每 6 月", \
                    @"每 7 月",@"每 8 月",@"每 9 月",@"每 10 月",@"每 11 月",@"每 12 月"]

#define kSettleDates @[ \
                    @"01  日",@"02  日",@"03  日",@"04  日",@"05  日", \
                    @"06  日",@"07  日",@"08  日",@"09  日",@"10  日", \
                    @"11  日",@"12  日",@"13  日",@"14  日",@"15  日", \
                    @"16  日",@"17  日",@"18  日",@"19  日",@"20  日", \
                    @"21  日",@"22  日",@"23  日",@"24  日",@"25  日", \
                    @"26  日",@"27  日",@"28  日",@"29  日",@"30  日", \
                    @"31  日"]

#define kTotalCellNums 4
#define kMealCycle  kZero
#define kSettleDate kOne
#define kTotalFlow  kTwo
#define kUsedFlow   kThree
#define kNewDescValues @[@"meal_cycle",@"settle_date",@"total_flow",@"used_flow"]

@interface SetMealTableView : JXBaseTableView
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
