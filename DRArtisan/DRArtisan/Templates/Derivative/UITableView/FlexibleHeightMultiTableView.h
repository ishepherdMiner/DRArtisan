//
//  FlexibleHeightMultiTableView.h
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "MultidimensionTableView.h"

/**
 *  满足以下条件建议使用该tableView对象
 *      1.cell内容自定义
 *      2.高度需要指定
 *      3.不需要设置header or footer视图
 *  使用方法
 *   // 视图
 - (void)setModel:(JASDefaultCellModel *)model {
 _model = model;
 self.textLabel.text = model.title;
 
 // 当然图片大多数情况下是网络图片
 self.imageView.image = [UIImage imageNamed:model.icon];
 
 // 设置cell的高度 - 选择FlexibleHeightTableView 高度可变的TableView时 这句需要
 model.cell_h = 120;
 }
 其他与使用BaseTableView时相同
 
 */
@interface FlexibleHeightMultiTableView : MultidimensionTableView

@end
