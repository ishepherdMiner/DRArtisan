//
//  NSDictionary+JACoder.h
//  Daily_modules
//
//  Created by Jason on 09/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JACoder)
/**
 *  分割URL,得到参数字典
 *
 *  @return url的参数字典
 */
- (NSDictionary *)splitUrlQuery:(NSURL *)url;
@end
