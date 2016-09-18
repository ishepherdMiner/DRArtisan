//
//  JXHorCollectionViewCell.h
//  DRArtisan
//
//  Created by Jason on 9/18/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXBaseCollectionViewCell.h"

@class JXHorCollectionViewCell;
@protocol JXHorCollectionViewCellDelegate <NSObject>

- (void)cellSelected:(JXHorCollectionViewCell *)cell;

@end

/**
 * 实现滚动的逻辑是一个cell代表一行,里面有一个scrollView,实现滚动
 */
@interface JXHorCollectionViewCell : JXBaseCollectionViewCell <UIScrollViewDelegate>{
    CGFloat supW;
    CGFloat off;
    CGFloat diff;
}

@property (nonatomic,weak) UIScrollView *scroll;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,strong) id<JXHorCollectionViewCellDelegate> cellDelegate;
@end
