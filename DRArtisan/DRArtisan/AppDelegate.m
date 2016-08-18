//
//  AppDelegate.m
//  NormalCoder
//
//  Created by Jason on 6/21/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#import "DemoTableViewController.h"
#import "FlexibleHeightCollectionViewController.h"
#import "DemoFlexibleWidthViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:Screen_bounds];
    //
     _window.rootViewController = [[DemoFlexibleWidthViewController alloc] init];
//     _window.rootViewController = [[DemoTableViewController alloc] init];
//    _window.rootViewController = [[FlexibleHeightCollectionViewController alloc] init];
    [UIDevice jas_broken];
#if kCoder_Ext
    // 该用法用于测试iOS版本升级后的测试
    // [self iosUpgradeTest];
#endif
//    NSDictionary *demoDic = [self demoDic];
//    XcLog(@"%@",demoDic);
//    
//    NSArray *demoArr = [self demoArr];
//    XcLog(@"%@",demoArr);
    
//    [JXUtils monitorWithObserver:self selector:nil option:ObservedOptionsBrightness];
    
    [UIScreen mainScreen].brightness = 0.3;
    
    [NSString jas_propertyList];
    // [JXUtils logViewRecursive:_window];
    
    _window.backgroundColor = HexRGB(0xffffff);
    [_window makeKeyAndVisible];
    
    return YES;
}

//- (void)change:(NSNotification *)noti {
//    XcLog(@"1");
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    XcLog(@"2");
//}

- (void)iosUpgradeTest {
    // JasError;
    
    // [CorePrivate jas_ipAddresses];
    // [CorePrivate jas_allInstalledApps];
    
    // [CorePrivate jas_prefrenceUUIDString];
    
    // [CorePrivate jas_hasInsertedSim];
    
    // [CorePrivate jas_hasInstalled:@"com.abc.dsafsaf"];
    /*
     测试用例:
     "com.sinldo1.ihealth", 爱护健康 false
     "com.sinldo.aihu",  分享医疗 false
     删除再安装
     "com.sinldo.aihu" true
     "com.vf404.200",    false
     "com.lq.jason889",  false
     "com.abc.dsafsaf"   false
     */
    // [CorePrivate jas_hasRedownload:@"com.sinldo.aihu"];
    // [CorePrivate jas_installTime:@"com.sinldo.aihu"];
    // [CorePrivate jas_openAppWithBundleId:@"com.zplay.popstar2"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSDictionary *)demoDic {
    return  @{
              @"code": @"0",
              @"msg": @"成功",
              @"data": @{@"god_comment": @[@{@"id": @"347",@"topic_id": @"225",@"user_id": @"87",@"content": @"啊",@"reply_num": @"5",@"create_date": @"1466502431",@"nickname": @"风一样的男子",@"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"}],@"comment_list": @{@"p": @2,@"total": @"15",@"data": @[@{
                                                                                                                                                                                                                                                                                                                                                                                           @"id": @"351",
                                                                                                                                                                                                                                                                                                                                                                                           @"topic_id": @"225",
                                                                                                                                                                                                                                                                                                                                                                                           @"user_id": @"87",
                                                                                                                                                                                                                                                                                                                                                                                           @"content": @"睡觉睡觉就是",
                                                                                                                                                                                                                                                                                                                                                                                           @"reply_num":@"0",
                                                                                                                                                                                                                                                                                                                                                                                           @"create_date": @"1466502443",
                                                                                                                                                                                                                                                                                                                                                                                           @"nickname": @"风一样的男子",
                                                                                                                                                                                                                                                                                                                                                                                           @"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"
                                                                                                                                                                                                                                                                                                                                                                                           },
                                                                                                                                                                                                                                                                                                                                                                                       @{
                                                                                                                                                                                                                                                                                                                                                                                           @"id": @"350",
                                                                                                                                                                                                                                                                                                                                                                                           @"topic_id": @"225",
                                                                                                                                                                                                                                                                                                                                                                                           @"user_id": @"87",
                                                                                                                                                                                                                                                                                                                                                                                           @"content": @"只能是女神",
                                                                                                                                                                                                                                                                                                                                                                                           @"reply_num": @"0",
                                                                                                                                                                                                                                                                                                                                                                                           @"create_date": @"1466502440",
                                                                                                                                                                                                                                                                                                                                                                                           @"nickname": @"风一样的男子",
                                                                                                                                                                                                                                                                                                                                                                                           @"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"
                                                                                                                                                                                                                                                                                                                                                                                           }
                                                                                                                                                                                                                                                                                                                                                                                       ]
                                                                                                                                                                                                                                                                                                                                                   }
                         }
              };
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSArray *)demoArr {
    return @[@"天下大方安抚阿斯蒂芬阿斯蒂芬阿萨德发送到发",@[@"大法师法",@"dasfa",@"网大方阿萨德f"],@"asdfasd fdsfsda afsd ",@"未送达的三分王",@"dfasfas为爱对方"];
}

@end
