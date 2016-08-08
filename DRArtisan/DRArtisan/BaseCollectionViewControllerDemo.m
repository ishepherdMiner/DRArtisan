//
//  BaseCollectionViewControllerDemo.m
//  DRArtisan
//
//  Created by Jason on 7/31/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseCollectionViewControllerDemo.h"
#import "NewsModel.h"
#import <AFNetworking/AFNetworking.h>
#import "NewsCollectionCell.h"

@interface BaseCollectionViewControllerDemo () <WaterFlowLayoutDelegate>

@property (nonatomic,weak) BaseCollectionView *collect_v;

@property (nonatomic,strong) NSArray *datas;

@end

@implementation BaseCollectionViewControllerDemo

- (CGFloat)waterflowLayout:(WaterFlowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    return 80 + arc4random() % 20;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    BaseCollectionViewFlowLayout *flowLayout = BaseFlowLayout(50, 50, 20, 20);
     */
    
    /*
    WaterfallFlowLayout *flowLayout = [WaterfallFlowLayout layoutWithNumOfColumns:2
                                                                        lineSpace:10
                                                                  interItemHSpace:10
                                                                           startY:40];
    */
    WaterFlowLayout *flowLayout = [[WaterFlowLayout alloc] init];
    flowLayout.columnsCount = 2;
    
    // mark - option ...
    flowLayout.delegate = self;
    // [flowLayout marginWithHeader:20 footer:100];
    // [flowLayout sizeWithHeader:fSize(Screen_width, 40) footer:fSize(Screen_width, 30)];
    // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    BaseCollectionView *collect_v = [[BaseCollectionView alloc] initWithFrame:Screen_bounds collectionViewLayout:flowLayout clickCellBlock:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        XcLog(@"%@",@"点击了Cell");
    }];
    // collect_v.dataList = [self datas];
    collect_v.backgroundColor = HexRGB(0xffffff);
    [collect_v registerClass:[NewsCollectionCell class]];
    
    [self.view addSubview:_collect_v = collect_v];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSDictionary *dic = @{@"pn":@"0",@"rn":@"60"};
    
    NSString *tag1 = @"美女";    // theme
    NSString *tag2 = @"小清新";  // category
    
    NSString *urlString = [NSString stringWithFormat:@"http://image.baidu.com/wisebrowse/data?tag1=%@&tag2=%@",tag1,tag2];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    XCHTTPSessionManager *manager = [XCHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager GET:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([[responseObject objectForKey:@"imgs"] isKindOfClass:[NSArray class]]) {
                    NSArray *imgs = [responseObject objectForKey:@"imgs"];
                    NSMutableArray *imgsM = [NSMutableArray arrayWithCapacity:[imgs count]];
                    for (NSDictionary *img in imgs) {
                        NewsModel *model = [NewsModel modelWithDic:img];
                        [imgsM addObject:model];
                    }
                    _collect_v.dataList = [imgsM copy];
                    XcLog(@"%@",_collect_v.dataList);
                    [_collect_v reloadData];
                }
            }
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
