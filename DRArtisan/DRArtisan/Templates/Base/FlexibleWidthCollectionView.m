//
//  FlexibleWIdthCollectionView.m
//  DRArtisan
//
//  Created by Jason on 8/15/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "FlexibleWidthCollectionView.h"

@implementation FlexibleWidthCollectionView

- (CGFloat)collectionView:(UICollectionView *)collectionView waterFlowVerLayout:(WaterFlowHorLayout *)layout widthAtIndexPath:(NSIndexPath *)indexPath {
    return arc4random() % 30 + 80;
}




@end
