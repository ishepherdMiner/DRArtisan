//
//  JASSubtitleCell.m
//  DRArtisan
//
//  Created by Jason on 7/10/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JASSubtitleCell.h"
#import "JASSubtitleCellModel.h"

@implementation JASSubtitleCell

- (void)setModel:(JASSubtitleCellModel *)model {
    _model = model;
    self.textLabel.text = model.title;
    self.detailTextLabel.text = model.blue_title;
    
    // 当然图片大多数情况下是网络图片,需要仿一个网络缓存的框架 先考虑模型那部分,暂时忽略这个
    self.imageView.image = [UIImage imageNamed:model.icon];

}

@end
