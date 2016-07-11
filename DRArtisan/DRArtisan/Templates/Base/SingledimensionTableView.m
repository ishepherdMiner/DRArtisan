//
//  SingledimensionTableView.m
//  NormalCoder
//
//  Created by Jason on 7/7/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "SingledimensionTableView.h"

@implementation SingledimensionTableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    static int i = 0;
    if (cell == nil) {
        cell = [[[[self cellClass] class] alloc] initWithStyle:self.cellStyle
                                               reuseIdentifier:NSStringFromClass([self class])];
        JasLog(@"cell reuse => %d",i++);
    }
    
    // Just for avoid reuse affect
    if (cell.owned_table_v == nil) {
        cell.owned_table_v = self;
    }
    
    cell.model = self.dataList[indexPath.row];
    return cell;
}

- (NSIndexPath *)locWithModel:(id)model {
    NSUInteger loc = [self.dataList indexOfObject:model];
    if(loc != NSNotFound) {
        return [NSIndexPath indexPathForRow:loc inSection:0];
    }
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    if (self.customSetter == false) { return; }
    
    // Need Custom implement setter dataList
    NSMutableArray *dataListM = [NSMutableArray arrayWithCapacity:[dataList count]];
    for (id data in dataList) {
        if(kFoundationProperty(data)){
            [dataListM addObject:[self packFoundationClass:data]];
        }else {
            [dataListM addObject:data];
        }
    }
    _dataList = [dataListM copy];
}
@end
