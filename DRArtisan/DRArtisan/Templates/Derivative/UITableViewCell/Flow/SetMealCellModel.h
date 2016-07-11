//
//  SetMealCellModel.h
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "JASBaseCellModel.h"

@interface SetMealCellModel : JASBaseCellModel

/// 标题(周期是多少等...)
@property (nonatomic, copy) NSString *meal_title;

/// 对应的内容
@property (nonatomic,copy) NSString *meal_desc;

@end
