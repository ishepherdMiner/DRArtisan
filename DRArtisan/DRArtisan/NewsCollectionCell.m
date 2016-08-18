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
@property (nonatomic,strong) NewsModel *model;
@property (nonatomic,weak) UIImageView *newsImageView;

@end

@implementation NewsCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *newsImageView = [[UIImageView alloc] init];
        [self addSubview:_newsImageView = newsImageView];
    }
    return self;
}

- (void)injectedModel:(id)model {
    _model = model;
   [_newsImageView sd_setImageWithURL:[NSURL URLWithString:_model.small_url]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _newsImageView.frame = self.bounds;
}
@end
