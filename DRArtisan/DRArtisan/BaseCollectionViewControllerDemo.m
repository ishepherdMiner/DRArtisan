//
//  BaseCollectionViewControllerDemo.m
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseCollectionViewControllerDemo.h"

#import <AFNetworking/AFNetworking.h>

@interface BaseCollectionViewControllerDemo ()

@property (nonatomic,weak) UICollectionView *collect_v;

@property (nonatomic,strong) NSArray *datas;

@end

@implementation BaseCollectionViewControllerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    BaseCollectionViewFlowLayout *flowLayout = BaseFlowLayout(50, 50, 20, 20);
     */
    
    WaterfallFlowLayout *flowLayout = [WaterfallFlowLayout layoutWithNumOfColumns:3
                                                                        lineSpace:40
                                                                  interItemHSpace:10
                                                                           startY:40];
    
    // mark - option ...
    // flowLayout.delegate = self;
    // [flowLayout marginWithHeader:20 footer:100];
    // [flowLayout sizeWithHeader:fSize(Screen_width, 40) footer:fSize(Screen_width, 30)];
    // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    BaseCollectionView *collect_v = [FlexibleHeightCollectionView collectionViewWithFrame:Screen_bounds style:flowLayout dataList:[self datas]];
    collect_v.backgroundColor = HexRGB(0xffffff);
    [collect_v registerClass:[BaseCollectionViewCell class]];
    
    [self.view addSubview:_collect_v = collect_v];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDictionary *dic = @{@"pn":@"0",@"rn":@"60"};
    
    NSString *tag1 = @"美女";    // theme
    NSString *tag2 = @"小清新";  // category
    
    NSString *urlString = [NSString stringWithFormat:@"http://image.baidu.com/wisebrowse/data?tag1=%@&tag2=%@",tag1,tag2];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager GET:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            XcLog(@"%@",responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XcLog(@"%@",error);
    }];
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
