//
//  JXFlexibleWidthCollectionView.m
//  DRArtisan
//
//  Created by Jason on 8/15/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXFlexibleWidthCollectionView.h"

@implementation JXFlexibleWidthCollectionView

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JXWaterFlowHorLayout *)layout widthForItemAtIndexPath:(NSIndexPath *)indexPath itemHeight:(CGFloat)itemHeight {
    if ([self.cdelegate respondsToSelector:@selector(collectionView:layout:widthForItemAtIndexPath:itemHeight:)]) {
        [self.cdelegate collectionView:collectionView layout:layout widthForItemAtIndexPath:indexPath itemHeight:itemHeight];
    }
    
    if (self.sourceType == JXCollectionViewDataSourceTypeSingle) {
        return [self.dataList[indexPath.row] calculateWidthWithItemHeight:itemHeight indexPath:indexPath];        
    }else {
        return [self.dataList[indexPath.section][indexPath.row] calculateWidthWithItemHeight:itemHeight indexPath:indexPath];
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y > 0) {
//        [self reloadData];
//    }
//}

@end
