//
//  JXTagChooserModel.m
//  DRArtisan
//
//  Created by Jason on 8/17/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXTagChooserModel.h"
@interface JXTagChooserModel ()

/// 随机方式在重新绘制宽度在加上文字颜色也是随机会有一定影响
@property (nonatomic,strong) NSArray *randDatas;

@end
@implementation JXTagChooserModel

- (CGFloat)calculateWidthWithItemHeight:(CGFloat)itemHeight indexPath:(NSIndexPath *)indexPath {
    // return arc4random() + (Screen_width - 60) / 4;
    return [[self datas:100][indexPath.row] doubleValue] + (Screen_width - 60) / 4;
}

- (NSArray *)datas:(NSUInteger)count{
    if (_randDatas == nil) {
        NSArray *randTable = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15];
        NSMutableArray *randDatasM = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count; ++i) {
            [randDatasM addObject:randTable[arc4random() % [randTable count]]];
        }
        _randDatas = [randDatasM copy];
    }
    return _randDatas;
}

@end
