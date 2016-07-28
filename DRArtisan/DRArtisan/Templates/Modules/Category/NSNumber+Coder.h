//
//  NSNumber+Coder.h
//  DRArtisan
//
//  Created by Jason on 7/25/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Coder)

/**
 *  create a random number between from with to number => [from,to]
 *
 *  @param from min number
 *  @param to   max number
 *
 *  @return a random number between from with to number
 */
+ (instancetype)randomNumber:(NSUInteger)from to:(NSUInteger)to;

/**
 *  create a random timestamp between from with to number (unit:second)
 *
 *  @param from before now timestamp `from` seconds
 *  @param to   after now timestamp `to` seconds
 *
 *  @return a random timestamp from with to number
 */
+ (instancetype)randomTimestamp:(NSUInteger)from to:(NSUInteger)to;

@end

@interface NSNumber (Deprecated)

@end
