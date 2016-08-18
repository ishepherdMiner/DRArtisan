//
//  Value2CellModel.h
//  DRArtisan
//
//  Created by Jason on 7/9/16.
//  Copyright © 2016 DR. All rights reserved.
//

@interface JXValue2CellModel : JXBaseObject

/// cell的标识id
@property (nonatomic,copy) NSString *title_id;

/// cell的title
@property (nonatomic,copy) NSString *title;

/// cell的blue title
@property (nonatomic,copy) NSString *blue_title;

@end
