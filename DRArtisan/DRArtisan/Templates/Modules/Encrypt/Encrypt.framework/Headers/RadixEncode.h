//
//  RadixEncode.h
//  Encrypt
//
//  Created by Jason on 25/12/2015.
//  Copyright © 2015 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Jas_RadixEncode : NSObject
/**
 *  encode string
 *
 *  @param val string to encode
 *
 *  @return result of encode
 */
+ (NSString *) Jas_EncodeCharset: (NSString *)val;

/**
 *  decode
 *
 *  @param val string after encode
 *
 *  @return result of decode
 */
+ (NSString *) Jas_DecodeCharset: (NSString *)val;
@end
