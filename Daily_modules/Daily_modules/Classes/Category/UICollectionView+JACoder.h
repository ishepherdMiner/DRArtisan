//
//  UICollectionView+JACoder.h
//  RssMoney
//
//  Created by Jason on 28/04/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (JACoder)

- (void)animateCollectionCellsWithDirection:(NSTimeInterval)duration completion:(void (^)())completion;
@end
