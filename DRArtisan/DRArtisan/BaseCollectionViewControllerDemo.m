//
//  BaseCollectionViewControllerDemo.m
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseCollectionViewControllerDemo.h"

@interface BaseCollectionViewControllerDemo ()

@property (nonatomic,weak) UICollectionView *collect_v;

@property (nonatomic,strong) NSArray *datas;

@end

@implementation BaseCollectionViewControllerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    BaseCollectionViewFlowLayout *flowLayout = [BaseCollectionViewFlowLayout LayoutWithItemSize:fSize(50,50)
                                                                                   minLineSpace:20
                                                                              minInteritemSpace:20
                                                                                   sectionInset:UIEdgeInsetsZero];
    */
//    WaterfallFlowLayout *flowLayout = [WaterfallFlowLayout layoutWithColumns:3 mininterItemSpace:5];
//    WaterfallFlowLayout *flowLayout = [[WaterfallFlowLayout alloc] init];
    
    WaterfallFlowLayout *flowLayout = [WaterfallFlowLayout layoutWithNumOfColumns:3
                                                                        lineSpace:10
                                                                  interItemHSpace:10
                                                                           startY:0];
    
    // flowLayout.delegate = self;
    // [flowLayout sizeWithHeader:fSize(Screen_width, 40) footer:fSize(Screen_width, 30)];
    // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    BaseCollectionView *collect_v = [FlexibleHeightCollectionView collectionViewWithFrame:Screen_bounds style:flowLayout dataList:[self datas]];
    [collect_v registerClass:[BaseCollectionViewCell class]];
    
    [self.view addSubview:_collect_v = collect_v];
    
}

- (NSArray *)datas {
    if (_datas == nil) {
        _datas = @[@"fasd",@"fasd",@"fasd",@"fasd",@"fasd",
                   @"fasd",@"fasd",@"fasd",@"fasd",@"fasd",
                   @"fasd",@"fasd",@"fasd",@"fasd",@"fasd",
                   @"fasd",@"fasd",@"fasd",@"fasd",@"fasd",
                   @"fasd",@"fasd",@"fasd",@"fasd",@"fasd",
                   @"fasd",@"fasd",@"fasd",@"fasd",@"fasd",
                   @"fasd",@"fasd",@"fasd",@"fasd",@"fasd",
                   @"fasd",@"fasd",@"fasd",@"fasd",@"fasd",
                   @"fasd",@"fasd",@"fasd",@"fasd",@"fasd",
                   @"fasd",@"fasd",@"fasd",@"fasd",@"fasd",
                   @"fasd",@"fasd",@"fasd",@"fasd",@"fasd",
                   @"fasd",@"fasd",@"fasd",@"fasd",@"fasd",
                   @"fasd",@"fasd",@"fasd",@"fasd",@"fasd"];
    }
    return _datas;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
