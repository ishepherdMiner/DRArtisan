//
//  FlexibleHeightCollectionView.m
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "FlexibleHeightCollectionView.h"

@implementation FlexibleHeightCollectionView

/**
 *  使用代理对象提供cell的高度
 *
 *  @param collectionView collectionView object
 *  @param layout         layout
 *  @param indexPath      indexPath
 *
 *  @return height in indexPath
 */
- (CGFloat)collectionView:(UICollectionView*)collectionView
                   layout:(WaterfallFlowLayout*)layout
 heightForItemAtIndexPath:(NSIndexPath*)indexPath
                itemWidth:(NSUInteger)itemWidth{
    if (self.cdelegate) {
        if([self.cdelegate respondsToSelector:@selector(collectionView:layout:heightForItemAtIndexPath:itemWidth:)]){
            [self.cdelegate collectionView:collectionView layout:layout heightForItemAtIndexPath:indexPath itemWidth:itemWidth];
        }
    }
    
#if 0
    // 可以使用以下两行代码来查看效果
     CGFloat randomHeight = 80 + (arc4random() % 150);
     return randomHeight;
#endif
    // AbstractMethodNotImplemented();
    if (self.isSingleDimension) {
        // 执行这个先调用cell的内容方法
        if ([self.dataList[indexPath.row] pass_h] == kZero) {
            if ([self.dataList[indexPath.row] calculate_h] != kZero) {
                return [self.dataList[indexPath.row] calculate_h];
            }
            return kDefaultCollectionCellHeight;
        }
        return [self.dataList[indexPath.row] pass_h];
    }else {
        if ([self.dataList[indexPath.section][indexPath.row] pass_h] == kZero) {
            if ([self.dataList[indexPath.row] calculate_h] != kZero) {
                return [self.dataList[indexPath.row] calculate_h];
            }
            return kDefaultCollectionCellHeight;
        }
        return [self.dataList[indexPath.section][indexPath.row] pass_h];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
    cell.contentView.alpha = 0;
    cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0, 0), 0);
        
    [UIView animateKeyframesWithDuration:.5 delay:0.0 options:0 animations:^{
        /**
         *  分步动画   第一个参数是该动画开始的百分比时间  第二个参数是该动画持续的百分比时间
         *  先放大1.2倍,然后缩小到正常大小
         */
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.8 animations:^{
            cell.contentView.alpha = .5;
            cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1.2, 1.2), 0);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
            cell.contentView.alpha = 1;
            cell.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(1, 1), 0);
        }];
        
    } completion:^(BOOL finished) {
        
    }];
}

@end
