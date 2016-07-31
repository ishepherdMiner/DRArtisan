//
//  BaseTableView.h
//  DRArtisan
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "AbstractBaseTableView.h"


/**
 *  满足以下条件时可以使用:
 *     1:cell的内容比较简单,使用系统的,或是直接
 *     2.cell的高度用属性设置即可满足
 *     3.不需要定义tableview的header view 或 footer view
 *
 *  使用方法:
    // 控制器
    - (void)baseTableViewDemo {
         // 创建TableView
         BaseTableView *base_table_v = [BaseTableView tableViewWithFrame:fRect(0, 0, Jas_Screen_width, Jas_Screen_height) style:UITableViewStylePlain dataList:[self defaultCellModelList]];
         // 注册cell对象(要求实现:setModel:方法)
         [base_table_v registerClass:[JASDefaultCell class]];
         
         // 设置cell的内容类型,默认为UITableViewCellDefault(option)
         base_table_v.cellStyle = UITableViewCellStyleDefault;
 
         // 添加到父视图
         [self.view addSubview:_base_table_v = base_table_v];
    }
 
    // 模型
    - (NSArray *)defaultCellModelList {
        return @[
            [JASDefaultCellModel modelWithDic:@{
                 @"id":@1,
                 @"title":@"c测试,234...",
                 @"icon":@"http://www.baidu.comadsfadsfads"
            }],
            [JASDefaultCellModel modelWithDic:@{
                 @"id":@2,
                 @"title":@"c测试,2342...c测试,2342...c测试,2342...c测试,2342...c测试,2342...",
                 @"icon":@"http://www.baidu.comadsfadsfads"
            }],
            [JASDefaultCellModel modelWithDic:@{
                 @"id":@3,
                 @"title":@"cfads,测试...",
                 @"icon":@"http://www.baidu.comadsfadsfads"
            }],
            [JASDefaultCellModel modelWithDic:@{
                 @"id":@4,
                 @"title":@"c测试,测试...",
                 @"icon":@"http://www.baidu.comadsfadsfads"
            }],
        ];
     }
 
    // 视图
    - (void)setModel:(JASDefaultCellModel *)model {
        _model = model;
        self.textLabel.text = model.title;
 
        // 当然图片大多数情况下是网络图片
        self.imageView.image = [UIImage imageNamed:model.icon];
    }

 *
 */

@interface BaseTableView : AbstractBaseTableView

/// 数据源是一维数组(true)/二维数组(false)
@property (nonatomic,assign,readonly,getter=isSingleDimension) BOOL singleDimension;

/**
 *  指定的初始化方法
 *
 *  @param frame    tableView的frame
 *  @param style    tableView的样式
 *  @param dataList 数据源
 *
 *  @return BaseTableView object
 */
+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                          dataList:(NSArray *)dataList;


@end
