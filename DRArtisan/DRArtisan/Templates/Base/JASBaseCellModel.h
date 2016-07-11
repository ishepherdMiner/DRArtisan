//
//  JASBaseCellModel.h
//  DRArtisan
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseObject.h"

@interface JASBaseCellModel : BaseObject

/**
 *  UITableViewCell的高度
 */
@property (nonatomic,assign) CGFloat cell_h;

/// 简单对象的封装
// ============================================
/// NSString
@property (nonatomic,copy) NSString *b_string;

/// NSNumber
@property (nonatomic,copy) NSNumber *b_number;

// =============================================

@end