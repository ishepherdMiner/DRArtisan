//
//  BaseTableViewCell.h
//  NormalCoder
//
//  Created by Jason on 7/7/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXBaseTableViewCell : UITableViewCell

/// cell location
@property (nonatomic,strong) NSIndexPath *indexPath;

/**
 *  Injected model object to cell,when you custome cell,you need override this method
 *
 *  @param model the cell bind model property
 */
- (void)injectedModel:(id)model;

@end
