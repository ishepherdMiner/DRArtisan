//
//  JASValue1Cell.m
//  DRArtisan
//
//  Created by Jason on 7/10/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JASValue1Cell.h"
#import "JASValue1CellModel.h"

@implementation JASValue1Cell

- (void)setModel:(JASValue1CellModel *)model {
    _model = model;
    self.textLabel.text = model.title;
    self.detailTextLabel.text = model.blue_title;
}

@end
