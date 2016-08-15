//
//  WaterFlowHorLayout.h
//  DRArtisan
//
//  Created by Jason on 8/13/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  标签选择器的布局
 */
@interface WaterFlowHorLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id<BaseCollectionViewDelegate> delegate;

/// 固定行高
@property(nonatomic,assign)CGFloat rowHeight;

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
