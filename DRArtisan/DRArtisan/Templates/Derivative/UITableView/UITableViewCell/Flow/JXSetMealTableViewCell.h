//
//  JXSetMealTableViewCell.h
//  Flow
//
//  Created by Jason on 7/5/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JXBaseTableViewCell.h"

typedef NS_ENUM(NSUInteger,MealCellType){
    MealCellTypeLeft,
    MealCellTypeCenter,
    MealCellTypeRight
};

@interface JXSetMealTableViewCell : JXBaseTableViewCell

@property (nonatomic,assign) MealCellType cell_type;

@property (nonatomic,weak,readonly) UILabel *title_v;

@property (nonatomic,weak,readonly) UITextField *desc_field_v;

@end
