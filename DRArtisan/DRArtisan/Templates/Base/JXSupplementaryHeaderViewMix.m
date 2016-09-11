//
//  JXSupplementaryHeaderViewMix.m
//  DRArtisan
//
//  Created by Jason on 8/4/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXSupplementaryHeaderViewMix.h"
#import "JXGlobal.h"

@implementation JXSupplementaryHeaderViewMix

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

@end
