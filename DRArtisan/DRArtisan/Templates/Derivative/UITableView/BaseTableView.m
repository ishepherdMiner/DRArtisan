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
        if (kFoundationProperty(dataList.firstObject)) {
            obj.customSetter = true;
        }
        
        if([self isSubclassOfClass:[MultidimensionTableView class]]){
            if (kFoundationProperty([dataList.firstObject firstObject])) {
                obj.customSetter = true;
            }
        }
        
        obj.dataList = dataList;
        return obj;
    }
    
    // if dataList first object is NSArray
    BaseTableView *base_table_v = [dataList.firstObject isKindOfClass:[NSArray class]] ?
        [[MultidimensionTableView alloc] initWithFrame:frame style:style] :
        [[SingledimensionTableView alloc] initWithFrame:frame style:style];
    base_table_v.customSetter = true;
    base_table_v.dataList = dataList;
    return base_table_v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // if you want to return height in viewcontroller,please set self.vcDelegate = viewcontroller...
    if(self.vcDelegate){
        if([self.vcDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            return [self.vcDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}



@end
