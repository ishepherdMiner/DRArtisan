//
//  BaseCollectionView.m
//  DRArtisan
//
//  Created by Jason on 7/28/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseCollectionView.h"
#import "BaseCollectionViewCell.h"

#define kSlack      kZero
#define kStrict     kOne

@interface BaseCollectionView ()

@property (nonatomic,copy) ClickCellBlock clickCellBlock;

@end

@implementation BaseCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    return [self initWithFrame:frame collectionViewLayout:layout clickCellBlock:nil];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout clickCellBlock:(ClickCellBlock)click {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.customSetter = true;
        self.clickCellBlock = click;
    }
    return self;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // don't call setDataList: but set value for dataList property
    if (_sourceType == XCCollectionViewDataSourceTypeUnassigned) {
        _sourceType = [self dataSourceTypeWithDataList:_dataList];
    }
    
    return _sourceType == XCCollectionViewDataSourceTypeSingle ?
        [super numberOfSectionsInCollectionView:collectionView] : [self.dataList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _sourceType == XCCollectionViewDataSourceTypeSingle ?
        [super collectionView:collectionView numberOfItemsInSection:section] : [self.dataList[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
    
    NSAssert(cell, @"You should call registerClass: method");
    
    if (_sourceType == XCCollectionViewDataSourceTypeSingle) {
        cell.model = self.dataList[indexPath.row];
    }else {
        cell.model = self.dataList[indexPath.section][indexPath.row];
    }
    
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    // UIImage *image = self.images[indexPath.item];
//    // CGFloat newHeight = image.size.height / image.size.width * self.imageWidth;
//    return CGSizeMake(90, 80 + (arc4random() % 150));
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.clickCellBlock) {
        return self.clickCellBlock(collectionView,indexPath);
    }
    
    if (self.cdelegate) {
        if ([self.cdelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
            return [self.cdelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
        }
    }
    
    if (self.sdelegate) {
        if ([self.sdelegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
            return [self.sdelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
        }
    }
    
    // If you extends BaseTableView and you can implement tableView:didSelectRowAtIndexPath: action event
    XcLog(@"You can implement collectionView:didSelectItemAtIndexPath: in class which is extends BaseCollectionView.");
}

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    if (_sourceType == XCCollectionViewDataSourceTypeUnassigned) {
        _sourceType = [self dataSourceTypeWithDataList:dataList];
    }
    if (self.customSetter == false) { return; }
    
    // Need Custom implement setter dataList
    NSMutableArray *dataListM = [NSMutableArray arrayWithCapacity:[dataList count]];
    if (_sourceType == XCCollectionViewDataSourceTypeSingle) {
        for (id data in dataList) {
            if(kFoundationProperty(data)){
                [dataListM addObject:[self packFoundationClass:data]];
            }else {
                [dataListM addObject:data];
            }
        }
    }else {
        for (NSArray *subdataList in dataList) {
            NSMutableArray *subdataListM = [NSMutableArray arrayWithCapacity:[subdataList count]];
            for (id subdata in subdataList) {
                if(kFoundationProperty(subdata)){
                    [subdataListM addObject:[self packFoundationClass:subdata]];
                }else {
                    [subdataListM addObject:subdata];
                }
            }
            [dataListM addObject:[subdataListM copy]];
        }
    }
    _dataList = [dataListM copy];
}

- (XCCollectionViewDataSourceType)dataSourceTypeWithDataList:(NSArray *)dataList {
    _sourceType = XCCollectionViewDataSourceTypeSingle;
    if (kTypecheck == kStrict) {
        for (id subList in dataList) {
            if ([subList isKindOfClass:[NSArray class]]) {
                _sourceType = XCCollectionViewDataSourceTypeMulti;
                break;
            }
        }
    }else if(kTypecheck == kSlack) {
        if ([dataList.firstObject isKindOfClass:[NSArray class]]) {
            _sourceType = XCCollectionViewDataSourceTypeMulti;
        }
    }
    
    return _sourceType;
}

@end
