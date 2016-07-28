//
//  BaseCollectionView.h
//  DRArtisan
//
//  Created by Jason on 7/28/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionView : AbstractBaseCollectionView

/**
 *  指定的初始化方法
 *
 *  @param frame    frame
 *  @param style    style
 *  @param dataList 数据源
 *
 *  @return BaseCollectionView object
 */
+ (instancetype)collectionViewWithFrame:(CGRect)frame
                                  style:(UICollectionViewLayout *)style
                               dataList:(NSArray *)dataList ;

@end
