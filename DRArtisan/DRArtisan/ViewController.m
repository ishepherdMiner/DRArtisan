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
    
    XcLog(@"%@",[[[CommentModel alloc] init] jas_autoDescription]);
    [JASUtils encryptTable:224];
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
@end
