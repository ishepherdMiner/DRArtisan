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
/// Model object
@property (nonatomic,strong,nullable) JASBaseCellModel *model;

/// cell location
@property (nonatomic,strong,nullable) NSIndexPath *indexPath;

@end
