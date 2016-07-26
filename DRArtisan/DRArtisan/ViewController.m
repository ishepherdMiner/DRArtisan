//
//  ViewController.m
//  NormalCoder
//
//  Created by Jason on 6/21/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "ViewController.h"
#import "DemoModel.h"
#import "CommentModel.h"
#import "CustomBadge.h"
#import <AVFoundation/AVFoundation.h>
#import "Waver.h"
#import "JASSession.h"
#import "JASCircleProgressView.h"

@interface ViewController ()

@property (nonatomic,weak) SingledimensionTableView *table_v;

@property (nonatomic, weak) BaseTableView *base_table_v;

@property (nonatomic,weak) UIView *badgeView;

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic,weak) UIButton *actionButton;
@property (nonatomic,weak) JASCircleProgressView *circle_progress_v;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) JASSession *session;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *btn = [self.view findViewRecursively:^BOOL(UIView *subview, BOOL *stop) {
        if ([subview isKindOfClass:[UIButton class]]) {
            return true;
        }else {
            return false;
        }
    }];
    
    JasLog(@"%@",[[[CommentModel alloc] init] jas_autoDescription]);
    JasLog(@"%@",[JASUtils encryptTable:224]);
    // 感觉作用不大,而且
    self.view.backgroundColor = RGBA(51/255.0, 73/255.0, 93/255.0, 1.0);
    self.session = [[JASSession alloc] init];
    self.session.state = SessionStateStop;
    
    JASCircleProgressView *circle_progress_v = [[JASCircleProgressView alloc] init];
    CGFloat circle_progress_w = 200;
    CGFloat circle_progress_h = circle_progress_w;
    circle_progress_v.frame = fRect((Screen_width - circle_progress_w) * 0.5, 100, circle_progress_w, circle_progress_h);
    circle_progress_v.status = @"not start";
    circle_progress_v.timeLimit = 900;
    circle_progress_v.elapsedTime = 0;
    
    [self.view addSubview:_circle_progress_v = circle_progress_v];
    
    [self startTimer];
    
    
    UIButton *actionBtn = [[UIButton alloc] init];
    actionBtn.frame = fRect(50, 300, 100, 100);
    [actionBtn addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [actionBtn setTitle:@"Start" forState:UIControlStateNormal];
    [self.view addSubview:_actionButton = actionBtn];
    /*
    [self setupRecorder];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    Waver * waver = [[Waver alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds)/2.0 - 50.0, CGRectGetWidth(self.view.bounds), 100.0)];
    
    waver.waverLevelCallback = ^(Waver * waver) {
        
        [self.recorder updateMeters];
        
        CGFloat normalizedValue = pow (10, [self.recorder averagePowerForChannel:0] / 40);
        
        waver.level = normalizedValue;
        
    };
    [self.view addSubview:waver];
*/
    
//    BadgeStyle *style = [[BadgeStyle alloc] init];
//    style.badgeTextColor = [UIColor redColor];
//    style.badgeFrameColor = [UIColor greenColor];
//    style.badgeInsetColor = [UIColor yellowColor];
//    CustomBadge *badgeView = [CustomBadge customBadgeWithString:@"99" withStyle:style];
//    UIView *vbadgeView = [[UIView alloc] initWithFrame:fRect(80, 100,40, 40)];
//    vbadgeView.backgroundColor = HexRGB(0xff0000);
//    [self.view addSubview:_badgeView = vbadgeView];
//    [self.badgeView addSubview:badgeView];

    // [self baseTableViewDemo];
}

- (void)startTimer {
    if ((!self.timer) || (![self.timer isValid])) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.00
                                                      target:self
                                                    selector:@selector(poolTimer)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)poolTimer
{
    if ((self.session) && (self.session.state == SessionStateStart))
    {
        self.circle_progress_v.elapsedTime = self.session.progressTime;
    }
}

