//
//  NewsModel.h
//  DRArtisan
//
//  Created by Jason on 8/8/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseObject.h"

/// 摘取网易图片的模型对象
@interface NewsModel : BaseCollectionCellModel

@property (nonatomic,assign) NSUInteger image_height;
@property (nonatomic,assign) NSUInteger image_width;
@property (nonatomic,copy) NSString *image_url;

@end
