//
//  BaseCollectionCellModel.m
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseCollectionCellModel.h"

@implementation BaseCollectionCellModel

- (CGFloat)pass_h {
    return 40 + arc4random() % 190;
}

- (CGFloat)calculate_h {
    return 40 + arc4random() % 190;
}
@end