- (void)actionButtonClick:(id)sender {
    
    if (self.session.state == SessionStateStop) {
        
        self.session.startDate = [NSDate date];
        self.session.finishDate = nil;
        self.session.state = SessionStateStart;
        
        UIColor *tintColor = [UIColor colorWithRed:184/255.0 green:233/255.0 blue:134/255.0 alpha:1.0];
        self.circle_progress_v.status = @"in progress";
        self.circle_progress_v.tintColor = tintColor;
        self.circle_progress_v.elapsedTime = 0;
        
        [self.actionButton setTitle:@"stop" forState:UIControlStateNormal];
        [self.actionButton setTintColor:tintColor];
    }
    else {
        self.session.finishDate = [NSDate date];
        self.session.state = SessionStateStop;
        
        self.circle_progress_v.status = @"start";
        self.circle_progress_v.tintColor = [UIColor whiteColor];
        self.circle_progress_v.elapsedTime = self.session.progressTime;
        
        [self.actionButton setTitle:@"start" forState:UIControlStateNormal];
        [self.actionButton setTintColor:[UIColor whiteColor]];
    }
}

-(void)setupRecorder
{
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = @{AVSampleRateKey:          [NSNumber numberWithFloat: 44100.0],
                               AVFormatIDKey:            [NSNumber numberWithInt: kAudioFormatAppleLossless],
                               AVNumberOfChannelsKey:    [NSNumber numberWithInt: 2],
                               AVEncoderAudioQualityKey: [NSNumber numberWithInt: AVAudioQualityMin]};
    
    NSError *error;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    if(error) {
        NSLog(@"Ups, could not create recorder %@", error);
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (error) {
        NSLog(@"Error setting category: %@", [error description]);
    }
    
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder record];
    
}



// 数据源为一维数组对象
- (void)singledimensionTableViewDemo {
    // 创建列表视图并设置位置
    SingledimensionTableView *table_v = [[SingledimensionTableView alloc] initWithFrame:fRect(kZero, kZero,Screen_width, Screen_height) style:UITableViewStylePlain];
    
    // 注册cell对象(要求实现:setModel:方法)
    [table_v registerClass:[JASValue1Cell class]];
    
    // 设置cell的内容类型,默认为UITableViewCellDefault(option)
     table_v.cellStyle = UITableViewCellStyleValue1;
    
    // 提供数据源
    table_v.dataList = [self stringList];
    
    // 添加到父视图
    [self.view addSubview:_table_v = table_v];
}

- (void)baseTableViewDemo {
    // 创建TableView
    BaseTableView *base_table_v = [FlexibleHeightTableView tableViewWithFrame:fRect(kZero,kZero, Screen_width, Screen_height) style:UITableViewStylePlain dataList:[self defaultCellModelList]];
    // 注册cell对象(要求实现:setModel:方法)
    [base_table_v registerClass:[JASDefaultCell class]];
    
    // 设置cell的内容类型,默认为UITableViewCellDefault(option)
    base_table_v.cellStyle = UITableViewCellStyleDefault;
    
    // 添加到父视图
    [self.view addSubview:_base_table_v = base_table_v];
}

#pragma mark - Demo
- (void)defaultCellDemo {
    // 创建列表视图并设置位置
    SingledimensionTableView *table_v = [[SingledimensionTableView alloc] initWithFrame:fRect(kZero,kZero, Screen_width, Screen_height) style:UITableViewStylePlain];
    
    // 注册cell对象(要求实现:setModel:方法)
    [table_v registerClass:[JASDefaultCell class]];
    
    // 设置cell的内容类型,默认为UITableViewCellDefault(option)
    // table_v.cellStyle = UITableViewCellStyleValue1;
    
    // 提供数据源
    table_v.dataList = [self defaultCellModelList];
    
    // 添加到父视图
    [self.view addSubview:_table_v = table_v];
}

