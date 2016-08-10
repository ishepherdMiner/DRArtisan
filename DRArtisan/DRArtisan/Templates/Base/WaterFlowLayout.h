//
//  WaterFlowLayout.h
//  DRArtisan
//
//  Created by Jason on 8/8/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultCollectionCellHeight 60

@class WaterFlowLayout;
@protocol WaterFlowLayoutDelegate <NSObject>

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(WaterFlowLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath*)indexPath
                itemWidth:(NSUInteger)itemWidth;

/// 处理移动相关的数据源
- (void)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath
                toIndexPath:(NSIndexPath *)destinationIndexPath;

@end

@interface WaterFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<WaterFlowLayoutDelegate> delegate;

/**
 *  初始化方法
 *
 *  @param columnsCount   列数
 *  @param lineSpace      行间距
 *  @param interitemSpace item的间距
 *  @param sectionInset   行内间距
 *
 *  @return BaseCollectionViweFlowLayout object
 */
+ (instancetype)LayoutWithColumnsCount:(NSUInteger)columnsCount
                             lineSpace:(CGFloat)lineSpace
                        interitemSpace:(CGFloat)interitemSpace
                          sectionInset:(UIEdgeInsets)sectionInset;

@end
