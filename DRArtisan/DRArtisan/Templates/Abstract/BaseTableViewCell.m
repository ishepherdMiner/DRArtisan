//
//  BaseTableViewCell.m
//  NormalCoder
//
//  Created by Jason on 7/7/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    NSAssert(![self isMemberOfClass:[BaseTableViewCell class]], @"BaseTableViewCell is an abstract class, you should not instantiate it directly.");
//    return [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//}

- (void)setModel:(JASBaseCellModel *)model {
    AbstractMethodNotImplemented();
}

@end
