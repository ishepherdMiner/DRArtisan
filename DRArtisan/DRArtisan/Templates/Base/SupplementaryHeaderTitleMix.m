//
//  SupplementaryHeaderTitleMix.m
//  DRArtisan
//
//  Created by Jason on 8/4/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "SupplementaryHeaderTitleMix.h"

@implementation SupplementaryHeaderTitleMix

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

@end
