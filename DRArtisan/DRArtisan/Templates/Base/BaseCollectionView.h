//
//  BaseCollectionView.h
//  DRArtisan
//
//  Created by Jason on 7/28/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickCellBlock)(UICollectionView *collectionView,NSIndexPath *indexPath);

typedef NS_ENUM(NSUInteger,XCCollectionViewDataSourceType){
    XCCollectionViewDataSourceTypeUnassigned,// 未赋值
    XCCollectionViewDataSourceTypeSingle,    // 数据源为一维数组
    XCCollectionViewDataSourceTypeMulti,     // 数据源为二维数组
};

/**
 * 关于UICollectionView的基本介绍
 *  http://www.jianshu.com/p/b0d03c40fd65
 */
@interface BaseCollectionView : AbstractBaseCollectionView

@property (nonatomic,assign,readonly) XCCollectionViewDataSourceType sourceType;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout clickCellBlock:(ClickCellBlock)click;

@end
