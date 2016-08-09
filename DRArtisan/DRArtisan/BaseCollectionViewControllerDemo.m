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
#import "PhotoCell.h"
#import "Photo.h"
#import "NewsCollectionCell.h"


@interface BaseCollectionViewControllerDemo () <WaterFlowLayoutDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,weak) BaseCollectionView *collect_v;

// find
@property (nonatomic , strong) NSMutableArray *photoArray;
@property (nonatomic , weak) BaseCollectionView *collectionView;

@end

@implementation BaseCollectionViewControllerDemo

- (CGFloat)waterflowLayout:(WaterFlowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    
    
//    Photo *news = self.photoArray[indexPath.item];
//    return news.small_height / news.small_width * width;
//    Photo *news = _collectionView.dataList[indexPath.item];
//    return news.small_height / news.small_width * width;
    
    NewsModel *news = _collect_v.dataList[indexPath.item];
    return news.small_height / news.small_width * width;
    
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
    flowLayout.delegate = self;
    // mark - option ...
    // flowLayout.delegate = self;
    // [flowLayout marginWithHeader:20 footer:100];
    // [flowLayout sizeWithHeader:fSize(Screen_width, 40) footer:fSize(Screen_width, 30)];
    // [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    
    BaseCollectionView *collect_v = [[FlexibleHeightCollectionView alloc] initWithFrame:Screen_bounds collectionViewLayout:flowLayout clickCellBlock:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        XcLog(@"%@",@"点击了Cell");
    }];
    // collect_v.dataList = [self datas];
    collect_v.backgroundColor = HexRGB(0xffffff);
    [collect_v registerClass:[NewsCollectionCell class]];
    
    [self.view addSubview:_collect_v = collect_v];
    
    // 2.创建UICollectionView
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
//    collectionView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
//    collectionView.dataSource = self;
//    collectionView.delegate = self;
//    [collectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:@"photo"];
//    
//    [self.view addSubview:collectionView];
//    self.collectionView = collectionView;

//    BaseCollectionView *collectionView = [[FlexibleHeightCollectionView alloc] initWithFrame:Screen_bounds collectionViewLayout:flowLayout clickCellBlock:^(UICollectionView *collectionView, NSIndexPath *indexPath) {
//        XcLog(@"%@",@"点击了Cell");
//    }];
//        collectionView.backgroundColor = [UIColor colorWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1];
//        collectionView.dataSource = self;
//        collectionView.delegate = self;
    
//    
//        [collectionView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellWithReuseIdentifier:@"photo"];
//    
//    
//        [self.view addSubview:collectionView];
//        self.collectionView = collectionView;
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
                        // Photo *model = [Photo modelWithDic:img];
                        [imgsM addObject:model];
                    }
                    
                     _collect_v.dataList = [imgsM copy];
                     XcLog(@"%@",_collect_v.dataList);
                     [_collect_v reloadData];
                    
//                    _collectionView.dataList = [imgsM copy];
//                    [_collectionView reloadData];
//                    [self.photoArray addObjectsFromArray:imgsM];
//                    [self.collectionView reloadData];
                }
            }
        
        
            XcLog(@"%@",responseObject);
        }
        
        // 刷新表格
        // [self.collectionView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XcLog(@"%@",error);
    }];
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - debug
-(NSMutableArray *)photoArray
{
    if (!_photoArray) {
        _photoArray = [NSMutableArray array];
    }
    return _photoArray;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    cell.photo = self.photoArray[indexPath.item];
    return cell;
}

@end
