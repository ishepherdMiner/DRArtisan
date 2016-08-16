//
//  XCHTTPSessionManager.m
//  DRArtisan
//
//  Created by Jason on 8/8/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "XCHTTPSessionManager.h"

#define kBaseUrl @""
#define kDefaultOutTime 20

@implementation XCHTTPSessionManager

+ (instancetype)managerWithBaseUrl:(NSString *)baseUrl {
    
    XCHTTPSessionManager *instance;
    instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    
    // 设置response格式
    // instance.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // response可接受格式
    instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    // 设置请求超时时间
    instance.session.configuration.timeoutIntervalForResource = kDefaultOutTime;
    
    return instance;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress * _Nonnull))downloadProgress success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    NSString *paramString = nil;
    if ([self.delegate respondsToSelector:@selector(encryptString:)]) {
        // 参数加密
        paramString = [self.delegate encryptString:parameters];
        // 修改URLString参数,生成完整的请求地址
        URLString = [URLString stringByAppendingString:paramString];
    }
    
    return [super GET:URLString parameters:paramString ? nil : parameters progress:downloadProgress success:success failure:failure];
}
@end
