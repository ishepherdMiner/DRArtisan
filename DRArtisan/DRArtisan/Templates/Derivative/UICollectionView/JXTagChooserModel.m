//
//  JXTagChooserModel.m
//  DRArtisan
//
//  Created by Jason on 8/17/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXTagChooserModel.h"

@implementation JXTagChooserModel

- (CGFloat)calculateWidthWithItemHeight:(CGFloat)itemHeight indexPath:(NSIndexPath *)indexPath {
    // 随机策略
    return (Screen_width - 60) / 4;
}

@end
