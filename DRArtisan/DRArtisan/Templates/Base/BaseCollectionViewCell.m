//
//  BaseCollectionViewCell.m
//  DRArtisan
//
//  Created by Jason on 7/28/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "BaseCollectionCellModel.h"

@interface BaseCollectionViewCell ()
@property (nonatomic,weak) UIImageView *testView;
@end

@implementation BaseCollectionViewCell
- (void)setModel:(BaseCollectionCellModel *)model {
    self.backgroundColor = [UIColor redColor];
    // model.pass_h = 80 + (arc4random() % 150);
    _model.pass_h = model.pass_h;
}
@end
 