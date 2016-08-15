//
//  WaterFlowVerLayout.h
//  DRArtisan
//
//  Created by Jason on 8/8/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  竖直方向上的瀑布流的布局
 *  使用方法
 *
 *  // 1.创建布局
 *  WaterFlowVerLayout *flowLayout = [WaterFlowVerLayout LayoutWithColumnsCount:2 lineSpace:5 interitemSpace:5 sectionInset:UIEdgeInsetsMake(0, 5, 5, 5)];
    
    // 2.创建视图
     BaseCollectionView *collect_v = [BaseCollectionView collectionViewWithFrame:Screen_bounds layout:flowLayout classType:XCCollectionViewClassTypeFlexVer clickItemBlock:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
     
        XcLog(@"%@",@"点击了Cell");
     
     }];
     
     // 3.设置视图代理
     flowLayout.delegate = collect_v;
 
     // 4.注册cell
     [collect_v registerClass:[NewsCollectionCell class]];
     [self.view addSubview:_collect_v = collect_v];
 
     _collect_v.backgroundColor = HexRGB(0xffffff);
 *
 *
 */
@interface WaterFlowVerLayout : UICollectionViewLayout

@property (nonatomic,weak) id<BaseCollectionViewDelegate> delegate;

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
