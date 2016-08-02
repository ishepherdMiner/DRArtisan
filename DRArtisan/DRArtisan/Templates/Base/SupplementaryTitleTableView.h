//
//  SupplementaryTitleTableView.h
//  DRArtisan
//
//  Created by Jason on 8/3/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "FlexibleHeightTableView.h"

/**
 *  提供自定义每一组的头视图与尾视图的文案内容
 */
@interface SupplementaryTitleTableView : FlexibleHeightTableView

- (void)titleWithSectionHeader:(NSArray *)headerTitles sectionFooter:(NSArray *)footerTitles;

@end
