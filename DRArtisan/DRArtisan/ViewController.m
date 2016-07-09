//
//  ViewController.m
//  NormalCoder
//
//  Created by Jason on 6/21/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "ViewController.h"
#import "SingledimensionTableViewCell.h"

@interface ViewController ()

@property (nonatomic,weak) SingledimensionTableView *table_v;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self singledimensionTableViewDemo];
}

// 数据源为一维数组对象
- (void)singledimensionTableViewDemo {
    // 创建列表视图并设置位置
    SingledimensionTableView *table_v = [[SingledimensionTableView alloc] initWithFrame:fRect(0, 0, Jas_Screen_width, Jas_Screen_height) style:UITableViewStylePlain];
    
    // 注册cell对象(要求实现:setModel:方法)
    [table_v registerClass:[SingledimensionTableViewCell class]];
    
    // 设置cell的内容类型,默认为UITableViewCellDefault(option)
    table_v.cellStyle = UITableViewCellStyleSubtitle;
    
    // 提供数据源
    table_v.dataList = [self stringList];
    
    // table_v.dataList = [self stringMoreList];
    // table_v.dataList = [self modelList];
    
    // 添加到父视图
    [self.view addSubview:_table_v = table_v];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - dataSource
- (NSArray *)stringList {
    return @[@"Single",@"Two",@"Three",@"Single",@"Two",@"Three",@"Single",@"Two",@"Three"];
}

- (NSArray *)dicList {
    return @[
             @{
                 @"title":@"title_test1",
                 @"desc":@"desc_test1",
                 },
             @{
                 @"title":@"title_test2",
                 @"desc":@"desc_test2",
                 },
             @{
                 @"title":@"title_test3",
                 @"desc":@"desc_test3",
                 }
             ];
}

- (NSArray *)modelList {
    return nil;
}

@end
