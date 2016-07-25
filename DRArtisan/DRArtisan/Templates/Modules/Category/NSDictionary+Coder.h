//
//  NSDictionary+Coder.h
//  JoySummer
//
//  Created by ishpherdme on 24/4/15.
//  Copyright (c) 2015 WDL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Coder)

/**
 *  分割URL,得到参数字典
 *
 *  @return url的参数字典
 */
- (NSDictionary *)splitUrlQuery:(NSURL *)url;

@end

@interface NSDictionary (CleanDescription)

- (NSString *)cleanDescription;

@end

@interface NSDictionary (Deprecated)

@end