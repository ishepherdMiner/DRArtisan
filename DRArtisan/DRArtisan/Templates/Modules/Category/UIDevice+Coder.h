//
//  UIDevice+Coder.h
//  DeviceInfoDemo
//
//  Created by Jason on 4/3/16.
//  Copyright © 2016 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,DeviceDirect){
    DeviceDirectHor,
    DeviceDirectVer,
};


@interface UIDevice (Coder)

/**
 * 输出设备信息
 */
+ (void)jas_logInfo;

/**
 *  设备感应器
 */
+ (void)jas_sersor;

/**
 *  CPU使用率
 *
 *  @return CPU使用率
 */
+ (CGFloat)jas_cpuUsage;

/**
 *  CPU类型
 */
+ (void)jas_cpuType;

/**
 *  硬盘信息
 */
+ (void)jas_hardDiskStatus;

/**
 *  剩余硬盘空间
 *
 *  @return 剩余硬盘空间
 */
+ (long long)jas_freeHardDiskSpace;

/**
 *  总硬盘空间
 *
 *  @return 总硬盘空间
 */
+ (long long)jas_totalHardDiskSpace;

/**
 *  Wifi信息
 */
+ (void)jas_wifi;
/**
 *  屏幕分辨率
 */
+ (void)jas_screenDimension;

/**
 *  可用内存,单位M 不准(看着更像app使用的内存)
 *
 *  @return
 */
+ (NSUInteger)jas_freeMemory;

/**
 *  可用内存 不准
 *
 *  @return 可用内存
 */
+ (NSUInteger)jas_freeMemoryBytes;

/**
 *  总内存
 *
 *  @return 总内存
 */
+ (NSUInteger)jas_totalMemory;


/**
 *  获取广告标示符
 */
+ (NSString *)jas_adid;

/**
 *  屏幕亮度
 *
 *  @return 屏幕亮度(0.0~1.0)
 */
+ (CGFloat)jas_screen_brightness;

/**
 *  电池状态
 *
 *  @return (0:未知,1:未接入电源,2:接入点点,3:满电量)
 */
+ (NSUInteger)jas_battery_status;

/**
 *  电池剩余电量(精确到5%)
 *
 *  @return 剩余电量
 */
+ (CGFloat)jas_battery_left;

/**
 *  本次开机运行时间(单位:天)
 *
 *  @return 本次开机运行时间
 */
+ (NSString *)jas_system_running_time;

/**
 *  本次开机时间戳
 *
 *  @return 本次开机时间戳
 */
+ (NSString *)jas_system_start_time;

/**
 *  设备处在横屏/竖屏
 *
 *  @return 设备处在横屏/竖屏
 */
+ (DeviceDirect)jas_device_direct;

/**
 *  App包名
 *
 *  @return 包名
 */
+ (NSString *)jas_bundleId;

/**
 *  系统语言
 *
 *  @return 系统语言
 */
+ (NSString *)jas_language;

/**
 *  网络运营商(China)
 *
 *  @return CM(中国移动) CU(中国联通) CT(中国电信)
 */
+ (NSString *)jas_isp;

/**
 *  关于idfv:
 *    同设备,同应用,同vender => idfv相同
 *    vender为CFBundleIdentifier(反向DNS格式)的前两部分
 *     (比如 com.tencent.qq com.tencent.wechat 得到的vender相同)
 *     同一个公司的多个产品比较容易出现idfv相同的情况
 *    同设备,同应用,不同vender => idfv不同
 *    如果重新安装,则idfv也会不同
 *  @return NSUUID对象
 */
+ (NSString *)jas_idfv;



@end
