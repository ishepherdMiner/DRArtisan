//
//  AppDelegate.m
//  Daily_modules
//
//  Created by Jason on 02/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "AppDelegate.h"
#import "JANoticeServiceKit.h"
#import "UIImage+JACoder.h"
#import <CoreMotion/CoreMotion.h>
#import "UIDevice+JACoder.h"
#import "NSDate+JACoder.h"
#import "JATabBarController.h"

@interface AppDelegate ()
@property (nonatomic,strong) JANoticeService *service;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    JANoticeServiceNative *native = [[JANoticeServiceNative alloc] init];
    // JANoticeServiceJPush *jpush = [[JANoticeServiceJPush alloc] init];
    
    // 默认选择注册sound,badge,alert
    [JANoticeService registerNoticeServiceWithDelegate:native];
    
    // 选择注册服务
    //  [JANoticeService registerNoticeServiceWithTypes:JANoticeServiceTypeAll
    //                                         delegate:native];
    // NSLog(@"%@",[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSBundle mainBundle].bundlePath error:nil]);
    
    self.window.rootViewController = [self getRootViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 去头尾<>,去空格
    // NSString *deviceTokenString = [JANoticeService deviceToken:deviceToken];
    // 注册deviceToken
    // 发送给服务器
}

- (UITabBarController *)getRootViewController {
    NSDictionary *tabBarDic = @{
                                @"列表":@{
                                            @"image":@"tabicon_01",
                                            @"selectedImage":@"tabicon_01_pressed",
                                            @"vc":@"ViewController",
                                        },
                                @"交易":@{
                                            @"image":@"tabicon_02",
                                            @"selectedImage":@"tabicon_02_pressed",
                                            @"vc":@"UIViewController",
                                        },
                                @"我的":@{
                                            @"image":@"tabicon_03",
                                            @"selectedImage":@"tabicon_03_pressed",
                                            @"vc":@"UIViewController",
                                        },
                                @"工具":@{
                                            @"image":@"tabicon_04",
                                            @"selectedImage":@"tabicon_04_pressed",
                                            @"vc":@"UIViewController",
                                        }
                                };
    NSArray *titles = [tabBarDic allKeys];
    NSMutableArray *imagesM = [NSMutableArray arrayWithCapacity:titles.count];
    NSMutableArray *selectedImagesM = [NSMutableArray arrayWithCapacity:titles.count];
    NSMutableArray *vcs = [NSMutableArray arrayWithCapacity:titles.count];
    for (NSString *title in titles) {
        UIImage *image = [UIImage imageNamed:[[tabBarDic objectForKey:title] objectForKey:@"image"]];
        [imagesM addObject:image];
        UIImage *selectedImage = [UIImage imageNamed:[[tabBarDic objectForKey:title] objectForKey:@"selectedImage"]];
        [selectedImagesM addObject:selectedImage];
        
        UIViewController *vc = [[NSClassFromString([[tabBarDic objectForKey:title] objectForKey:@"vc"]) alloc] init];
        vc.title = title;        
        
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
        [vcs addObject:navC];
    }
    
    JATabBarController *tabBarVC = [[JATabBarController alloc] init];
    
    [tabBarVC customizeTabBarWithTitles:titles images:[imagesM copy] selectedImages:[selectedImagesM copy]];
    [tabBarVC customizeTabBarWithControllers:vcs];
    
    [tabBarVC.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        
        // 未选中状态下文字颜色
        [[obj tabBarItem] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithWhite:0.572549 alpha:1.0], NSFontAttributeName:[UIFont systemFontOfSize:10],NSBaselineOffsetAttributeName:@5} forState:UIControlStateNormal];
        [[obj tabBarItem] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
        
        // 选中状态下的文字颜色
        [[obj tabBarItem] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:1.0 green:0 blue:19/255.0 alpha:1.0]} forState:UIControlStateSelected];
    }];
    
    return tabBarVC;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
