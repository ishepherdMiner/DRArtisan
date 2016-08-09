//
//  NewsCollectionCell.m
//  DRArtisan
//
//  Created by Jason on 8/8/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "NewsCollectionCell.h"
#import "UIKit+AFNetworking.h"
#import "NewsModel.h"
#import "UIImageView+WebCache.h"

@interface NewsCollectionCell ()

@property (nonatomic,weak) UIImageView *newsImageView;

@end

@implementation NewsCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // UIImageView *newsImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        UIImageView *newsImageView = [[UIImageView alloc] init];
        [self addSubview:_newsImageView = newsImageView];
    }
    return self;
}

- (void)setModel:(NewsModel *)model {
    _model = model;

    // [newsImageView setImageWithURL:[NSURL URLWithString:model.small_url]];
    [_newsImageView sd_setImageWithURL:[NSURL URLWithString:model.small_url]];
    // self.model.pass_h = model.pass_h;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _newsImageView.frame = self.bounds;
}
@end
