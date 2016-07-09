//
//  MultidimensionTableView.m
//  NormalCoder
//
//  Created by Jason on 7/7/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "MultidimensionTableView.h"

@implementation MultidimensionTableView

- (NSInteger)numberOfSections {
    return [self.dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    static int i = 0;
    if (cell == nil) {
        cell = [[[[self cellClass] class] alloc] initWithStyle:self.cellStyle
                                               reuseIdentifier:NSStringFromClass([self class])];
        JasLog(@"cell reuse => %d",i++);
    }
    
    cell.model = self.dataList[indexPath.section][indexPath.row];
    return cell;
}

@end
