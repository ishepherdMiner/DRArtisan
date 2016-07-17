//
//  EncryptAssemblage.h
//  Encrypt
//
//  Created by Jason on 12/31/15.
//  Copyright © 2015 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,AlgorithmType){
    AlgorithmTypeDES = 0,
    AlgorithmType3DES,
    AlgorithmTypeAES
};

@interface Jas_EncryptAssemblage : NSObject

/**
 *  According to assign algorithm to encrypt plain text
 *
 *  @param algorithmType algorithm type
 *  @param encryptKey    a key to encrypt
 *  @param plainText     a string to encrypt
 *
 *  @return a string which is result of encrypt
 */
 + (NSString *)Jas_EncryptAlgorithm:(AlgorithmType) algorithmType
                             encryptKey:(NSString *) sKey
                         withPlainText:(NSString *) plainText;

/**
 *  Decrypt text which is encrypt by assign algorithm
 *
 *  @param algorithmType algorithm type
 *  @param decryptKey    a key to decrypt
 *  @param encryptText   a string to decrypt
 *
 *  @return a string which is result of decrypt
 */
 + (NSString *)Jas_DecryptAlgorithm:(AlgorithmType) algorithmType
                            decryptKey:(NSString *) sKey
                       withEncryptText:(NSString *) encryptText;
@end
