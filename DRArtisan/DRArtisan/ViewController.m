//
//  ViewController.m
//  NormalCoder
//
//  Created by Jason on 6/21/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "ViewController.h"
#import "DemoModel.h"
#import "CommentModel.h"

@interface ViewController ()

@property (nonatomic,weak) SingledimensionTableView *table_v;

@property (nonatomic, weak) BaseTableView *base_table_v;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self baseTableViewDemo];
}

// 数据源为一维数组对象
- (void)singledimensionTableViewDemo {
    // 创建列表视图并设置位置
    SingledimensionTableView *table_v = [[SingledimensionTableView alloc] initWithFrame:fRect(kZero, kZero,Screen_width, Screen_height) style:UITableViewStylePlain];
    
    // 注册cell对象(要求实现:setModel:方法)
    [table_v registerClass:[JASValue1Cell class]];
    
    // 设置cell的内容类型,默认为UITableViewCellDefault(option)
     table_v.cellStyle = UITableViewCellStyleValue1;
    
    // 提供数据源
    table_v.dataList = [self stringList];
    
    // 添加到父视图
    [self.view addSubview:_table_v = table_v];
}

- (void)baseTableViewDemo {
    // 创建TableView
    BaseTableView *base_table_v = [FlexibleHeightTableView tableViewWithFrame:fRect(kZero,kZero, Screen_width, Screen_height) style:UITableViewStylePlain dataList:[self defaultCellModelList]];
    // 注册cell对象(要求实现:setModel:方法)
    [base_table_v registerClass:[JASDefaultCell class]];
    
    // 设置cell的内容类型,默认为UITableViewCellDefault(option)
    base_table_v.cellStyle = UITableViewCellStyleDefault;
    
    // 添加到父视图
    [self.view addSubview:_base_table_v = base_table_v];
}

#pragma mark - Demo
- (void)defaultCellDemo {
    // 创建列表视图并设置位置
    SingledimensionTableView *table_v = [[SingledimensionTableView alloc] initWithFrame:fRect(kZero,kZero, Screen_width, Screen_height) style:UITableViewStylePlain];
    
    // 注册cell对象(要求实现:setModel:方法)
    [table_v registerClass:[JASDefaultCell class]];
    
    // 设置cell的内容类型,默认为UITableViewCellDefault(option)
    // table_v.cellStyle = UITableViewCellStyleValue1;
    
    // 提供数据源
    table_v.dataList = [self defaultCellModelList];
    
    // 添加到父视图
    [self.view addSubview:_table_v = table_v];
}

- (void)value1CellDemo {
    // 创建列表视图并设置位置
    SingledimensionTableView *table_v = [[SingledimensionTableView alloc] initWithFrame:fRect(kZero,kZero,Screen_width, Screen_height) style:UITableViewStylePlain];
    
    // 注册cell对象(要求实现:setModel:方法)
    [table_v registerClass:[JASValue1Cell class]];
    
    // 设置cell的内容类型,默认为UITableViewCellDefault(option)
    table_v.cellStyle = UITableViewCellStyleValue1;
    
    // 提供数据源
    // table_v.dataList = [self defaultCellModelList];
    table_v.dataList = [self value1CellModelList];
    
    // 添加到父视图
    [self.view addSubview:_table_v = table_v];
}

- (void)value2CellDemo {
    // 创建列表视图并设置位置
    SingledimensionTableView *table_v = [[SingledimensionTableView alloc] initWithFrame:fRect(kZero,kZero, Screen_width, Screen_height) style:UITableViewStylePlain];
    
    // 注册cell对象(要求实现:setModel:方法)
    [table_v registerClass:[JASValue2Cell class]];
    
    // 设置cell的内容类型,默认为UITableViewCellDefault(option)
    table_v.cellStyle = UITableViewCellStyleValue2;
    
    // 提供数据源
    // table_v.dataList = [self defaultCellModelList];
    table_v.dataList = [self value1CellModelList];
    
    // 添加到父视图
    [self.view addSubview:_table_v = table_v];
}

