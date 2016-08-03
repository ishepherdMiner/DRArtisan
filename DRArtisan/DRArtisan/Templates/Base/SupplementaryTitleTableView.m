//
//  SupplementaryTitleTableView.m
//  DRArtisan
//
//  Created by Jason on 8/3/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "SupplementaryTitleTableView.h"

@interface SupplementaryTitleTableView ()

@end

@implementation SupplementaryTitleTableView


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self.cdelegate) {
        if ([self.cdelegate respondsToSelector:@selector(tableView:titleForFooterInSection:)]) {
            return [self.cdelegate tableView:tableView titleForFooterInSection:section];
        }
    }
    if (self.footerTitles == nil) {return  nil;}
    
    // 只提供简单的设置每组尾视图的标题的方法,更复杂的设置条件可以继承并自行实现该方法
    return self.footerTitles[section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.cdelegate) {
        if([self.cdelegate respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
            return [self.cdelegate tableView:tableView titleForHeaderInSection:section];
        }
    }
    
    if (self.headerTitles == nil) {return nil;}

    // 只提供简单的设置每组头视图的标题的方法,更复杂的设置条件可以继承并自行实现该方法
    return self.headerTitles[section];
}

@end
