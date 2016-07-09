//
//  CorePrivate.h
//  NormalCoder
//
//  Created by Jason on 7/6/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  重要的私有方法类
 */

@interface CorePrivate : NSObject

#if kCoder_Ext

/**
 *  私有
 *  获取IP地址
 */
+ (void)jas_ipAddresses;


/**
 * 私有
 * 是否有sim卡
 */
+ (BOOL)jas_hasInsertedSim;

/**
 * 私有
 * 设置中的UUID字符串
 */
+ (NSString *)jas_prefrenceUUIDString;

/**
 * 私有
 * 是否已经安装指定app
 *
 */
+ (BOOL)jas_hasInstalled:(NSString *) bundleId;

/**
 *  私有
 *  获得手机上所有安装的应用
 *
 *  @return 应用数组
 */
+ (NSArray *)jas_allInstalledApps;

/**
 * 私有
 * 该应用是否已经是非首次安装
 * 该应用要在手机上,与Apple账号绑定
 */
+ (BOOL)jas_hasRedownload:(NSString *) bundleId;

/**
 *  私有
 *  应用的安装时间
 *
 *  @param bundleId 包名
 *
 *  @return 安装时间
 */
+ (NSString *)jas_installTime:(NSString *) bundleId;

/**
 *  打开应用
 *
 *  @param bundleId 应用的bundleId
 *
 *  @return 是否打开成功(iOS10,返回为false)
 */
+ (BOOL)jas_openAppWithBundleId:(NSString *)bundleId;

#endif

@end
