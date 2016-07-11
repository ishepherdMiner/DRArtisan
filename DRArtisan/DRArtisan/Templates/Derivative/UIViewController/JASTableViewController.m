//
//  JASTableViewController.m
//  Flow
//
//  Created by Jason on 7/12/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "JASTableViewController.h"

@interface JASTableViewController ()

@end

@implementation JASTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.table_datas.firstObject isKindOfClass:[NSArray class]]) {
        return [self.table_datas count];
    }
    return kOne;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.table_datas.firstObject isKindOfClass:[NSArray class]]) {
        return [self.table_datas[section] count];
    }
    return [self.table_datas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AbstractMethodNotImplemented();
}

@end
