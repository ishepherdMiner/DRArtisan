//
//  BaseCollectionViewCell.h
//  DRArtisan
//
//  Created by Jason on 7/28/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseCollectionCellModel;

@interface BaseCollectionViewCell : UICollectionViewCell {
    BaseCollectionCellModel *_model;
}

@property (nonatomic,strong) BaseCollectionCellModel *model;

@end
