//
//  UITableView+JACoder.m
//  RssMoney
//
//  Created by Jason on 27/04/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "UITableView+JACoder.h"
#import "JACategory.h"

@implementation UITableView (JACoder)
- (void)animateTableCellsWithDirection:(NSTimeInterval)duration completion:(void (^)())completion{
    for (int i = 0; i < self.visibleCells.count; ++i) {
        CGFloat delay = duration / self.visibleCells.count * i;
        CGFloat damping = 0.85;
        
        CGAffineTransform cellTransform = CGAffineTransformMakeTranslation(self.visibleCells[i].w,0);
        
        [self.visibleCells[i].layer setAffineTransform:cellTransform];
        
        [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:damping initialSpringVelocity:0.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
            [self.visibleCells[i].layer setAffineTransform:CGAffineTransformIdentity];
            
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    }
}
@end
