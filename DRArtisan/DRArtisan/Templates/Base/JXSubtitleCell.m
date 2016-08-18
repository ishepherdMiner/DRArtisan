//
//  JXSubtitleCell.m
//  DRArtisan
//
//  Created by Jason on 7/10/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXSubtitleCell.h"
#import "JXSubtitleCellModel.h"

@interface JXSubtitleCell()

@property (nonatomic,strong) JXSubtitleCellModel *model;

@end

@implementation JXSubtitleCell

- (void)injectedModel:(id)model {
    _model = model;
    self.textLabel.text = _model.title;
    self.detailTextLabel.text = _model.blue_title;
    
    // 当然图片大多数情况下是网络图片,需要仿一个网络缓存的框架 先考虑模型那部分,暂时忽略这个
    self.imageView.image = [UIImage imageNamed:_model.icon];
    
    // 设置cell的高度 - 选择JXFlexibleHeightTableView 高度可变的TableView时 这句需要
    // [_model injectedHeight:120];
}

@end
