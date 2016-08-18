//
//  JXDemoFlexibleWidthViewController.m
//  DRArtisan
//
//  Created by Jason on 8/17/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "DemoFlexibleWidthViewController.h"
#import "JXTagChooserView.h"

@interface DemoFlexibleWidthViewController ()

@property (nonatomic,weak)  JXTagChooserView *tagChooserView;

@end

@implementation DemoFlexibleWidthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    JXTagChooserView *tagChooserView = [JXTagChooserView chooserViewWithFrame:fRect(0, 64, Screen_width, Screen_height - 64) bottomHeight:300 maxSelectCount:5];
    
    [self.view addSubview:_tagChooserView = tagChooserView];
    NSArray *dataList = @[
                          @"篮球",@"足球",@"羽毛球",@"乒乓球",@"排球",
                          @"网球",@"高尔夫球",@"冰球",@"沙滩排球",@"棒球",
                          @"垒球",@"藤球",@"毽球",@"台球",@"鞠蹴",@"板球",
                          @"壁球",@"沙壶",@"冰壶",@"克郎球",@"橄榄球",
                          @"曲棍球",@"水球",@"马球",@"保龄球",@"健身球",
                          @"门球",@"弹球",
                        ];
    NSMutableArray *randListM = [NSMutableArray arrayWithCapacity:100];
    for (int i = 0; i < 100; ++i) {
        [randListM addObject:dataList[arc4random() % [dataList count]]];
    }
    tagChooserView.collect_v.dataList = [randListM copy];
}


@end
