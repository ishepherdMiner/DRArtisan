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

@property (nonatomic,assign,getter=isSingleDimension) BOOL singleDimension;

@end

@implementation BaseCollectionView

+ (instancetype)collectionViewWithFrame:(CGRect)frame
                                  style:(UICollectionViewLayout *)style
                               dataList:(NSArray *)dataList {
    
    NSAssert([dataList isKindOfClass:[NSArray class]], @"dataSource param must be an array class");
    
    BaseCollectionView *obj = [[BaseCollectionView alloc] initWithFrame:frame collectionViewLayout:style];
    
    obj.singleDimension = true;
    // Require any element is NSArray class object
    if (kTypecheck == kStrict) {
        for (id subList in dataList) {
            if (![subList isKindOfClass:[NSArray class]]) {
                obj.singleDimension = false;
            }
        }
    }else if(kTypecheck == kSlack) {
        // Require first element is NSArray class object
        if ([dataList.firstObject isKindOfClass:[NSArray class]]) {
            obj.singleDimension = false;
        }
    }
    
    obj.dataList = dataList;
    
    return obj;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.isSingleDimension ?
        [super numberOfSectionsInCollectionView:collectionView] : [self.dataList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.isSingleDimension ?
        [super collectionView:collectionView numberOfItemsInSection:section] : [self.dataList[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
    
    NSAssert(cell, @"You should call registerClass: method");
    
    if (self.isSingleDimension) {
        cell.model = self.dataList[indexPath.row];
    }else {
        cell.model = self.dataList[indexPath.section][indexPath.row];
    }
    
    return cell;
}

@end
