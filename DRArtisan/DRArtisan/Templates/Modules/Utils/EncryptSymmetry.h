//
//  EncryptSymmetry.h
//  DRArtisan
//
//  Created by Jason on 8/16/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXHTTPSessionManager.h"

/**
 *  对称加密方式
 */
@interface EncryptSymmetry : NSObject <XCNetworkEncryptDelegate>

+ (instancetype)builderEncrpyt:(NSUInteger)encryptType;

@end
