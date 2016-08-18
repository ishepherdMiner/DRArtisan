//
//  JXWaterFlowHorLayout.h
//  DRArtisan
//
//  Created by Jason on 8/13/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 布局的优先级策略 - 需要改进
typedef NS_ENUM(NSUInteger,JXLayoutTactics){
    JXLayoutTacticsDefault, // 优先保证宽度 - 看上去不太好
    JXLayoutTacticsColumns, // 优先保证列数
};
/**
 *  标签选择器的布局
 */
@interface JXWaterFlowHorLayout : JXBaseCollectionViewFlowLayout

@property (nonatomic,weak) id<JXBaseCollectionViewDelegate> delegate;

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

/**
 *  初始化方法
 *
 *  @param columnsCount   列数
 *  @param lineSpace      行间距
 *  @param interitemSpace item的间距
 *  @param sectionInset   行内间距
 *  @param layoutTactics  布局策略
 *
 *  @return BaseCollectionViweFlowLayout object
 */
+ (instancetype)LayoutWithColumnsCount:(NSUInteger)columnsCount
                             lineSpace:(CGFloat)lineSpace
                        interitemSpace:(CGFloat)interitemSpace
                          sectionInset:(UIEdgeInsets)sectionInset
                         layoutTactics:(JXLayoutTactics)layoutTactics;
@end
