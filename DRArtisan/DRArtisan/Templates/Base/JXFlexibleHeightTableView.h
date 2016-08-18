//
//  JXFlexibleHeightTableView.h
//  DRArtisan
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXBaseTableView.h"

/**
 *  满足以下条件建议使用该tableView对象
 *      1.cell内容自定义
 *      2.高度需要使用代理指定
 *      3.不需要设置header or footer视图
 *  使用方法
 *   // 视图
    - (void)setModel:(JXDefaultCellModel *)model {
        _model = model;
        self.textLabel.text = model.title;
     
        // 当然图片大多数情况下是网络图片
        self.imageView.image = [UIImage imageNamed:model.icon];
 
        // 设置cell的高度 - 选择JXFlexibleHeightTableView 高度可变的TableView时 这句需要
        model.cell_h = 120;
     }
    其他与使用BaseTableView时相同

 */
@interface JXFlexibleHeightTableView : JXBaseTableView

@end