- (void)subtitleCellDemo {
    // 创建列表视图并设置位置
    SingledimensionTableView *table_v = [[SingledimensionTableView alloc] initWithFrame:fRect(kZero,kZero, Screen_width, Screen_height) style:UITableViewStylePlain];
    
    // 注册cell对象(要求实现:setModel:方法)
    [table_v registerClass:[JASSubtitleCell class]];
    
    // 设置cell的内容类型,默认为UITableViewCellDefault(option)
    table_v.cellStyle = UITableViewCellStyleSubtitle;
    
    //
    
    // 提供数据源
    // table_v.dataList = [self defaultCellModelList];
    table_v.dataList = [self subtitleCellModelList];
    
    // 添加到父视图
    [self.view addSubview:_table_v = table_v];
}

#pragma mark - dataSource

// 字典转模型
- (NSArray *)defaultCellModelList {
    return @[
             [JASDefaultCellModel objWithDic:@{
                                                   @"id":@1,
                                                   @"title":@"c测试,234...",
                                                   @"icon":@"http://www.baidu.comadsfadsfads"
                                                   }],
             [JASDefaultCellModel objWithDic:@{
                                                   @"id":@2,
                                                   @"title":@"c测试,2342...c测试,2342...c测试,2342...c测试,2342...c测试,2342...",
                                                   @"icon":@"http://www.baidu.comadsfadsfads"
                                                   }],
             [JASDefaultCellModel objWithDic:@{
                                                   @"id":@3,
                                                   @"title":@"cfads,测试...",
                                                   @"icon":@"http://www.baidu.comadsfadsfads"
                                                   }],
             [JASDefaultCellModel objWithDic:@{
                                                   @"id":@4,
                                                   @"title":@"c测试,测试...",
                                                   @"icon":@"http://www.baidu.comadsfadsfads"
                                                   }],
             ];
}

- (NSArray *)value1CellModelList {
    return @[
             [JASValue1CellModel objWithDic:@{
                                              @"id":@1,
                                              @"title":@"c测试,234...",
                                              @"blue_title":@"忘掉了挨个打算暗示"
                                              }
             ],
             [JASValue1CellModel objWithDic:@{
                                              @"id":@1,
                                              @"title":@"c测试,234...",
                                              @"blue_title":@"忘掉了挨个打算暗示"
                                              }
              ],
             [JASValue1CellModel objWithDic:@{
                                              @"id":@1,
                                              @"title":@"c测试,234...",
                                              @"blue_title":@"忘掉了挨个打算暗示"
                                              }
              ],
             [JASValue1CellModel objWithDic:@{
                                              @"id":@1,
                                              @"title":@"c测试,234...",
                                              @"blue_title":@"忘掉了挨个打算暗示"
                                              }
              ],
            ];
}

- (NSArray *)subtitleCellModelList {
    return @[
             [JASSubtitleCellModel objWithDic:@{
                                                @"id":@1,
                                                @"title":@"c测试,234...",
                                                @"blue_title":@"忘掉了挨个打算暗示",
                                                @"image":@"fadsfadsfadsfadsfadsfdsa"
                                                }],
             [JASSubtitleCellModel objWithDic:@{
                                                @"id":@1,
                                                @"title":@"c测试,234...",
                                                @"blue_title":@"忘掉了挨个打算暗示",
                                                @"image":@"fadsfadsfadsfadsfadsfdsa"
                                                }],
             [JASSubtitleCellModel objWithDic:@{
                                                @"id":@1,
                                                @"title":@"c测试,234...",
                                                @"blue_title":@"忘掉了挨个打算暗示",
                                                @"image":@"fadsfadsfadsfadsfadsfdsa"
                                                }],
             [JASSubtitleCellModel objWithDic:@{
                                                @"id":@1,
                                                @"title":@"c测试,234...",
                                                @"blue_title":@"忘掉了挨个打算暗示",
                                                @"image":@"fadsfadsfadsfadsfadsfdsa"
                                                }],
             ];
}

