//
//  EncryptSHA256.h
//  Encrypt
//
//  Created by Jason on 25/12/2015.
//  Copyright © 2015 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Jas_EncryptSHA256 : NSObject
/**
 *  Using MD5 to Encrypt sText by secretKey
 *  @param sText Encrypted sText
 */
+ (NSString *)Jas_EncryptSHA256WithText:(NSString *)sText;

/**
 *  Initialize required date for sha256
 *
 *  @param num       appid
 *  @param byteTable byte table
 *
 *  @return string after encrypt
 */
+ (NSString *)Jas_initWithKey:(int)num byteTable:(NSArray *)byteTable;
@end