- (void)value1CellDemo {
    // 创建列表视图并设置位置
    SingledimensionTableView *table_v = [[SingledimensionTableView alloc] initWithFrame:fRect(kZero,kZero,Screen_width, Screen_height) style:UITableViewStylePlain];
    
    // 注册cell对象(要求实现:setModel:方法)
    [table_v registerClass:[JASValue1Cell class]];
    
    // 设置cell的内容类型,默认为UITableViewCellDefault(option)
    table_v.cellStyle = UITableViewCellStyleValue1;
    
    // 提供数据源
    // table_v.dataList = [self defaultCellModelList];
    table_v.dataList = [self value1CellModelList];
    
    // 添加到父视图
    [self.view addSubview:_table_v = table_v];
}

- (void)value2CellDemo {
    // 创建列表视图并设置位置
    SingledimensionTableView *table_v = [[SingledimensionTableView alloc] initWithFrame:fRect(kZero,kZero, Screen_width, Screen_height) style:UITableViewStylePlain];
    
    // 注册cell对象(要求实现:setModel:方法)
    [table_v registerClass:[JASValue2Cell class]];
    
    // 设置cell的内容类型,默认为UITableViewCellDefault(option)
    table_v.cellStyle = UITableViewCellStyleValue2;
    
    // 提供数据源
    // table_v.dataList = [self defaultCellModelList];
    table_v.dataList = [self value1CellModelList];
    
    // 添加到父视图
    [self.view addSubview:_table_v = table_v];
}

- (void)subtitleCellDemo {
    // 创建列表视图并设置位置
    SingledimensionTableView *table_v = [[SingledimensionTableView alloc] initWithFrame:fRect(kZero,kZero, Screen_width, Screen_height) style:UITableViewStylePlain];
    
    // 注册cell对象(要求实现:setModel:方法)
    [table_v registerClass:[JASSubtitleCell class]];
    
    // 设置cell的内容类型,默认为UITableViewCellDefault(option)
    table_v.cellStyle = UITableViewCellStyleSubtitle;
    
    //
    
    // 提供数据源
    // table_v.dataList = [self defaultCellModelList];
    table_v.dataList = [self subtitleCellModelList];
    
    // 添加到父视图
    [self.view addSubview:_table_v = table_v];
}

#pragma mark - dataSource

// 字典转模型
- (NSArray *)defaultCellModelList {
    return @[
             [JASDefaultCellModel modelWithDic:@{
                                                   @"id":@1,
                                                   @"title":@"c测试,234...",
                                                   @"icon":@"http://www.baidu.comadsfadsfads"
                                                   }],
             [JASDefaultCellModel modelWithDic:@{
                                                   @"id":@2,
                                                   @"title":@"c测试,2342...c测试,2342...c测试,2342...c测试,2342...c测试,2342...",
                                                   @"icon":@"http://www.baidu.comadsfadsfads"
                                                   }],
             [JASDefaultCellModel modelWithDic:@{
                                                   @"id":@3,
                                                   @"title":@"cfads,测试...",
                                                   @"icon":@"http://www.baidu.comadsfadsfads"
                                                   }],
             [JASDefaultCellModel modelWithDic:@{
                                                   @"id":@4,
                                                   @"title":@"c测试,测试...",
                                                   @"icon":@"http://www.baidu.comadsfadsfads"
                                                   }],
             ];
}

- (NSArray *)value1CellModelList {
    return @[
             [JASValue1CellModel modelWithDic:@{
                                              @"id":@1,
                                              @"title":@"c测试,234...",
                                              @"blue_title":@"忘掉了挨个打算暗示"
                                              }
             ],
             [JASValue1CellModel modelWithDic:@{
                                              @"id":@1,
                                              @"title":@"c测试,234...",
                                              @"blue_title":@"忘掉了挨个打算暗示"
                                              }
              ],
             [JASValue1CellModel modelWithDic:@{
                                              @"id":@1,
                                              @"title":@"c测试,234...",
                                              @"blue_title":@"忘掉了挨个打算暗示"
                                              }
              ],
             [JASValue1CellModel modelWithDic:@{
                                              @"id":@1,
                                              @"title":@"c测试,234...",
                                              @"blue_title":@"忘掉了挨个打算暗示"
                                              }
              ],
            ];
}

