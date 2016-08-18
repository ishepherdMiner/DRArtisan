//
//  JXBaseCollectionViewCell.h
//  DRArtisan
//
//  Created by Jason on 7/28/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JXBaseCollectionViewCell : UICollectionViewCell

/**
 *  Inject Cell Model
 *
 *  @param model cell model
 */
- (void)injectedModel:(id)model;

@end
