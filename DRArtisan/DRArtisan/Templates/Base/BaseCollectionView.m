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
    
    BaseCollectionView *obj = [[self alloc] initWithFrame:frame collectionViewLayout:style];
    
    obj.singleDimension = true;
    // Require any element is NSArray class object
    if (kTypecheck == kStrict) {
        for (id subList in dataList) {
            if ([subList isKindOfClass:[NSArray class]]) {
                obj.singleDimension = false;
            }
        }
    }else if(kTypecheck == kSlack) {
        // Require first element is NSArray class object
        if ([dataList.firstObject isKindOfClass:[NSArray class]]) {
            obj.singleDimension = false;
        }
    }
    
    obj.customSetter = true;
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

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    // UIImage *image = self.images[indexPath.item];
//    // CGFloat newHeight = image.size.height / image.size.width * self.imageWidth;
//    return CGSizeMake(90, 80 + (arc4random() % 150));
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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
    JasLog(@"You can implement collectionView:didSelectItemAtIndexPath: in class which is extends BaseCollectionView.");
}

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    if (self.customSetter == false) { return; }
    
    // Need Custom implement setter dataList
    NSMutableArray *dataListM = [NSMutableArray arrayWithCapacity:[dataList count]];
    if (self.isSingleDimension) {
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



@end
