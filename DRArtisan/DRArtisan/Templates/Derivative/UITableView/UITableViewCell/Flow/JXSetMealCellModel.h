//
//  JXSetMealCellModel.h
//  Flow
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#define kCommonFonts_1(s) [UIFont fontWithName:@"HelveticaNeue-Light" size:s]
#define kCommonFonts_2(s) [UIFont fontWithName:@"Menlo" size:s]

@interface JXSetMealCellModel : JXBaseObject

/// 问题(周期是多少等...)
@property (nonatomic, copy) NSString *meal_question;

/// 答案
@property (nonatomic,copy) NSString *meal_answer;

@end
