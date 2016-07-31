//
//  WaterfallFlowLayout.h
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseCollectionViewFlowLayout.h"

#define kDefaultCollectionCellHeight 60

@class WaterfallFlowLayout;

@protocol WaterfallFlowLayoutDelegate <NSObject>

@required
- (CGFloat)collectionView:(UICollectionView *)collectionView
                    layout:(WaterfallFlowLayout *)layout
  heightForItemAtIndexPath:(NSIndexPath*)indexPath;

@end

/**
 *  实现瀑布流的布局
 */
@interface WaterfallFlowLayout : UICollectionViewFlowLayout

/**
 *  指定的初始化方法是
 *
 *  @param numOfColumns 每行的数量
 *  @param itemSpace    每个item间的最小间距
 *
 *  @return WaterfallFlowLayout object
 */
+ (instancetype)layoutWithColumns:(NSUInteger)columns mininterItemSpace:(CGFloat)mininterItemSpace;

@property (nonatomic,weak) id<WaterfallFlowLayoutDelegate> delegate;
@end
