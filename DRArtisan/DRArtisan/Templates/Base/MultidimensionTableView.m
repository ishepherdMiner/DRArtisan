//
//  MultidimensionTableView.m
//  NormalCoder
//
//  Created by Jason on 7/7/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "MultidimensionTableView.h"

@implementation MultidimensionTableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dataList count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    // static int i = 0;
    if (cell == nil) {
        cell = [[[[self cellClass] class] alloc] initWithStyle:self.cellStyle
                                               reuseIdentifier:NSStringFromClass([self class])];
        JasLog(@"cell reuse => %zd",self.reuseCount++);
    }
    
    // Just for avoid reuse affect
    if (cell.owned_table_v == nil) {
        cell.owned_table_v = self;
    }
    
    cell.model = self.dataList[indexPath.section][indexPath.row];
    return cell;
}

- (NSIndexPath *)locWithModel:(id)model {    
    // separate two-dimension array to one dimension array
    for (int i = 0; i < [self.dataList count]; ++i) {
        NSUInteger loc = [self.dataList[i] indexOfObject:model];
        if (loc != NSNotFound) {
            return [NSIndexPath indexPathForRow:loc inSection:(NSInteger)i];
        }
    }
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    if (self.customSetter == false) { return; }
    
    // Need Custom implement setter dataList
    NSMutableArray *dataListM = [NSMutableArray arrayWithCapacity:[dataList count]];
    for (NSArray *subdataList in dataList) {
        NSMutableArray *subdataListM = [NSMutableArray arrayWithCapacity:[subdataList count]];
        for (id subdata in subdataList) {
            if(kFoundationProperty(subdata)){
                [subdataListM addObject:[self packFoundationClass:subdata]];
            }else {
                [subdataListM addObject:subdata];
            }
        }
        [dataListM addObject:[subdataListM copy]];
    }
    _dataList = [dataListM copy];
}


@end
