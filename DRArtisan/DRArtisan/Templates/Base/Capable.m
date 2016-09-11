//
//  Capable.m
//  DRArtisan
//
//  Created by Jason on 8/10/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "Capable.h"
#import "JXArtisan.h"

@interface Capable ()

@property (nonatomic,weak) JXBaseCollectionView *collectionView;

@end

@implementation Capable
+ (instancetype)capableWithCollectionView:(JXBaseCollectionView *)collectionView {
    Capable *capable = [[Capable alloc] init];
    capable.collectionView = collectionView;
    return capable;
}

- (void)mobility{
    UILongPressGestureRecognizer *longGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGest:)];
    [_collectionView addGestureRecognizer:longGest];
}

- (void)longGest:(UILongPressGestureRecognizer *)gest
{
    switch (gest.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *touchIndexPath = [_collectionView indexPathForItemAtPoint:[gest locationInView:_collectionView]];
            if (touchIndexPath) {
                [_collectionView beginInteractiveMovementForItemAtIndexPath:touchIndexPath];
            }else{
                break;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [_collectionView updateInteractiveMovementTargetPosition:[gest locationInView:gest.view]];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [_collectionView endInteractiveMovement];
        }
            break;
        default:
            break;
    }
}


@end
