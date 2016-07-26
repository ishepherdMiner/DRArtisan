//
//  TYWaveProgressDemo.h
//  TYWaveProgressDemo
//
//  Created by tanyang on 15/4/14.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//  自定义外观view

#import <UIKit/UIKit.h>

/**
 *  Usage:
 *  
      TYWaveProgressView *waveProgressView = [[TYWaveProgressView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - 180)/2, 44, 240, 240)];
     waveProgressView.waveViewMargin = UIEdgeInsetsMake(15, 15, 20, 20);
     //    waveProgressView.backgroundImageView.image = [UIImage imageNamed:@"bg_tk_003"];
     waveProgressView.numberLabel.text = @"80";
     waveProgressView.numberLabel.font = [UIFont boldSystemFontOfSize:70];
     waveProgressView.numberLabel.textColor = [UIColor whiteColor];
     waveProgressView.unitLabel.text = @"%";
     waveProgressView.unitLabel.font = [UIFont boldSystemFontOfSize:20];
     waveProgressView.unitLabel.textColor = [UIColor whiteColor];
     waveProgressView.explainLabel.text = @"已使用";
     waveProgressView.explainLabel.font = [UIFont systemFontOfSize:20];
     waveProgressView.explainLabel.textColor = [UIColor whiteColor];
     
     waveProgressView.percent = 0.8;
     [self.view addSubview:waveProgressView];
     _waveProgressView1 = waveProgressView;
     [_waveProgressView1 startWave];
 */

@interface TYWaveProgressView : UIView

@property (nonatomic, weak,readonly) UIImageView *backgroundImageView; // 背景图片

@property (nonatomic, weak,readonly) UILabel *numberLabel;  // 数字

@property (nonatomic, weak,readonly) UILabel *unitLabel;    // 单位符号 ,可以没有

@property (nonatomic, weak,readonly) UILabel *explainLabel; // 单位名称 （分，正确率）

@property (nonatomic,assign) CGFloat percent; // 0~1

@property (nonatomic, assign) UIEdgeInsets  waveViewMargin;

- (void)startWave;

- (void)resetWave;

@end
