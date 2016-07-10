//
//  Value1CellModel.h
//  DRArtisan
//
//  Created by Jason on 7/9/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JASBaseCellModel.h"

@interface JASValue1CellModel : JASBaseCellModel

/// cell的标识id
@property (nonatomic,copy) NSString *title_id;

/// cell的title
@property (nonatomic,copy) NSString *title;

/// cell的blue title
@property (nonatomic,copy) NSString *blue_title;

@end
