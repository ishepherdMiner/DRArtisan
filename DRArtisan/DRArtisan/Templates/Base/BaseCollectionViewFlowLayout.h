//
//  BaseCollectionViewFlowLayout.h
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewFlowLayout : UICollectionViewFlowLayout

/**
 *  指定初始化方法
 *
 *  @param itemSize          cell的尺寸
 *  @param minLineSpace      最小的行间距
 *  @param minInteritemSpace item的最小间距
 *  @param sectionInset      行内间距
 *
 *  @return BaseCollectionViweFlowLayout object
 */
+ (instancetype)LayoutWithItemSize:(CGSize)itemSize
                      minLineSpace:(CGFloat)minLineSpace
                 minInteritemSpace:(CGFloat)minInteritemSpace
                      sectionInset:(UIEdgeInsets)sectionInset ;

/**
 *  set header && footer size
 *
 *  @param hSize header size
 *  @param fSize footer size
 */
- (void)sizeWithHeader:(CGSize)hSize footer:(CGSize)fSize;

@end
