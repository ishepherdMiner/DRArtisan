//
//  JXSession.h
//  DRArtisan
//
//  Created by Jason on 7/18/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXBaseObject.h"

typedef NS_ENUM(NSUInteger,SessionState){
    SessionStateStart,
    SessionStateStop
};

@interface JXSession : JXBaseObject

@property (nonatomic,strong) NSDate *startDate;

@property (nonatomic,strong) NSDate *finishDate;

@property (nonatomic,readonly) NSTimeInterval progressTime;

@property (nonatomic,assign) SessionState state;

@end
