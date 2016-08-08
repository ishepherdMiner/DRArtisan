//
//  XCHTTPSessionManager.h
//  DRArtisan
//
//  Created by Jason on 8/8/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@protocol XCHTTPSessionManagerDelegate <NSObject>

@optional

// URL参数的加密方法 - 比如DES,RSA等
- (NSString *)encryptUrlParams:(id)params;

@end

/**
 *  网络请求框架 - 采用继承AFHTTPSessionManager
 */
@interface XCHTTPSessionManager : AFHTTPSessionManager <XCHTTPSessionManagerDelegate>

@end
