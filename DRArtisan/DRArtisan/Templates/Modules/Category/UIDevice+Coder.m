//
//  UIDevice+Coder.m
//  DeviceInfoDemo
//
//  Created by jason on 4/3/16.
//  Copyright © 2016 jason. All rights reserved.
//

#import "UIDevice+Coder.h"

#import <mach/mach.h>  // CPU使用率
#import <sys/sysctl.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <sys/mount.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <objc/message.h>


// #import <mach/processor_info.h>
// #include <sys/socket.h> // Per msqr
// #include <sys/sysctl.h>
// #include <net/if.h>
// #include <net/if_dl.h>
// #import <mach/mach_host.h>
// #import <sys/types.h>
// #import <sys/param.h>
// #import <sys/stat.h>

@implementation UIDevice (Coder)

- (void) jas_logInfo {
    JasLog(@"%f",[self jas_cpuUsage]);
    [self jas_cpuType];
    
    [self jas_wifi];
    JasLog(@"%tu",[self jas_availableMemory]);
    JasLog(@"%f",[self freeMemoryBytes] / 1024.0 / 1024.0);
    
    JasLog(@"%fG",[self jas_totalMemory] / 1024.0 / 1024.0 / 1024.0);
    JasLog(@"%fM",[self jas_freeDiskSpace] / 1024.0 / 1024.0);
    JasLog(@"%fM",[self jas_totalDiskSpace] / 1024.0 / 1024.0);
    [self jas_hardDisk];
    [self jas_sersor];
}

- (void) jas_sersor {
    // 方向感应器
    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
    if([motionManager isAccelerometerAvailable]){
        JasLog(@"加速感应器");
    }
    if([motionManager isGyroAvailable]) {
        JasLog(@"三轴陀螺仪");
    }
    
    //距离传感器 设置了可以,但是状体还是NO就代表没有距离传感器
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    if([[UIDevice currentDevice] proximityState]) {
        JasLog(@"距离感应器");
    }
    // 位置感应器
    if ([CLLocationManager headingAvailable]) {
        JasLog(@"位置感应器");
    }
    // 磁力计
    if ([motionManager isMagnetometerAvailable]) {
        JasLog(@"磁力计");
    }
}


/**
 *  CPU使用率
 */
- (CGFloat) jas_cpuUsage {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    return tot_cpu;
}

/**
 * cpu 类型
 */
- (void) jas_cpuType {
    //    host_basic_info_data_t  hostInfo;
    //    JasLog(@"%zd",hostInfo.cpu_type);
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;
    
    infoCount = HOST_BASIC_INFO_COUNT;
    host_info(mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount);
    
    switch (hostInfo.cpu_type) {
        case CPU_TYPE_ARM:
            JasLog(@"CPU_TYPE_ARM");
            break;
            
        case CPU_TYPE_ARM64:
            JasLog(@"CPU_TYPE_ARM64");
            break;
            
        case CPU_TYPE_X86:
            JasLog(@"CPU_TYPE_X86");
            break;
            
        case CPU_TYPE_X86_64:
            JasLog(@"CPU_TYPE_X86_64");
            break;
            
        default:
            break;
    }
}

- (void) jas_hardDisk {
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfItemAtPath:@"/" error:NULL];
    JasLog(@"%@",dic);
}

/**
 * wifi信息
 */
- (void) jas_wifi {
    NSString *ssid = @"Not Found";
    NSString *macIp = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            
            ssid = [dict valueForKey:@"SSID"];
            macIp = [dict valueForKey:@"BSSID"];
        }
    }
    JasLog(@"SSID:%@ && macIP:%@",ssid,macIp);
}

/**
 * 屏幕分辨率
 */
- (void) jas_screenDimension {
    CGSize  screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat screenScale = [UIScreen mainScreen].scale;
    JasLog(@"Height = %f, Width = %f",screenScale * screenSize.height,screenScale * screenSize.width);
}

/**
 * 可用内存
 */
- (NSUInteger)jas_availableMemory{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

/**
 * 可用内存
 */
- (NSUInteger)freeMemoryBytes{
    mach_port_t           host_port = mach_host_self();
    mach_msg_type_number_t   host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t     vm_stat;
    
    host_page_size(host_port, &pagesize);
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) JasLog(@"Failed to fetch vm statistics");
    
    // natural_t   mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    natural_t mem_free = (natural_t)(vm_stat.free_count * pagesize);
    // natural_t   mem_total = mem_used + mem_free;
    
    return mem_free;
}

/**
 * 总内存
 */
- (NSUInteger)jas_totalMemory {
   return [self sysInfo:HW_PHYSMEM];
}

/**
 * 可用硬盘空间
 */
- (long long)jas_freeDiskSpace{
    struct statfs buf;
    long long freespace;
    freespace = 0;
    if(statfs("/private/var", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    return freespace;
}

/**
 * 总硬盘空间
 */
- (long long)jas_totalDiskSpace{
    struct statfs buf;
    long long totalspace;
    totalspace = 0;
    if(statfs("/private/var", &buf) >= 0){
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    return totalspace;
}

#pragma mark sysctl utils

- (NSUInteger)sysInfo:(uint) typeSpecifier {
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

/**
 * 获取系统信息
 */
- (NSString *)sysInfoByName:(char *)typeSpecifier {
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}
@end