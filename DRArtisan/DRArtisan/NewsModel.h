//
//  NewsModel.h
//  DRArtisan
//
//  Created by Jason on 8/8/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXBaseObject.h"

/// 摘取网易图片的模型对象
@interface NewsModel : JXBaseObject

@property (nonatomic,assign) NSUInteger image_height;
@property (nonatomic,assign) NSUInteger image_width;

@property (nonatomic, assign) CGFloat small_width;
@property (nonatomic, assign) CGFloat small_height;
@property (nonatomic, copy) NSString *small_url;
@property (nonatomic, copy) NSString *title;

@property (nonatomic , copy) NSString *image_url;

@end
