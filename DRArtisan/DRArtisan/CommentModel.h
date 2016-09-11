//
//  CommentModel.h
//  DRArtisan
//
//  Created by Jason on 7/9/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXArtisan.h"

@interface CommentModel : JXBaseObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *topic_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *reply_num;
@property (nonatomic, copy) NSString *create_date;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@end
