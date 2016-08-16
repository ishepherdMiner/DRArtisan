//
//  BaseCollectionCellModel.h
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseObject.h"

@interface BaseCollectionCellModel : BaseObject

/**
 *  返回CollectionView的Cell的item的高度 -
 *
 *  @param itemWidth cell的宽度
 *  @param indexPath cell的位置
 *
 *  @return item的高度
 *
 */
- (CGFloat)calculateHeightWithItemWidth:(CGFloat)itemWidth indexPath:(NSIndexPath *)indexPath;


/**
 *  返回CollectionView的Cell的item的宽度
 *
 *  @param itemHeight cell的高度
 *  @param indexPath  cell的位置
 *
 *  @return item的宽度
 */
- (CGFloat)calculateWidthWithItemHeight:(CGFloat)itemHeight indexPath:(NSIndexPath *)indexPath;

/// 简单对象的封装
// ============================================
/// NSString
@property (nonatomic,copy) NSString *b_string;

/// NSNumber
@property (nonatomic,copy) NSNumber *b_number;

// =============================================
@end
