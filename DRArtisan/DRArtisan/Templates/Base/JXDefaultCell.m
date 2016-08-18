//
//  JXDefaultCell.m
//  DRArtisan
//
//  Created by Jason on 7/9/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXDefaultCell.h"
#import "JXDefaultCellModel.h"

@interface JXDefaultCell()

@property (nonatomic,strong) JXDefaultCellModel *model;
@end

@implementation JXDefaultCell

- (void)injectedModel:(id)model {
    _model = model;
    // 设置cell的属性
    self.textLabel.text = _model.title;
    
    // 当然图片大多数情况下是网络图片,需要仿一个网络缓存的框架 先考虑模型那部分,暂时忽略这个
    self.imageView.image = [UIImage imageNamed:_model.icon];
    
    // 设置cell的高度 - 选择JXFlexibleHeightTableView 高度可变的TableView时 这句需要
    // [_model injectedHeight:120];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
