//
//  AbstractBaseCollectionView.m
//  DRArtisan
//
//  Created by Jason on 7/28/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "AbstractBaseCollectionView.h"
@interface AbstractBaseCollectionView ()

@property (nonatomic,weak) Class cellClass;
@property (nonatomic,copy) NSString *identifier;

@end
@implementation AbstractBaseCollectionView 

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    NSAssert(![self isMemberOfClass:[AbstractBaseCollectionView class]], @"AbstractBaseTableView is an abstract class, you should not instantiate it directly.");
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource = self;
        self.delegate = self;
    }
    
    return self;
}

#pragma mark - UICollectionView Protocol
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return kOne;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AbstractMethodNotImplemented();
}

- (void)registerClass:(Class)cellClass {
    self.cellClass = cellClass;
    self.identifier = NSStringFromClass([cellClass class]);
    [self registerClass:_cellClass forCellWithReuseIdentifier:_identifier];
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
