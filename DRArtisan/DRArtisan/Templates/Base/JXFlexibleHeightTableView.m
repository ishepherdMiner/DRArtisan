//
//  JXFlexibleHeightTableView.m
//  DRArtisan
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXFlexibleHeightTableView.h"

#define kDefaultCellHeight 60

@implementation JXFlexibleHeightTableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // if you want to return height in viewcontroller,please set self.cdelegate = viewcontroller...
    if(self.cdelegate){
        if([self.cdelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]){
            return [self.cdelegate tableView:tableView heightForRowAtIndexPath:indexPath];
        }
    }
    
    if (self.sourceType == JXTableViewDataSourceTypeSingle) {
        if ([self.dataList[indexPath.row] calculateHeight] == kZero) {
            return self.rowHeight == kZero ? kDefaultCellHeight : self.rowHeight;
        }
        return [self.dataList[indexPath.row] calculateHeight];
    }else {
        if ([self.dataList[indexPath.section][indexPath.row] calculateHeight] == kZero) {
            return self.rowHeight == kZero ? kDefaultCellHeight : self.rowHeight;
        }
        return [self.dataList[indexPath.section][indexPath.row] calculateHeight];
    }
}
@end
