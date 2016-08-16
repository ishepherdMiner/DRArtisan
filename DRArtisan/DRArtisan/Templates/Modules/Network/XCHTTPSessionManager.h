//
//  XCHTTPSessionManager.h
//  DRArtisan
//
//  Created by Jason on 8/8/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@protocol XCNetworkEncryptDelegate <NSObject>

@optional

/**
 *  对URL的参数进行加密(要求对参数类型进行判断)
 *
 *  @param plainText 明文
 *
 *  @return 密文
 */
- (NSString *)encryptString:(id)plainText;

/**
 *  对URL的参数解密
 *
 *  @param secureText 密文
 *
 *  @return 明文
 */
- (NSString *)decryptString:(id)secureText;

@end

/**
 *  网络请求框架 - 继承AFHTTPSessionManager
 */
@interface XCHTTPSessionManager : AFHTTPSessionManager

@property (nonatomic,weak) id<XCNetworkEncryptDelegate> delegate;

+ (instancetype)managerWithBaseUrl:(NSString *)baseUrl;

@end
