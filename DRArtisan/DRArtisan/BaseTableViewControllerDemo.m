//
//  BaseTableViewControllerDemo.m
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseTableViewControllerDemo.h"

@interface BaseTableViewControllerDemo ()

@property (nonatomic,weak) BaseTableView *base_table_v;

@end

@implementation BaseTableViewControllerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Show demo
    [self baseTableViewDemo];
}

- (void)baseTableViewDemo {
    
    // 创建TableView
    BaseTableView *base_table_v = [FlexibleHeightTableView tableViewWithFrame:fRect(kZero,kZero, Screen_width, Screen_height) style:UITableViewStylePlain dataList:[self defalutModels]];
    
    // 注册cell对象(要求实现:setModel:方法)
    [base_table_v registerClass:[JASDefaultCell class]];
    
    // 设置cell的内容类型,默认为UITableViewCellDefault(option)
    base_table_v.cellStyle = UITableViewCellStyleDefault;
    
    // 添加到父视图
    [self.view addSubview:_base_table_v = base_table_v];
}

// 字典转模型
- (NSArray *)defalutModels {
    NSArray *dicList = @[
                         @{
                             @"id":@1,
                             @"title":@"c测试,234...",
                             @"icon":@"http://www.baidu.comadsfadsfads"
                             },
                         @{
                             @"id":@2,
                             @"title":@"c测试,2342...c测试,2342...c测试,2342...c测试,2342...c测试,2342...",
                             @"icon":@"http://www.baidu.comadsfadsfads"
                             },
                         @{
                             @"id":@3,
                             @"title":@"cfads,测试...",
                             @"icon":@"http://www.baidu.comadsfadsfads"
                             },
                         @{
                             @"id":@4,
                             @"title":@"c测试,测试...",
                             @"icon":@"http://www.baidu.comadsfadsfads"
                             }
                         ];
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:[dicList count]];
    for (int i = 0; i < [dicList count]; ++i) {
        [models addObject:[JASDefaultCellModel modelWithDic:dicList[i]]];
    }
    return [models copy];
}


@end
