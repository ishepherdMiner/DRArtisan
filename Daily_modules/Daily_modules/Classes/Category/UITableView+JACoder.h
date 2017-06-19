//
//  UITableView+JACoder.h
//  RssMoney
//
//  Created by Jason on 27/04/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (JACoder)

- (void)animateTableCellsWithDirection:(NSTimeInterval)duration completion:(void (^)())completion;

@end
