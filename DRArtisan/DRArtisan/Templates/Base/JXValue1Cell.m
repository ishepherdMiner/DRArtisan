//
//  JXValue1Cell.m
//  DRArtisan
//
//  Created by Jason on 7/10/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXValue1Cell.h"
#import "JXValue1CellModel.h"

@interface JXValue1Cell ()

@property (nonatomic,strong) JXValue1CellModel *model;

@end

@implementation JXValue1Cell

- (void)injectedModel:(id)model {
    _model = model;
    
    self.textLabel.text = _model.title;
    self.detailTextLabel.text = _model.blue_title;
    
    // 设置cell的高度 - 选择JXFlexibleHeightTableView 高度可变的TableView时 这句需要
     [_model injectedHeight:120];
}

@end
