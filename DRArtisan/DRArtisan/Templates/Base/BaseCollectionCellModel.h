//
//  BaseCollectionCellModel.h
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseObject.h"

@interface BaseCollectionCellModel : BaseObject

/// 服务器传递的数据源中已包含高度
@property (nonatomic,assign) CGFloat pass_h;

/// 服务器传递的数据源中不包含高度 - 需要额外计算
@property (nonatomic,assign) CGFloat calculate_h;


/// 简单对象的封装
// ============================================
/// NSString
@property (nonatomic,copy) NSString *b_string;

/// NSNumber
@property (nonatomic,copy) NSNumber *b_number;

// =============================================
@end
