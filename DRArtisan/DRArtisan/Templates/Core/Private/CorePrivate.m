//
//  CorePrivate.m
//  NormalCoder
//
//  Created by Jason on 7/6/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "CorePrivate.h"
#import <objc/message.h>

@implementation CorePrivate

#if kCoder_Ext

/**
 *  ip地址
 */
+ (void)jas_ipAddresses {
    id cls = NSClassFromString(@"NSHost");
    id obj = [cls valueForKey:@"currentHost"];
    JasLog(@"%@",[obj performSelector:@selector(addresses)]);
}

/**
 * 加载框架
 */
+ (BOOL)jas_loadFramework {
    NSBundle *b = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/FTServices.framework"];
    return [b load];
}

/**
 * 是否插入了sim卡
 */
+ (BOOL)jas_hasInsertedSim {
    if ([self jas_loadFramework]) {
        Class cls = NSClassFromString(@"FTDeviceSupport");
        id obj = [cls valueForKey:@"sharedInstance"];
        NSDictionary *networkInfo = [obj valueForKey:@"CTNetworkInformation"];
        if (networkInfo == nil || networkInfo.count == 0) {
            // 电信:"sim-mnc" = 03;
            // 联通:"sim-mnc" = 01;
            // 移动:"sim-mnc" = 04;
            JasLog(@"hasInsertedSim => %d",false);
            return false;
        }
        JasLog(@"hasInsertedSim => %d",true);
        return true;
    }
    JasLog(@"hasInsertedSim => %d",false);
    return false;
}

/**
 * E3520B39-64C8-4A5A-9316-5B10B71FCFE7
 */
+ (NSString *)jas_prefrenceUUIDString {
    id obj = NSClassFromString(@"LSBundleProxy");
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    id obj1 = [obj performSelector:NSSelectorFromString(@"bundleProxyForIdentifier:") withObject:@"com.apple.Preferences"];
    id obj2 = [obj1 performSelector:NSSelectorFromString(@"cacheGUID")];
    NSString *uuid = [obj2 performSelector:NSSelectorFromString(@"UUIDString")];
    
#pragma clang diagnostic pop
    
    JasLog(@"uuid => %@",uuid);
    return uuid;
}

+ (BOOL)jas_hasInstalled:(NSString *) bundleId {
    id cls = NSClassFromString(@"LSApplicationProxy");
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    id obj = [cls performSelector:NSSelectorFromString(@"applicationProxyForIdentifier:") withObject:bundleId];
    if (!obj)  return false;
    BOOL installed = (BOOL)[obj performSelector:NSSelectorFromString(@"isInstalled")];
    
#pragma clang diagnostic pop
    
    JasLog(@"bundleId => %@ installed => %d",bundleId,installed);
    
    return installed;
}

+ (NSArray *)jas_allInstalledApps {
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_6_0) {
        return [NSArray array];
    }
    
    NSMutableArray *list = [NSMutableArray array];
    
    Class cls = objc_getClass([@"LSApplicationWorkspace" cStringUsingEncoding:NSUTF8StringEncoding]);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    NSObject* workspace = [cls performSelector:NSSelectorFromString(@"defaultWorkspace")];
    
    id apps = NULL;
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
        apps = [workspace performSelector:NSSelectorFromString(@"allInstalledApplications")];
    else
        apps = [[workspace performSelector:NSSelectorFromString(@"installedApplications")] allKeys];
    
    for (id app in apps) {
        id bid = NULL;
        
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
            bid = [app performSelector:NSSelectorFromString(@"applicationIdentifier")];
        else
            bid = app;
        
        if (bid && ![bid hasPrefix:@"com.apple."]) {
            [list addObject:bid];
        }
    }
    
#pragma clang diagnostic pop
    
    JasLog(@"%@\nTotalNo.%ld",list,(unsigned long)[list count]);
    
    return list;
}

