//
//  JASValue2Cell.m
//  DRArtisan
//
//  Created by Jason on 7/10/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JASValue2Cell.h"
#import "JASValue2CellModel.h"

@implementation JASValue2Cell

- (void)setModel:(JASValue2CellModel *)model {
    _model = model;
    self.textLabel.text = model.title;
    self.detailTextLabel.text = model.blue_title;
}

@end
