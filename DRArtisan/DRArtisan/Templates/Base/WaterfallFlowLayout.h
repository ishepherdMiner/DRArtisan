//
//  WaterfallFlowLayout.h
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseCollectionViewFlowLayout.h"

UIKIT_EXTERN NSString *const XC_UICollectionElementKindSectionHeader;
UIKIT_EXTERN NSString *const XC_UICollectionElementKindSectionFooter;

#define kDefaultCollectionCellHeight 60

@class WaterfallFlowLayout;

@protocol WaterfallFlowLayoutDelegate <NSObject>

@required
- (CGFloat)collectionView:(UICollectionView *)collectionView
                    layout:(WaterfallFlowLayout *)layout
  heightForItemAtIndexPath:(NSIndexPath*)indexPath;

/// 处理移动相关的数据源
- (void)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath
                toIndexPath:(NSIndexPath*)destinationIndexPath;
@end

/**
 *  实现瀑布流的布局
 */
@interface WaterfallFlowLayout : UICollectionViewFlowLayout


/**
 *  指定的初始化方法
 *
 *  @param numberOfColumns  列数
 *  @param lineSpacing      行间距
 *  @param interItemSpacing item间距
 *  @param startY           collection的初识Y位置
 *  @return WaterfallFlowLayout object
 */
+ (instancetype)layoutWithNumOfColumns:(NSUInteger)numberOfColumns
                             lineSpace:(CGFloat)lineSpacing
                       interItemHSpace:(CGFloat)interItemSpacing
                                startY:(CGFloat)startYValue;

/**
 *  set header && footer size
 *
 *  @param hSize header size
 *  @param fSize footer size
 */
- (void)heightWithHeader:(CGFloat)hHeight footer:(CGFloat)fHeight;

@property (nonatomic,weak) id<WaterfallFlowLayoutDelegate> delegate;
@end
