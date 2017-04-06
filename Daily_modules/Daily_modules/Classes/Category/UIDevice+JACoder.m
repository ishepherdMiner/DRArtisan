//
//  UIDevice+JACoder.m
//  Daily_modules
//
//  Created by Jason on 14/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "UIDevice+JACoder.h"
#import <objc/message.h>
#import <CoreMotion/CoreMotion.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

const char *gyroKey = "gyroKey";

@implementation UIDevice (JACoder)

+ (instancetype)sharedDevice {
    static id instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

#if DEBUG
+ (void)ja_gyroWithStartBlock:(void (^)(CMGyroData *gyroData,NSError *error))handler {
    
    CMMotionManager *manager = nil;
    if (objc_getAssociatedObject([self sharedDevice], gyroKey)) {
        manager = objc_getAssociatedObject([self sharedDevice], gyroKey);
    }else {
        // 初始化全局管理对象
        manager = [[CMMotionManager alloc] init];
        objc_setAssociatedObject([self sharedDevice], gyroKey, manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    NSMutableArray *rs = [NSMutableArray array];
    if (manager.deviceMotionAvailable) {
        [rs addObjectsFromArray:@[@(manager.gyroData.rotationRate.x),@(manager.gyroData.rotationRate.y),@(manager.gyroData.rotationRate.z)]];
    }
    
    // 判断陀螺仪可不可以，判断陀螺仪是不是开启
    if ([manager isGyroAvailable]){
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        manager.gyroUpdateInterval = 0.5;
        
        // Push方式获取和处理数据
        [manager startGyroUpdatesToQueue:queue
                             withHandler:^(CMGyroData *gyroData, NSError *error)
         {
             handler(gyroData,error);
         }];
    }
}

#endif

- (NSString *)ja_ipAddr:(BOOL)preferIPv4{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self ja_ipAddr];
    // NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

- (NSDictionary *)ja_ipAddr{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
@end