+ (BOOL)jas_hasRedownload:(NSString *) bundleId {
    NSBundle *b = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/ToneLibrary.framework"];
    // JasLog(@"%d",[b load]);
    [b load];
    
    bool isimaged = false;
    NSDictionary *itdic;
    NSFileManager*fileManager =[NSFileManager defaultManager];
    // 针对越狱的
    NSString*resourcePath = @"/private/var/mobile/Library/Caches/com.apple.mobile.installation.plist";
    if ([fileManager fileExistsAtPath:resourcePath]) {
        
        NSMutableDictionary *rootArray = [NSMutableDictionary dictionaryWithContentsOfFile:resourcePath ];
        NSDictionary *installdic=[rootArray objectForKey:@"User"];
        NSDictionary *dic=[installdic objectForKey:bundleId];
        NSString *path=[dic objectForKey:@"Container"];
        NSString *mypath=[NSString stringWithFormat:@"%@/iTunesMetadata.plist",path];
        itdic = [NSDictionary dictionaryWithContentsOfFile:mypath ];
        isimaged=[[itdic objectForKey:@"is-purchased-redownload"]boolValue];
        
    }else{
        
        float version= [[[UIDevice currentDevice] systemVersion] floatValue];
        NSString *versionstr=[NSString stringWithFormat:@"%.0f",version];
        
        if ([versionstr floatValue] >= 8.0f) {
            id applicationProxy = NSClassFromString(@"LSApplicationProxy");
            if(applicationProxy == nil) return false;
            
            SEL applicationProxyForIdentifier = NSSelectorFromString(@"applicationProxyForIdentifier:");
            if(![applicationProxy respondsToSelector:applicationProxyForIdentifier]) return false;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            id pro = [applicationProxy performSelector:applicationProxyForIdentifier withObject:bundleId];
#pragma clang diagnostic pop
            if(pro == nil) return false;
            
            SEL isPurchasedReDownload = NSSelectorFromString(@"isPurchasedReDownload");
            if(![pro respondsToSelector:isPurchasedReDownload]) return false;
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            isimaged = [pro performSelector:isPurchasedReDownload];
            
#pragma clang diagnostic pop
            
        }else{
            // *** 7.0系统
        }
        
    }
    
    JasLog(@"bundleId => %@ \t redownload => %d",bundleId,isimaged);
    return isimaged;
}

+ (NSString *)jas_installTime:(NSString *) bundleId {
    // 先确定是否安装该应用
    if (![self jas_hasInstalled:bundleId])  return @"";
    
    id proxy = NSClassFromString(@"LSApplicationProxy");
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id obj = [proxy performSelector:NSSelectorFromString(@"applicationProxyForIdentifier:") withObject:bundleId];
    NSString *timerString = [obj performSelector:NSSelectorFromString(@"storeCohortMetadata")];
#pragma clang diagnostic pop
    
    if (timerString && timerString.length > 20) {
        timerString = [timerString substringToIndex:17];
        timerString = [timerString substringFromIndex:7];
        JasLog(@"installed time => %@",timerString);
        return timerString;
    }
    return @"";
}


#endif

+ (BOOL)jas_openAppWithBundleId:(NSString *)bundleId {
    BOOL execResult = false;
    if([self jas_hasInstalled:bundleId]) {
        id applicationWorker = NSClassFromString(@"LSApplicationWorkspace");
        if (applicationWorker) {
            id defaultWorkSpace = nil;
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            
            SEL workSpaceSel = NSSelectorFromString(@"defaultWorkspace");
            if ([applicationWorker respondsToSelector:workSpaceSel]) {
                defaultWorkSpace = [applicationWorker performSelector:workSpaceSel];
            }
            
            SEL openApp = NSSelectorFromString(@"openApplicationWithBundleID:");
            if ([defaultWorkSpace respondsToSelector:openApp]) {
               execResult = [defaultWorkSpace performSelector:openApp withObject:bundleId];
            }
#pragma clang diagnostic pop
        }
    }
    JasLog(@"execResult => %d",execResult);
    return execResult;
}

@end
