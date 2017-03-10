//
//  ShakeController.m
//  Daily_modules
//
//  Created by Jason on 10/03/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "ShakeController.h"

@interface ShakeController ()

@property (nonatomic,strong) UIImageView *shakeImageView;

@end

@implementation ShakeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 允许摇一摇
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = true;
    
    // 成为第一响应者
    [self becomeFirstResponder];
    
    // 获得图片
    _shakeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shakeImage"]];
    _shakeImageView.frame = self.view.bounds;
    _shakeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_shakeImageView];
    
    // 自动触发摇一摇
    [self performSelector:@selector(motionBegan:withEvent:) withObject:nil];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    [self shakeSender];
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
    }
}

- (void)shakeSender {
    // 绕着垂直于手机的z轴旋转,呈现的就是摇一摇动画
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // 设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:-0.2];
    
    shake.toValue = [NSNumber numberWithFloat:+0.2];
    
    shake.duration = 0.2;
    
    shake.autoreverses = YES; //是否重复
    
    // 测试时
    shake.repeatCount = 99;
    
    [_shakeImageView.layer addAnimation:shake forKey:@"imageView"];
    
    _shakeImageView.alpha = 1.0;
    
    [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{} completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
