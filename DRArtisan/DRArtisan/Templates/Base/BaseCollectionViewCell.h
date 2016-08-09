//
//  BaseCollectionViewCell.h
//  DRArtisan
//
//  Created by Jason on 7/28/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionCellModel.h"
//@class BaseCollectionCellModel;
@class Photo;
@interface BaseCollectionViewCell : UICollectionViewCell {
    BaseCollectionCellModel *_model;
}

@property (nonatomic,strong) BaseCollectionCellModel *model;

@property (nonatomic,strong) Photo *photo;

@end
