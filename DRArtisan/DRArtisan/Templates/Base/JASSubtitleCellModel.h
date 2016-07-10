//
//  SubtitleCellModel.h
//  DRArtisan
//
//  Created by Jason on 7/9/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JASBaseCellModel.h"

@interface JASSubtitleCellModel : JASBaseCellModel

/// cell的标识id
@property (nonatomic,copy) NSString *title_id;

/// cell的title
@property (nonatomic,copy) NSString *title;

/// cell的blue title
@property (nonatomic,copy) NSString *blue_title;

/// cell的icon
@property (nonatomic,copy) NSString *icon;

@end
