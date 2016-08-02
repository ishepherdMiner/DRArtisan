//
//  SupplementaryViewTableView.h
//  DRArtisan
//
//  Created by Jason on 8/3/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "FlexibleHeightTableView.h"

@interface SupplementaryViewTableView : FlexibleHeightTableView

- (void)heightWithSectionHeader:(NSArray *)heightHeader sectionFooter:(NSArray *)heightFooter;

@end
