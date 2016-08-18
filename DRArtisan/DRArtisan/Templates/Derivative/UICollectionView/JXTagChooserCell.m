//
//  JXTagChooserCell.m
//  DRArtisan
//
//  Created by Jason on 8/16/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXTagChooserCell.h"
#import "JXTagChooserModel.h"

@interface JXTagChooserCell ()

@property (nonatomic,strong) JXTagChooserModel *model;

@property (nonatomic,weak) UILabel *markLabel;

@end

@implementation JXTagChooserCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *markLabel = [[UILabel alloc] initWithFrame:self.bounds];
        markLabel.textAlignment = NSTextAlignmentCenter;
        
        markLabel.textColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
        
        markLabel.layer.borderColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(200) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0].CGColor;
        
        markLabel.layer.borderWidth = 0.5;
        markLabel.layer.cornerRadius = 5;
        markLabel.layer.masksToBounds = true;
        
        [self addSubview:_markLabel = markLabel];
    }
    return self;
}

- (void)injectedModel:(id)model {
    _model = model;
    _markLabel.text = _model.b_string;
}



@end
