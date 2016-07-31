//
//  BaseTableViewImpl.m
//  NormalCoder
//
//  Created by Jason on 7/7/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import "AbstractBaseTableView.h"

#define kDefaultCellHeight 60

@interface AbstractBaseTableView ()

@property (nonatomic,copy,nullable) NSString *identifier;
@property (nonatomic,strong,nullable) Class cellClass;

@end
@implementation AbstractBaseTableView

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    NSAssert(![self isMemberOfClass:[AbstractBaseTableView class]], @"AbstractBaseTableView is an abstract class, you should not instantiate it directly.");
    
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

#pragma mark - UITableView Protocol
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kOne;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AbstractMethodNotImplemented();
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cdelegate) {
        if ([self.cdelegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]) {
            [self.cdelegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
        }
    }
    return kDefaultCellHeight;
}

- (void)registerClass:(nullable Class)cellClass {
    self.cellClass = cellClass;
    self.identifier = NSStringFromClass([self class]);
    [self registerClass:cellClass forCellReuseIdentifier:self.identifier];
}

#pragma mark - Wait to improve
- (JASBaseCellModel *)packFoundationClass:(id)obj {
    JASBaseCellModel *model = [[JASBaseCellModel alloc] init];
    if ([obj isKindOfClass:[NSString class]]) {
        model.b_string = obj;
    }else if([obj isKindOfClass:[NSNumber class]]){
        model.b_number = obj;
    }else{return obj;}
    return model;
}

@end

