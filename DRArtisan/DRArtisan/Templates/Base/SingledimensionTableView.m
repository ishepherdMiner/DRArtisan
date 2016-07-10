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
    
    cell.model = self.dataList[indexPath.row];
    return cell;
}


@end
