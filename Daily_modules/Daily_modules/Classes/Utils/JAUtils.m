//
//  JAUtils.m
//  Daily_modules
//
//  Created by Jason on 09/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "JAUtils.h"

// 网络相关
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#include <arpa/inet.h>

const NSInteger wifiSent = 0;
const NSInteger wifeReceived = 1;
const NSInteger wwanSent = 2;
const NSInteger wwanReceived = 3;

const CGFloat statusSuccess = 0;

@implementation JAUtils

+ (NSArray *)flowCounters {
    
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    long long WiFiSent = 0;      // wifi网络 上行数据量
    long long WiFiReceived = 0;  // wifi网络 下行数据量
    long long WWANSent = 0;      // wwan网络 上行数据量
    long long WWANReceived = 0;  // wwan网络 下行数据量
    
    NSString *name = @"";
    
    if (getifaddrs(&addrs) == statusSuccess){
        cursor = addrs;
        while (cursor != NULL){
            name = [NSString stringWithFormat:@"%s",cursor->ifa_name];
            // JXLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            if (cursor->ifa_addr->sa_family == AF_LINK){
                // wifi
                if ([name hasPrefix:@"en"]){
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent += networkStatisc->ifi_obytes;
                    WiFiReceived += networkStatisc->ifi_ibytes;
                    
                    // JXLog(@"WiFiSent %lld == %d",WiFiSent,networkStatisc->ifi_obytes);
                    // JXLog(@"WiFiReceived %lld == %d",WiFiReceived,networkStatisc->ifi_ibytes);
                }else if([name hasPrefix:@"pdp_ip"]){
                    // wwan
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent += networkStatisc->ifi_obytes;
                    WWANReceived += networkStatisc->ifi_ibytes;
                    
                    // JXLog(@"WWANSent %lld == %d",WWANSent,networkStatisc->ifi_obytes);
                    // JXLog(@"WWANReceived %lld == %d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    
    NSLog(@"WiFiSent %lld",WiFiSent);
    NSLog(@"WiFiReceived %lld",WiFiReceived);
    NSLog(@"WWANSent %lld",WWANSent);
    NSLog(@"WWANReceived %lld",WWANReceived);
    
    return @[@(WiFiSent), @(WiFiReceived),@(WWANSent),@(WWANReceived)];
}

+ (NSString *)flowUsage:(FlowUsageType)usageType direction:(FlowDirectionOption)directionOption {
    double usage = 0.0;
    if (usageType == FlowUsageTypeWifi) {
        if (directionOption & FlowDirectionOptionUp) {
            usage += [[self unitConversion:[self flowCounters][wifiSent]] doubleValue];
        }
        if (directionOption & FlowDirectionOptionDown) {
            usage += [[self unitConversion:[self flowCounters][wifeReceived]] doubleValue];
        }
    }else {
        if (directionOption & FlowDirectionOptionUp) {
            usage += [[self unitConversion:[self flowCounters][wwanSent]] doubleValue];
        }
        if (directionOption & FlowDirectionOptionDown) {
            usage += [[self unitConversion:[self flowCounters][wwanReceived]] doubleValue];
        }
    }
    return @(usage).stringValue;
}

+ (NSString *)unitConversion:(NSNumber *)flow {
    return @([flow longLongValue] / 1024.0 / 1024.0).stringValue;
}

@end
