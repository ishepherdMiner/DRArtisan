//
//  SupplementaryViewTableView.m
//  DRArtisan
//
//  Created by Jason on 8/3/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "SupplementaryViewTableView.h"

@interface SupplementaryViewTableView ()

@end

@implementation SupplementaryViewTableView

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.cdelegate) {
        if([self.cdelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]){
            return [self.cdelegate tableView:tableView viewForFooterInSection:section];
        }
    }

    // UIView *testView = [[UIView alloc] init];
    // testView.backgroundColor = [UIColor redColor];
    // return testView;
    // 如果需要具体的尾视图最好交给子类或控制器去实现
    AbstractMethodNotImplemented();
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(self.cdelegate) {
        if ([self.cdelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
            return [self.cdelegate tableView:tableView heightForFooterInSection:section];
        }
    }
    
    NSAssert(self.footerHeights, @"Subclass not override this method and not call heightWithSectionHeader:sectionFooter: is not allow");
    
    return [self.footerHeights[section] doubleValue];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.cdelegate) {
        if ([self.cdelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
            return [self.cdelegate tableView:tableView viewForHeaderInSection:section];
        }
    }
    
    // UIView *testView = [[UIView alloc] init];
    // testView.backgroundColor = [UIColor redColor];
    // return testView;
    // 如果需要具体的头视图最好交给子类或控制器去实现
     AbstractMethodNotImplemented();
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.cdelegate) {
        if ([self.cdelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
            return [self.cdelegate tableView:tableView heightForHeaderInSection:section];
        }
    }
    
    NSAssert(self.headerHeights, @"Subclass not override this method and not call heightWithSectionHeader:sectionFooter: is not allow");
    
    return [self.headerHeights[section] doubleValue];
}

@end
