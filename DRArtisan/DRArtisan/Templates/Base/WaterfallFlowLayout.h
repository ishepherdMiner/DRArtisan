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
  heightForItemAtIndexPath:(NSIndexPath*)indexPath
                 itemWidth:(NSUInteger)itemWidth;

/// 处理移动相关的数据源
- (void)moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath
                toIndexPath:(NSIndexPath*)destinationIndexPath;
@end

/**
 *  实现瀑布流的布局
 *  主要思路:
 *    指定行数,collectionView距离整个视图上下的间距,元素间的左右与上下间距和起始的Y值
 *    元素宽度与X可以通过屏幕与上面指定的条件计算得到,高度让外界指定,Y坐标通过找出上一行最小的Y,往上添加
 */
@interface WaterfallFlowLayout : UICollectionViewFlowLayout


/**
 *  Design init method
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
 *  整个collectionView的cell视图与section headerView & footerView的间距
 *
 *  @param marginHeader 与section headerView的间距
 *  @param marginFooter 与section footerView的间距
 */
- (void)marginWithHeader:(CGFloat)marginHeader footer:(CGFloat)marginFooter;

/**
 *  set header && footer size
 *
 *  @param hSize header size
 *  @param fSize footer size
 */
- (void)heightWithHeader:(CGFloat)hHeight footer:(CGFloat)fHeight;

@property (nonatomic,weak) id<WaterfallFlowLayoutDelegate> delegate;
@end