- (NSArray *)moreLowDicList {
    return @[[CommentModel objWithDic:@{
                                               @"id": @"347",
                                               @"topic_id": @"225",
                                               @"user_id": @"87",
                                               @"content": @"啊",
                                               @"reply_num": @"5",
                                               @"create_date": @"1466502431",
                                               @"nickname": @"风一样的男子",
                                               @"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"
                                               
                                     }],
             [CommentModel objWithDic:@{
                                     
                                               @"id": @"348",
                                               @"topic_id": @"225",
                                               @"user_id": @"87",
                                               @"content": @"啊",
                                               @"reply_num": @"5",
                                               @"create_date": @"1466502431",
                                               @"nickname": @"风一样的男子",
                                               @"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"
                                               
                                     }]
             
             
             ];
}

- (NSArray *)moreDicList {
    return @[[DemoModel objWithDic:@{@"god_comment":
                                        @{
                                              @"id": @"347",
                                              @"topic_id": @"225",
                                              @"user_id": @"87",
                                              @"content": @"啊",
                                              @"reply_num": @"5",
                                              @"create_date": @"1466502431",
                                              @"nickname": @"风一样的男子",
                                              @"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"
                                         }
                                     }],
             [DemoModel objWithDic:@{@"god_comment":
                                         @{
                                               @"id": @"348",
                                               @"topic_id": @"225",
                                               @"user_id": @"87",
                                               @"content": @"啊",
                                               @"reply_num": @"5",
                                               @"create_date": @"1466502431",
                                               @"nickname": @"风一样的男子",
                                               @"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"
                                            }
                                     }]

             
             ];
    /*
    return @[@{@"god_comment": @[@{@"id": @"347",@"topic_id": @"225",@"user_id": @"87",@"content": @"啊",@"reply_num": @"5",@"create_date": @"1466502431",@"nickname": @"风一样的男子",@"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"}],@"comment_list": @{@"p": @2,@"total": @"15",@"data": @[@{
                                                                                                                                                                                                                                                                                                                                                                                              @"id": @"351",
                                                                                                                                                                                                                                                                                                                                                                                              @"topic_id": @"225",
                                                                                                                                                                                                                                                                                                                                                                                              @"user_id": @"87",
                                                                                                                                                                                                                                                                                                                                                                                              @"content": @"睡觉睡觉就是",
                                                                                                                                                                                                                                                                                                                                                                                              @"reply_num":@"0",
                                                                                                                                                                                                                                                                                                                                                                                              @"create_date": @"1466502443",
                                                                                                                                                                                                                                                                                                                                                                                              @"nickname": @"风一样的男子",
                                                                                                                                                                                                                                                                                                                                                                                              @"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"
                                                                                                                                                                                                                                                                                                                                                                                              },
                                                                                                                                                                                                                                                                                                                                                                                          @{
                                                                                                                                                                                                                                                                                                                                                                                              @"id": @"350",
                                                                                                                                                                                                                                                                                                                                                                                              @"topic_id": @"225",
                                                                                                                                                                                                                                                                                                                                                                                              @"user_id": @"87",
                                                                                                                                                                                                                                                                                                                                                                                              @"content": @"只能是女神",
                                                                                                                                                                                                                                                                                                                                                                                              @"reply_num": @"0",
                                                                                                                                                                                                                                                                                                                                                                                              @"create_date": @"1466502440",
                                                                                                                                                                                                                                                                                                                                                                                              @"nickname": @"风一样的男子",
                                                                                                                                                                                                                                                                                                                                                                                              @"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"
                                                                                                                                                                                                                                                                                                                                                                                              }
                                                                                                                                                                                                                                                                                                                                                                                          ]
                                                                                                                                                                                                                                                                                                                                                      }
                            }
                 ];
     */
    
}


// 数据源为字符串数组
- (NSArray *)stringList {
    return @[@"Single",@"Two",@"Three",@"Single",@"Two",@"Three",@"Single",@"Two",@"Three"];
}

// 数据源为字典数组
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

@end
