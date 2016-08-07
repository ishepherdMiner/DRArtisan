//
//  BaseCollectionView.h
//  DRArtisan
//
//  Created by Jason on 7/28/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,XCCollectionViewClassType){
    // 一般的collectionView
    XCCollectionViewClassTypeBase,
    // cell高度能改变的 => 支持瀑布流的collectionView
    XCCollectionViewClassTypeFlexibleHeight,
};

/**
 * 关于UICollectionView的基本介绍
 *  http://www.jianshu.com/p/b0d03c40fd65
 */
@interface BaseCollectionView : AbstractBaseCollectionView

@property (nonatomic,assign,readonly,getter=isSingleDimension) BOOL singleDimension;


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
