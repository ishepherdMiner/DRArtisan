//
//  JXSetMealTableView.h
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "JXArtisan.h"

/// 套餐周期
#define MealCycleMonths @[ \
                    @"每 1 月",@"每 2 月",@"每 3 月",@"每 4 月",@"每 5 月",@"每 6 月", \
                    @"每 7 月",@"每 8 月",@"每 9 月",@"每 10 月",@"每 11 月",@"每 12 月"]

/// 结算日期
#define SettleDates @[ \
                    @"01  日",@"02  日",@"03  日",@"04  日",@"05  日", \
                    @"06  日",@"07  日",@"08  日",@"09  日",@"10  日", \
                    @"11  日",@"12  日",@"13  日",@"14  日",@"15  日", \
                    @"16  日",@"17  日",@"18  日",@"19  日",@"20  日", \
                    @"21  日",@"22  日",@"23  日",@"24  日",@"25  日", \
                    @"26  日",@"27  日",@"28  日",@"29  日",@"30  日", \
                    @"31  日"]

/// 套餐流量
#define MealFlows @[ \
                    @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"], \
                    @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"], \
                    @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"], \
                    @[@"MB",@"GB"] \
                  ]

/// 调整流量
#define UsedFlows @[ \
                     @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"], \
                     @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"], \
                     @[@"0.",@"1.",@"2.",@"3.",@"4.",@"5.",@"6.",@"7.",@"8.",@"9."], \
                     @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"], \
                     @[@"MB",@"GB"] \
                    ]

/// 流量不清零
#define FlowNotClear @[@"每 1 月",@"每 2 月",@"每 3 月",@"每 4 月",@"每 5 月",@"每 6 月",@"流量不清零"]

/// 剩余流量
#define LeftFlows UsedFlows

@class JXMealPersistent;

@interface JXSetMealTableView : JXBaseTableView

/**
 *  UIAlertController block
 */
@property (nonatomic,copy) void ((^alertBlock)(UIViewController *));

@property (nonatomic,strong) JXMealPersistent *persistent;

/// 保存计算过程
/// 总流量
@property (nonatomic,copy) NSString *mark_String0;
/// 总流量的单位
@property (nonatomic,copy) NSString *mark_String0_unit;

/// 已使用流量
@property (nonatomic,copy) NSString *mark_String1;
/// 已使用流量的单位
@property (nonatomic,copy) NSString *mark_String1_unit;

/// 剩余流量
@property (nonatomic,copy) NSString *mark_String2;
/// 剩余流量的单位
@property (nonatomic,copy) NSString *mark_String2_unit;

@end
