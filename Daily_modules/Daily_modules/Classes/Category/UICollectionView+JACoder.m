//
//  UICollectionView+JACoder.m
//  RssMoney
//
//  Created by Jason on 28/04/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "UICollectionView+JACoder.h"
#import "JACategory.h"

@implementation UICollectionView (JACoder)

- (void)animateCollectionCellsWithDirection:(NSTimeInterval)duration completion:(void (^)())completion {
    for (int i = 0; i < self.visibleCells.count; ++i) {
        [self.visibleCells[i] ja_swingAnimation:duration direction:JASwingDirectionAround];
    }
}
@end
