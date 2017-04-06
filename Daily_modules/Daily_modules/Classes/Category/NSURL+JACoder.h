//
//  NSURL+JACoder.h
//  Daily_modules
//
//  Created by Jason on 06/04/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (JACoder)

/**
 *  分割URL,得到参数字典
 *
 *  @return url的参数字典
 */
- (NSDictionary *)ja_splitUrlQuery;

@end
