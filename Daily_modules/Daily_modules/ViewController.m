//
//  ViewController.h
//  Daily_modules
//
//  Created by Jason on 02/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "ViewController.h"
#import "ComConfig.h"
#import "Daily_modules-Swift.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSInteger sections;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view addSubview:self.tableView];    
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ComConfig sharedConfig].moduleName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ComConfig sharedConfig].moduleName];
    }
    cell.textLabel.text = self.models[indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *containViewController = [[NSClassFromString(self.models[indexPath.row][@"ctrl"]) alloc] init];
    containViewController.title = self.models[indexPath.row][@"name"];
    [self.navigationController pushViewController:containViewController animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
