//
//  DefaultCellModel.m
//  DRArtisan
//
//  Created by Jason on 7/9/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JASDefaultCellModel.h"

@implementation JASDefaultCellModel

- (NSDictionary *)mapperProperties {
    return @{
             @"title_id":@"id",
             @"title":@"title",
             @"icon":@"icon"
           };
}

@end
