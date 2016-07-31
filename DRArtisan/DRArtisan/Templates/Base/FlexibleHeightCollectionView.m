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
 heightForItemAtIndexPath:(NSIndexPath*)indexPath {
    if (self.cdelegate) {
        if([self.cdelegate respondsToSelector:@selector(collectionView:layout:heightForItemAtIndexPath:)]){
            [self.cdelegate collectionView:collectionView layout:layout heightForItemAtIndexPath:indexPath];
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
        if ([self.dataList[indexPath.row] cell_h] == kZero) {
            return kDefaultCollectionCellHeight;
        }
        return [self.dataList[indexPath.row] cell_h];
    }else {
        if ([self.dataList[indexPath.section][indexPath.row] cell_h] == kZero) {
            return kDefaultCollectionCellHeight;
        }
        return [self.dataList[indexPath.section][indexPath.row] cell_h];
    }
}

@end
