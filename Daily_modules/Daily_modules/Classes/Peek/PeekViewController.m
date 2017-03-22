//
//  PeekViewController.m
//  Daily_modules
//
//  Created by Jason on 22/03/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "PeekViewController.h"
#import "PreviewViewController.h"

@interface PeekViewController () <UIViewControllerPreviewingDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *datas;

@end

@implementation PeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"peekpop"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"peekpop"];
    }
    
    cell.textLabel.text = self.datas[indexPath.row];
    
    /**
     *  UIForceTouchCapability 检测是否支持3D Touch
     *  支持3D Touch
     */
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        // 系统所有cell可实现预览（peek）
        [self registerForPreviewingWithDelegate:self sourceView:cell]; // 注册cell
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PreviewViewController *webVC = [[PreviewViewController alloc] init];
    webVC.webUrl = self.datas[indexPath.row];
    
    webVC.hidesBottomBarWhenPushed = true;
    
    [self.navigationController pushViewController:webVC animated:true];
}

#pragma mark - UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    
    // 转化坐标
    location = [self.tableView convertPoint:location fromView:[previewingContext sourceView]];
    
    // 根据locaton获取位置
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    PreviewViewController *webVC = [[PreviewViewController alloc] init];
    webVC.webUrl = self.datas[indexPath.row];
    
    return webVC;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    
    viewControllerToCommit.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}

# pragma mark - 懒加载

- (NSArray *)datas {
    if (_datas == nil) {
        NSMutableArray *dataM = [NSMutableArray arrayWithCapacity:30];
        for (int i = 0; i < 10; ++i) {
            [dataM addObject:@"https://www.baidu.com"];
        }
        _datas = [dataM copy];
    }
    return _datas;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
