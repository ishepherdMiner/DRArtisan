//
//  BaseCollectionView.m
//  DRArtisan
//
//  Created by Jason on 7/28/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXGlobal.h"
#import "JXSwitch.h"
#import "JXBaseObject.h"
#import "JXBaseCollectionView.h"
#import "JXBaseCollectionViewCell.h"

#define kSlack      kZero
#define kStrict     kOne

@interface JXBaseCollectionView ()

@property (nonatomic,copy) ClickItemBlock clickItemBlock;

@end

@implementation JXBaseCollectionView

+ (instancetype)collectionViewWithFrame:(CGRect)frame
                                 layout:(UICollectionViewLayout *)layout
                              classType:(JXCollectionViewClassType)classType
                         clickItemBlock:(ClickItemBlock)click {
    
    JXBaseCollectionView *base_collect_v = nil;
    switch (classType) {
        case JXCollectionViewClassTypeBase:{
            base_collect_v = [[NSClassFromString(@"JXBaseCollectionView") alloc] initWithFrame:frame collectionViewLayout:layout];
        }
            break;
        case JXCollectionViewClassTypeFlexVer:{
            base_collect_v = [[NSClassFromString(@"JXFlexibleHeightCollectionView") alloc] initWithFrame:frame collectionViewLayout:layout];
        }
            break;
        case JXCollectionViewClassTypeFlexHor:{
            base_collect_v = [[NSClassFromString(@"JXFlexibleWidthCollectionView") alloc] initWithFrame:frame collectionViewLayout:layout];
        }
        // Continue:
            break;
    }
    if (base_collect_v) {
        base_collect_v.customSetter = true;
        base_collect_v.clickItemBlock = click;
    }

#if DEBUG
    NSAssert(base_collect_v, @"Create JXBaseCollectionView fail,please check params");
#endif
    
    return base_collect_v;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // don't call setDataList: but set value for dataList property
    if (_sourceType == JXCollectionViewDataSourceTypeUnassigned) {
        _sourceType = [self dataSourceTypeWithDataList:_dataList];
    }
    
    return _sourceType == JXCollectionViewDataSourceTypeSingle ?
        [super numberOfSectionsInCollectionView:collectionView] : [self.dataList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _sourceType == JXCollectionViewDataSourceTypeSingle ?
        [super collectionView:collectionView numberOfItemsInSection:section] : [self.dataList[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JXBaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.identifier forIndexPath:indexPath];
    
    NSAssert(cell, @"You should call registerCellClass: method");
    
    if (_sourceType == JXCollectionViewDataSourceTypeSingle) {
        [cell injectedModel:self.dataList[indexPath.row]];
    }else {
        [cell injectedModel:self.dataList[indexPath.section][indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.clickItemBlock) {
        return self.clickItemBlock(collectionView,indexPath);
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
    JXLog(@"You can implement collectionView:didSelectItemAtIndexPath: in class which is extends JXBaseCollectionView.");
}

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    if (_sourceType == JXCollectionViewDataSourceTypeUnassigned) {
        _sourceType = [self dataSourceTypeWithDataList:dataList];
    }
    if (self.customSetter == false) { return; }
    
    // Need Custom implement setter dataList
    NSMutableArray *dataListM = [NSMutableArray arrayWithCapacity:[dataList count]];
    if (_sourceType == JXCollectionViewDataSourceTypeSingle) {
        for (id data in dataList) {
            if(kFoundationProperty(data)){
                [dataListM addObject:[self.modelClass package2Model:data]];
            }else {
                [dataListM addObject:data];
            }
        }
    }else {
        for (NSArray *subdataList in dataList) {
            NSMutableArray *subdataListM = [NSMutableArray arrayWithCapacity:[subdataList count]];
            for (id subdata in subdataList) {
                if(kFoundationProperty(subdata)){
                    [subdataListM addObject:[self.modelClass package2Model:subdata]];
                }else {
                    [subdataListM addObject:subdata];
                }
            }
            [dataListM addObject:[subdataListM copy]];
        }
    }
    _dataList = [dataListM copy];
}

- (JXCollectionViewDataSourceType)dataSourceTypeWithDataList:(NSArray *)dataList {
    _sourceType = JXCollectionViewDataSourceTypeSingle;
    if (kTypecheck == kStrict) {
        for (id subList in dataList) {
            if ([subList isKindOfClass:[NSArray class]]) {
                _sourceType = JXCollectionViewDataSourceTypeMulti;
                break;
            }
        }
    }else if(kTypecheck == kSlack) {
        if ([dataList.firstObject isKindOfClass:[NSArray class]]) {
            _sourceType = JXCollectionViewDataSourceTypeMulti;
        }
    }
    
    return _sourceType;
}

@end