- (NSArray *)subtitleCellModelList {
    return @[
             [JASSubtitleCellModel modelWithDic:@{
                                                @"id":@1,
                                                @"title":@"c测试,234...",
                                                @"blue_title":@"忘掉了挨个打算暗示",
                                                @"image":@"fadsfadsfadsfadsfadsfdsa"
                                                }],
             [JASSubtitleCellModel modelWithDic:@{
                                                @"id":@1,
                                                @"title":@"c测试,234...",
                                                @"blue_title":@"忘掉了挨个打算暗示",
                                                @"image":@"fadsfadsfadsfadsfadsfdsa"
                                                }],
             [JASSubtitleCellModel modelWithDic:@{
                                                @"id":@1,
                                                @"title":@"c测试,234...",
                                                @"blue_title":@"忘掉了挨个打算暗示",
                                                @"image":@"fadsfadsfadsfadsfadsfdsa"
                                                }],
             [JASSubtitleCellModel modelWithDic:@{
                                                @"id":@1,
                                                @"title":@"c测试,234...",
                                                @"blue_title":@"忘掉了挨个打算暗示",
                                                @"image":@"fadsfadsfadsfadsfadsfdsa"
                                                }],
             ];
}

- (NSArray *)moreLowDicList {
    return @[[CommentModel modelWithDic:@{
                                               @"id": @"347",
                                               @"topic_id": @"225",
                                               @"user_id": @"87",
                                               @"content": @"啊",
                                               @"reply_num": @"5",
                                               @"create_date": @"1466502431",
                                               @"nickname": @"风一样的男子",
                                               @"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"
                                               
                                     }],
             [CommentModel modelWithDic:@{
                                     
                                               @"id": @"348",
                                               @"topic_id": @"225",
                                               @"user_id": @"87",
                                               @"content": @"啊",
                                               @"reply_num": @"5",
                                               @"create_date": @"1466502431",
                                               @"nickname": @"风一样的男子",
                                               @"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"
                                               
                                     }]
             
             
             ];
}

- (NSArray *)moreDicList {
    return @[[DemoModel modelWithDic:@{@"god_comment":
                                        @{
                                              @"id": @"347",
                                              @"topic_id": @"225",
                                              @"user_id": @"87",
                                              @"content": @"啊",
                                              @"reply_num": @"5",
                                              @"create_date": @"1466502431",
                                              @"nickname": @"风一样的男子",
                                              @"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"
                                         }
                                     }],
             [DemoModel modelWithDic:@{@"god_comment":
                                         @{
                                               @"id": @"348",
                                               @"topic_id": @"225",
                                               @"user_id": @"87",
                                               @"content": @"啊",
                                               @"reply_num": @"5",
                                               @"create_date": @"1466502431",
                                               @"nickname": @"风一样的男子",
                                               @"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"
                                            }
                                     }]

             
             ];
    /*
    return @[@{@"god_comment": @[@{@"id": @"347",@"topic_id": @"225",@"user_id": @"87",@"content": @"啊",@"reply_num": @"5",@"create_date": @"1466502431",@"nickname": @"风一样的男子",@"avatar": @"http://wx.qlogo.cn/mmopen/fORIgqpObQeeBNkeicc2GsuqmmH0D7x9Pm0IrzE45tAhtePtCCOr8GWvu4gKdDEowbPxb7hHdL6xiauHdXSvTiboA/0"}],@"comment_list": @{@"p": @2,@"total": @"15",@"data": @[@{
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
                 ];
     */
    
}


// 数据源为字符串数组
- (NSArray *)stringList {
    return @[@"Single",@"Two",@"Three",@"Single",@"Two",@"Three",@"Single",@"Two",@"Three"];
}

// 数据源为字典数组
- (NSArray *)dicList {
    return @[
             @{
                 @"title":@"title_test1",
                 @"desc":@"desc_test1",
                 },
             @{
                 @"title":@"title_test2",
                 @"desc":@"desc_test2",
                 },
             @{
                 @"title":@"title_test3",
                 @"desc":@"desc_test3",
                 }
             ];
}

@end
