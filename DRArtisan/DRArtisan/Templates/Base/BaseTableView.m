//
//  BaseTableView.m
//  DRArtisan
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                        dataList:(NSArray *)dataList{
    
    NSAssert([dataList isKindOfClass:[NSArray class]], @"dataSource param must be an array class");
    
    // if self is subclass of BaseTableView
    if([self isSubclassOfClass:[MultidimensionTableView class]] || [self isSubclassOfClass:[SingledimensionTableView class]]) {
        BaseTableView *obj = [[self alloc] initWithFrame:frame style:style];
        obj.dataList = dataList;
        return obj;
    }
    
    // if dataList first object is NSArray
    BaseTableView *base_table_v = [dataList.firstObject isKindOfClass:[NSArray class]] ?
        [[MultidimensionTableView alloc] initWithFrame:frame style:style] :
        [[SingledimensionTableView alloc] initWithFrame:frame style:style];
    base_table_v.dataList = dataList;
    return base_table_v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView cellForRowAtIndexPath:indexPath];
}



@end
