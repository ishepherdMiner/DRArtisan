//
//  JASUtils.m
//  DRArtisan
//
//  Created by Jason on 7/17/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JASUtils.h"

// 网络相关
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#include <arpa/inet.h>

#define kWiFiSent     kZero
#define kWiFiReceived kOne
#define kWWANSent     kTwo
#define kWWANReceived kThree


@implementation JASUtils
+ (void)logViewRecursive:(UIView *)view {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

    JasLog(@"%@",[view performSelector:@selector(recursiveDescription)]);
    
#pragma clang diagnostic pop
}

+ (void)logViewCtrlRecursive:(UIViewController *)vc {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    JasLog(@"%@",[vc performSelector:@selector(_printHierarchy)]);
    
#pragma clang diagnostic pop
}
@end

@implementation JASUtils (Network)

+ (NSArray *)dataCounters {

    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    long long WiFiSent = 0;      // wifi网络 上行数据量
    long long WiFiReceived = 0;  // wifi网络 下行数据量
    long long WWANSent = 0;      // wwan网络 上行数据量
    long long WWANReceived = 0;  // wwan网络 下行数据量
    
    NSString *name = @"";
    
    if (getifaddrs(&addrs) == kStatusSuccess){
        cursor = addrs;
        while (cursor != NULL){
            name = [NSString stringWithFormat:@"%s",cursor->ifa_name];
            // JasLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            if (cursor->ifa_addr->sa_family == AF_LINK){
                // wifi
                if ([name hasPrefix:@"en"]){
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent += networkStatisc->ifi_obytes;
                    WiFiReceived += networkStatisc->ifi_ibytes;
                    
                    // JasLog(@"WiFiSent %lld == %d",WiFiSent,networkStatisc->ifi_obytes);
                    // JasLog(@"WiFiReceived %lld == %d",WiFiReceived,networkStatisc->ifi_ibytes);
                }else if([name hasPrefix:@"pdp_ip"]){
                    // wwan
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent += networkStatisc->ifi_obytes;
                    WWANReceived += networkStatisc->ifi_ibytes;
                    
                    // JasLog(@"WWANSent %lld == %d",WWANSent,networkStatisc->ifi_obytes);
                    // JasLog(@"WWANReceived %lld == %d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    
    JasLog(@"WiFiSent %lld",WiFiSent);
    JasLog(@"WiFiReceived %lld",WiFiReceived);
    JasLog(@"WWANSent %lld",WWANSent);
    JasLog(@"WWANReceived %lld",WWANReceived);
    
    return @[@(WiFiSent), @(WiFiReceived),@(WWANSent),@(WWANReceived)];
}

+ (NSString *)flowUsage:(FlowUsageType)usageType direction:(FlowDirectionOption)directionOption {
    double usage = 0.0;
    if (usageType == FlowUsageTypeWifi) {
        if (directionOption & FlowDirectionOptionUp) {
            usage += [[self unitConversion:[self dataCounters][kWiFiSent]] doubleValue];
        }
        if (directionOption & FlowDirectionOptionDown) {
            usage += [[self unitConversion:[self dataCounters][kWiFiReceived]] doubleValue];
        }
    }else {
        if (directionOption & FlowDirectionOptionUp) {
           usage += [[self unitConversion:[self dataCounters][kWWANSent]] doubleValue];
        }
        if (directionOption & FlowDirectionOptionDown) {
           usage += [[self unitConversion:[self dataCounters][kWWANReceived]] doubleValue];
        }
    }
    return @(usage).stringValue;
}

+ (NSString *)unitConversion:(NSNumber *)flow {
    return @([flow longLongValue] / kMoreMagnitude / kMoreMagnitude).stringValue;
}

@end