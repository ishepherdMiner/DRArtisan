//
//  NewsModel.m
//  DRArtisan
//
//  Created by Jason on 8/8/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

- (NSDictionary *)mapperProperties {
    return @{@"pass_h":@"image_height"};
}

- (CGFloat)calculateHeightWithItemWidth:(CGFloat)itemWidth indexPath:(NSIndexPath *)indexPath {
    return self.small_height / self.small_width * itemWidth;
}



@end
