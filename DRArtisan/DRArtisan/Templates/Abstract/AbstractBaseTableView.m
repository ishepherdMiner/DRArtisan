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
@property (nonatomic,weak,nullable) Class cellClass;

@end
@implementation AbstractBaseTableView

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    NSAssert(![self isMemberOfClass:[AbstractBaseTableView class]], @"AbstractBaseTableView is an abstract class, you should not instantiate it directly.");
    
    self.dataSource = self;
    self.delegate = self;
    return [super initWithFrame:frame style:style];
}

#pragma mark - UITableView Protocol
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kOne;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AbstractMethodNotImplemented();
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.vcDelegate) {
        if ([self.vcDelegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]) {
            [self.vcDelegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
        }
    }
    return kDefaultCellHeight;
}

- (void)registerClass:(nullable Class)cellClass {
    // 这句话会影响复用,对系统的cell类型来说,自定义的不影响
    // [super registerClass:cellClass forCellReuseIdentifier:NSStringFromClass([self class])];
    self.cellClass = cellClass;
    self.identifier = NSStringFromClass([self class]);
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

#pragma mark - override
- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    [super registerClass:cellClass forCellReuseIdentifier:identifier];
    self.cellClass = cellClass;
    self.identifier = identifier;
}

@end
