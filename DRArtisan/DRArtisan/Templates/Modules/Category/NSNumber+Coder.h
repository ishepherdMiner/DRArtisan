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

@end

@interface NSNumber (Deprecated)

@end
