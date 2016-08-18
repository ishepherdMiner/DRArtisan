//
//  DefaultCellModel.m
//  DRArtisan
//
//  Created by Jason on 7/9/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXDefaultCellModel.h"

@implementation JXDefaultCellModel

- (NSDictionary *)mapper {
    return @{
             @"title_id":@"id",
             @"title":@"title",
             @"icon":@"icon"
           };
}

@end
