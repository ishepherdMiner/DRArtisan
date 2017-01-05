# 日常系列

模块

# 列表

|功能|文件名|进度|
|:-:|:-:|:-:|:-:|:-:|
|推送|*NoticeService*|已支持原生*iOS8,9,10*本地推送|


# 用法

## NoticeService

*AppDelegate.m*

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    JANoticeServiceNative *native = [[JANoticeServiceNative alloc] init];
    
    // 默认选择注册sound,badge,alert
    [JANoticeService registerNoticeServiceWithDelegate:native];
    
    // 选择注册服务
    //  [JANoticeService registerNoticeServiceWithTypes:JANoticeServiceTypeAll
    //                                         delegate:native];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 去头尾<>,去空格
    NSString *deviceTokenString = [JANoticeService deviceToken:deviceToken];
    // 注册deviceToken
    // 发送给服务器
}

```

*NoticeServiceController.m*

```objc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    JANoticeService *service = [JANoticeService noRegisterService];
    if ([service.delegate isKindOfClass:[JANoticeServiceNative class]]) {
        JANoticeServiceNative *native = (JANoticeServiceNative *)service.delegate;
        native.soundName = @"sound.caf";
        native.userinfo = @{@"id":@1,@"user":@"Jason"};
        native.alertAction = @"晚上好";
    }
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"invited_3_02@2x" ofType:@"png"];
        UNNotificationAttachment *attach = [UNNotificationAttachment attachmentWithIdentifier:@"abc" URL:[NSURL fileURLWithPath:path] options:nil error:nil];
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];;
        
        [service postNoticeWithTitle:@"嘿" body:@"小妞" attachments:@[attach] trigger:trigger requestId:@"go" presentHandler:^(UNNotification *noticaiton) {
            
            NSLog(@"展现通知");
            
        } receiverHandler:^(UNNotificationResponse *reponse) {
            
            NSLog(@"点击通知");
            
        } withCompletionHandler:^(NSError *error) {
            
            if(error) {
                NSLog(@"%@",error);
            }
        }];
        
    }else if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
        
        // 本地推送 应用必须在后台
        [service postNoticeWithTitle:@"嘿" body:@"大牛" fireDate:[NSDate dateWithTimeIntervalSinceNow:7]];
    }
}
```



