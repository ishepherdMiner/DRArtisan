//
//  DefaultCellModel.h
//  DRArtisan
//
//  Created by Jason on 7/9/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseObject.h"

/**
 *  默认类型的cell模型对象
 */
@interface JASDefaultCellModel : BaseObject

/// cell的标识id
@property (nonatomic,copy) NSString *title_id;

/// cell的title
@property (nonatomic,copy) NSString *title;

/// cell的图片地址
@property (nonatomic,copy) NSString *icon;

@end
