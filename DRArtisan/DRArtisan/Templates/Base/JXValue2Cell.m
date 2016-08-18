//
//  JXValue2Cell.m
//  DRArtisan
//
//  Created by Jason on 7/10/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXValue2Cell.h"
#import "JXValue2CellModel.h"

@interface JXValue2Cell ()

@property (nonatomic,strong) JXValue2CellModel *model;

@end

@implementation JXValue2Cell

- (void)injectedModel:(id)model {
    _model = model;
    self.textLabel.text = _model.title;
    self.detailTextLabel.text = _model.blue_title;
    
    // 设置cell的高度 - 选择JXFlexibleHeightTableView 高度可变的TableView时 这句需要
    // [_model injectedHeight:120];
}

@end
