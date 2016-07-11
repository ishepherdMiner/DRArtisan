//
//  FlexibleHeightMultiTableView.m
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "FlexibleHeightMultiTableView.h"

@implementation FlexibleHeightMultiTableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // if you want to return height in viewcontroller,please set self.vcDelegate = viewcontroller...
    if(self.vcDelegate){
        if([self.vcDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]){
            return [self.vcDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }
    // NSAssert([self.dataList[indexPath.row] cell_h], @"You should set cell_h at setModel: on table view cell object");
    return [self.dataList[indexPath.section][indexPath.row] cell_h];
}

@end
