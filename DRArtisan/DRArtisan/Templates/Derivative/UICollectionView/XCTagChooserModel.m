//
//  XCTagChooserModel.m
//  DRArtisan
//
//  Created by Jason on 8/17/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "XCTagChooserModel.h"

@implementation XCTagChooserModel

- (CGFloat)calculateWidthWithItemHeight:(CGFloat)itemHeight indexPath:(NSIndexPath *)indexPath {
    return arc4random() % 30 + 80;
}

@end
