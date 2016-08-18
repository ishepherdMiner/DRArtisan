//
//  SetMealCellModel.h
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

@interface SetMealCellModel : JXBaseObject

/// 标题(周期是多少等...)
@property (nonatomic, copy) NSString *meal_question;

/// 对应的内容
@property (nonatomic,copy) NSString *meal_answer;

@end
