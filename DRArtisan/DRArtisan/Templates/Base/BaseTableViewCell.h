//
//  BaseTableViewCell.h
//  NormalCoder
//
//  Created by Jason on 7/7/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JASBaseCellModel;

@interface BaseTableViewCell : UITableViewCell {
    id _model;
}
/// 模型对象
@property (nonatomic,strong,nullable) JASBaseCellModel *model;

/// cell所属的tableview对象
@property (nonatomic,weak,nullable) BaseTableView *owned_table_v;

/// cell的位置
@property (nonatomic,strong,nullable) NSIndexPath *indexPath;

@end
