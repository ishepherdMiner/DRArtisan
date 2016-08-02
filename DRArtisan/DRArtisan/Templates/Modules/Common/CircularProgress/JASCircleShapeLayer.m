//
//  JASCircleShapeLayer.m
//  DRArtisan
//
//  Created by Jason on 7/18/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JASCircleShapeLayer.h"

@interface JASCircleShapeLayer ()

/// 进度条初始值
@property (nonatomic,assign) double initialProgress;

@property (nonatomic,strong) CAShapeLayer *progressLayer;

@property (nonatomic,assign,readwrite) double percent;
@end

@implementation JASCircleShapeLayer

- (instancetype)init {
    if (self = [super init]) {
        [self setupLayer];
    }
    return self;
}

- (void)setupLayer {
    // 路径
    self.path = [self drawPathWithArcCenter];
    
    // 填充色
    self.fillColor = [UIColor clearColor].CGColor;
    
    // 画笔颜色
    self.strokeColor = RGBA(0.86f, 0.86f, 0.86f, 0.4f).CGColor;
    
    // 画笔宽度
    self.lineWidth = 20;
    
    // 覆盖在上面的那一层layer
    self.progressLayer = [CAShapeLayer layer];
    
    self.progressLayer.path = [self drawPathWithArcCenter];
    
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.progressLayer.lineWidth = 20;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.lineJoin = kCALineJoinRound;
    [self addSublayer:self.progressLayer];
}

- (void)layoutSublayers {
    self.path = [self drawPathWithArcCenter];
    self.progressLayer.path = [self drawPathWithArcCenter];
    [super layoutSublayers];
}

/// 绘制路径
- (CGPathRef)drawPathWithArcCenter {
    CGFloat position_y = self.frame.size.height * 0.5;
    CGFloat position_x = self.frame.size.width * 0.5;
    return [UIBezierPath bezierPathWithArcCenter:fPoint(position_x, position_y) radius:position_y startAngle:(-M_PI / 2) endAngle:(3 * M_PI / 2) clockwise:true].CGPath;
}

/// 设置已经消耗的时间
- (void)setElapsedTime:(NSTimeInterval)elapsedTime {
    _initialProgress = [self calculatePercent:_elapsedTime toTime:_timeLimit];
    _elapsedTime = elapsedTime;
    self.progressLayer.strokeEnd = self.percent;
   
    [self startAnimation];
}

- (double)percent {
    // 已消耗时间 / 限制时间(结束时间)
    _percent = [self calculatePercent:_elapsedTime toTime:_timeLimit];
    return _percent;
}

- (double)calculatePercent:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime {
    if ((toTime > 0) && (fromTime > 0)) {
        CGFloat progress = 0;
        progress = fromTime / toTime;
        // 用这种方式限定进度最大为1.0
        if((progress * 100) > 100) {
            progress = 1.0f;
        }
        XcLog(@"Percent = %f", progress);
        
        return progress;
    }
    return  0.0f;
}

- (void)startAnimation {
    // 基本动画(伴随进度条,self.progressLayer.strokeEnd = self.percent)
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    // 动画时间
    pathAnimation.duration = 1.0;
    
    // 初始位置
    pathAnimation.fromValue = @(self.initialProgress);
    
    // 结束位置
    pathAnimation.toValue = @(self.percent);
    
    // 绘制完成后,移除对话
    pathAnimation.removedOnCompletion = true;
    
    [self.progressLayer addAnimation:pathAnimation forKey:nil];
}

@end
