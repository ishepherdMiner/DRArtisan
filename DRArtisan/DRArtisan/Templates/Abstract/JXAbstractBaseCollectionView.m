//
//  JXAbstractBaseCollectionView.m
//  DRArtisan
//
//  Created by Jason on 7/28/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXAbstractBaseCollectionView.h"
#import "JXGlobal.h"

@interface JXAbstractBaseCollectionView ()

@property (nonatomic,weak) Class cellClass;
@property (nonatomic,strong) Class modelClass;
@property (nonatomic,copy) NSString *identifier;

@end
@implementation JXAbstractBaseCollectionView 

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    NSAssert(![self isMemberOfClass:[JXAbstractBaseCollectionView class]], @"JXAbstractBaseTableView is an abstract class, you should not instantiate it directly.");
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

- (void)registerCellClass:(Class)cellClass {
    self.cellClass = cellClass;
    self.identifier = NSStringFromClass([cellClass class]);
    [self registerClass:_cellClass forCellWithReuseIdentifier:_identifier];
}

- (void)registerModelClass:(Class)modelClass {
    self.modelClass = modelClass;
}

#pragma mark - JXBaseCollectionViewDelegate
- (void)moveItemAtIndexPath:(NSIndexPath *)srcIndexPath toIndexPath:(NSIndexPath *)desIndexPath {
    if(srcIndexPath.row != desIndexPath.row){
        NSMutableArray *dataListM = [NSMutableArray arrayWithArray:self.dataList];
        NSString *value = dataListM[srcIndexPath.row];
        [dataListM removeObjectAtIndex:srcIndexPath.row];
        [dataListM insertObject:value atIndex:desIndexPath.row];
    }
}

@end
