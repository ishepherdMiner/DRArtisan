//
//  BaseTableView.m
//  DRArtisan
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseTableView.h"

#define kSlack      kZero
#define kStrict     kOne

@interface BaseTableView ()

@property (nonatomic,assign) XCTableViewDataSourceType sourceType;

/// Every section header title
@property (nonatomic,strong) NSArray *headerTitles;

/// Every section footer title
@property (nonatomic,strong) NSArray *footerTitles;

@property (nonatomic,strong) NSArray *headerHeights;
@property (nonatomic,strong) NSArray *footerHeights;

@end

@implementation BaseTableView

+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                         classType:(XCTableViewClassType)classType {
    
    BaseTableView *obj =  nil;
    
    switch (classType) {
        case XCTableViewClassTypeBase:{
            obj = [[BaseTableView alloc] initWithFrame:frame style:style];
        }
            break;
        case XCTableViewClassTypeFlexibleHeight:{
            obj = [[FlexibleHeightTableView alloc] initWithFrame:frame style:style];
        }
            break;
        case XCTableViewClassTypeSupplementaryTitle:{
            obj = [[SupplementaryTitleTableView alloc] initWithFrame:frame style:style];
        }
            break;
        case XCTableViewClassTypeSupplementaryView:{
            obj = [[SupplementaryViewTableView alloc] initWithFrame:frame style:style];
        }
            break;
        case XCTableViewClassTypeSupplementaryHeaderTitle:{
            obj = [[SupplementaryHeaderTitleMix alloc] initWithFrame:frame style:style];
        }
            break;
        case XCTableViewClassTypeSupplementaryHeaderView:{
            obj = [[SupplementaryHeaderViewMix alloc] initWithFrame:frame style:style];
        }
            break;
        default:{
            obj = [[BaseTableView alloc] initWithFrame:frame style:style];
        }
            break;
    }
    
    obj.customSetter = true;
    
    return obj;
}

- (void)titleWithSectionHeader:(NSArray *)headerTitles sectionFooter:(NSArray *)footerTitles {
    self.headerTitles = headerTitles;
    self.footerTitles = footerTitles;
}

- (void)heightWithSectionHeader:(NSArray *)headerHeights sectionFooter:(NSArray *)footerHeights {
    self.headerHeights = headerHeights;
    self.footerHeights = footerHeights;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // when datasource not require from servers
    if (_dataList == nil) { return kOne; }
    
    NSAssert([_dataList isKindOfClass:[NSArray class]], @"The dataList property must be an array class.");
    
    // don't call setDataList: but set value for dataList property
    if (_sourceType == XCTableViewDataSourceTypeUnassigned) {
        _sourceType = [self dataSourceTypeWithDataList:_dataList];
    }
    
    return _sourceType == XCTableViewDataSourceTypeSingle ?
        [super numberOfSectionsInTableView:tableView] : [self.dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataList == nil) { return kZero; }
    
    // In - numberOfSectionInTableView: method already check the validity of _dataList
    return _sourceType == XCTableViewDataSourceTypeSingle ?
        [super tableView:tableView numberOfRowsInSection:section] : [self.dataList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    if (cell == nil) {
        cell = [[[[self cellClass] class] alloc] initWithStyle:self.cellStyle
                                               reuseIdentifier:self.identifier];
        XcLog(@"cell reuse => %zd",self.reuseCount++);
    }
    
    if(_sourceType == XCTableViewDataSourceTypeSingle) {
        cell.model = self.dataList[indexPath.row];
    }else {
        cell.model = self.dataList[indexPath.section][indexPath.row];
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // If you want to do anything like before,your viewcontroller should become cdelegate
    if(self.cdelegate){
        if([self.cdelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            return [self.cdelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
    
    // If you just want to write click cell in viewcontroller,your viewcontroller should become sdelegate
    if (self.sdelegate) {
        if ([self.sdelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
            return [self.sdelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
    
    // If you extends BaseTableView and you can implement tableView:didSelectRowAtIndexPath: action event
    XcLog(@"You can implement tableView:didSelectRowAtIndexPath: in class which is extends BaseTableView.");
    
}

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    
    // if set dataList by call setDataList:
    if (_sourceType == XCTableViewDataSourceTypeUnassigned) {
        _sourceType = [self dataSourceTypeWithDataList:dataList];
    }
    
    if (self.customSetter == false) { return; }
    
    // Need Custom implement setter dataList
    NSMutableArray *dataListM = [NSMutableArray arrayWithCapacity:[dataList count]];
    if (_sourceType == XCTableViewDataSourceTypeSingle) {
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


- (XCTableViewDataSourceType)dataSourceTypeWithDataList:(NSArray *)dataList {
    _sourceType = XCTableViewDataSourceTypeSingle;
    if (kTypecheck == kStrict) {
        for (id subList in dataList) {
            if ([subList isKindOfClass:[NSArray class]]) {
                _sourceType = XCTableViewDataSourceTypeMulti;
                break;
            }
        }
    }else if(kTypecheck == kSlack) {
        if ([dataList.firstObject isKindOfClass:[NSArray class]]) {
            _sourceType = XCTableViewDataSourceTypeMulti;
        }
    }
    
    return _sourceType;
}

@end
