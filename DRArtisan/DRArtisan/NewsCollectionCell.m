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

@interface NewsCollectionCell ()

@property (nonatomic,weak) UIImageView *newsImageView;

@end

@implementation NewsCollectionCell

- (void)setModel:(NewsModel *)model {
    UIImageView *newsImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [newsImageView setImageWithURL:[NSURL URLWithString:model.image_url]];
    self.model.pass_h = model.pass_h;
    [self addSubview:_newsImageView = newsImageView];
}
@end
