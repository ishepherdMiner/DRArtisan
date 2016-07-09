//
//  BaseTableViewCell.h
//  NormalCoder
//
//  Created by Jason on 7/7/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell {
    id _model;
}
/// 模型对象
@property (nonatomic,strong,nullable) id model;

@end
