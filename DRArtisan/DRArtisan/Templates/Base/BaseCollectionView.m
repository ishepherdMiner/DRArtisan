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
    if (kTypecheck == kStrict) {
        for (id subList in dataList) {
            if (![subList isKindOfClass:[NSArray class]]) {
                obj.singleDimension = false;
            }
        }
    }else if(kTypecheck == kSlack) {
        if ([dataList.firstObject isKindOfClass:[NSArray class]]) {
            obj.singleDimension = false;
        }
    }
    
    obj.dataList = dataList;
    
    return obj;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.isSingleDimension ? 1 : [self.dataList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.isSingleDimension ? [self.dataList count] : [self.dataList[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[self cellClass] alloc] init];
    }
    return nil;
}

@end
