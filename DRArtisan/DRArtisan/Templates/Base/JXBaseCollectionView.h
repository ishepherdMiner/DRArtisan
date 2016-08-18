//
//  BaseCollectionView.h
//  DRArtisan
//
//  Created by Jason on 7/28/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickItemBlock)(UICollectionView *collectionView,NSIndexPath *indexPath);

typedef NS_ENUM(NSUInteger,JXCollectionViewDataSourceType){
    JXCollectionViewDataSourceTypeUnassigned,// 未赋值
    JXCollectionViewDataSourceTypeSingle,    // 数据源为一维数组
    JXCollectionViewDataSourceTypeMulti,     // 数据源为二维数组
};

typedef NS_ENUM(NSUInteger,JXCollectionViewClassType) {
    JXCollectionViewClassTypeBase,
    JXCollectionViewClassTypeFlexVer,
    JXCollectionViewClassTypeFlexHor,
};

/**
 * 关于UICollectionView的基本介绍
 *  http://www.jianshu.com/p/b0d03c40fd65
 */
@interface JXBaseCollectionView : JXAbstractBaseCollectionView

@property (nonatomic,assign,readonly) JXCollectionViewDataSourceType sourceType;

+ (instancetype)collectionViewWithFrame:(CGRect)frame
                                 layout:(UICollectionViewLayout *)layout
                              classType:(JXCollectionViewClassType)classType
                         clickItemBlock:(ClickItemBlock)click;

@end
