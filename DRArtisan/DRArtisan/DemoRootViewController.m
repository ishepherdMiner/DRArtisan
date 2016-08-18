//
//  DemoRootViewController.m
//  DRArtisan
//
//  Created by Jason on 8/18/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "DemoRootViewController.h"
#import "DemoTableViewController.h"
#import "DemoFlexibleHeightViewController.h"
#import "DemoFlexibleWidthViewController.h"

@interface DemoRootViewController () <JXServiceTableViewDelegate>

@property (nonatomic,weak) JXBaseTableView *base_v;

@end

@implementation DemoRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"案例s";
    
    JXBaseTableView *base_v = [JXBaseTableView tableViewWithFrame:Screen_bounds style:UITableViewStylePlain classType:JXTableViewClassTypeBase];
    [base_v registerCellClass:[JXDefaultCell class]];
    [base_v registerModelClass:[JXDefaultCellModel class]];
    base_v.sdelegate = self;
    base_v.dataList = [self demos];
    [self.view addSubview:_base_v = base_v];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            [self.navigationController pushViewController:[[DemoTableViewController alloc] init] animated:true];
        }
            break;
        case 1:{
            [self.navigationController pushViewController:[[DemoFlexibleHeightViewController alloc] init] animated:true];
        }
            break;
        case 2:{
            [self.navigationController pushViewController:[[DemoFlexibleWidthViewController alloc] init] animated:true];
        }
            break;
    }
}

- (NSArray *)demos{
    return [JXDefaultCellModel modelsWithDics:@[
                                                @{
                                                    @"id":@1,
                                                    @"title":@"tableView(自定义高度)",
                                                    @"icon":@"demo_tableview_02"
                                                    },
                                                @{
                                                    @"id":@2,
                                                    @"title":@"瀑布流(限宽不限高)",
                                                    @"icon":@"demo_tableview_01"
                                                    },
                                                @{
                                                    @"id":@3,
                                                    @"title":@"瀑布流(限高不限宽",
                                                    @"icon":@"demo_tableview_02"
                                                    },
                                                ]];

}

@end
