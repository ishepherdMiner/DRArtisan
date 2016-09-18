//
//  BaseTableView.m
//  DRArtisan
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXGlobal.h"
#import "JXSwitch.h"
#import "JXClasses.h"

@interface JXBaseTableView ()

@property (nonatomic,assign) JXTableViewDataSourceType sourceType;

@end

@implementation JXBaseTableView

+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style {
    
    return [self tableViewWithFrame:frame
                              style:style
                          classType:JXTableViewClassTypeCustomer];
}


+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                         classType:(JXTableViewClassType)classType {
    
    JXBaseTableView *obj =  nil;
    
    switch (classType) {
        case JXTableViewClassTypeBase:{
            obj = [[JXBaseTableView alloc] initWithFrame:frame style:style];
        }
            break;
        case JXTableViewClassTypeFlexibleHeight:{
            obj = [[JXFlexibleHeightTableView alloc] initWithFrame:frame style:style];
        }
            break;
        case JXTableViewClassTypeAllTitle:{
            obj = [[JXSupplementaryTitleTableView alloc] initWithFrame:frame style:style];
        }
            break;
        case JXTableViewClassTypeAllView:{
            obj = [[JXSupplementaryViewTableView alloc] initWithFrame:frame style:style];
        }
            break;
        case JXTableViewClassTypeHeaderTitleMix:{
            obj = [[JXSupplementaryHeaderTitleMix alloc] initWithFrame:frame style:style];
        }
            break;
        case JXTableViewClassTypeHeaderViewMix:{
            obj = [[JXSupplementaryHeaderViewMix alloc] initWithFrame:frame style:style];
        }
            break;
        case JXTableViewClassTypeCustomer:{
            obj = [[self alloc] initWithFrame:frame style:style];
        }
            break;
        default:{
            obj = [[JXBaseTableView alloc] initWithFrame:frame style:style];
        }
            break;
    }
    
    obj.customSetter = true;
    
    return obj;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // when datasource not require from servers
    if (_dataList == nil) { return kOne; }
    
    NSAssert([_dataList isKindOfClass:[NSArray class]], @"The dataList property must be an array class.");
    
    // don't call setDataList: but set value for dataList property
    if (_sourceType == JXTableViewDataSourceTypeUnassigned) {
        _sourceType = [self dataSourceTypeWithDataList:_dataList];
    }
    
    return _sourceType == JXTableViewDataSourceTypeSingle ?
        [super numberOfSectionsInTableView:tableView] : [self.dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataList == nil) { return kZero; }
    
    // In - numberOfSectionInTableView: method already check the validity of _dataList
    return _sourceType == JXTableViewDataSourceTypeSingle ?
        [super tableView:tableView numberOfRowsInSection:section] : [self.dataList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Why not set kvo in cell
    //    // It won't work because the cells are being reused. So when the cell goes off the screen it's not deallocated, it goes to reuse pool.
    //    // You shouldn't register notifications and KVO in cell. You should do it in table view controller instead and when the model changes you should update model and reload visible cells.
    //    // http://stackoverflow.com/questions/25056942/instance-was-deallocated-while-key-value-observers-were-still-registered-with-it

    JXBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.identifier];
    if (cell == nil) {
        cell = [[[[self cellClass] class] alloc] initWithStyle:self.cellStyle
                                               reuseIdentifier:self.identifier];
        JXLog(@"cell reuse => %zd",self.reuseCount++);
    }
    
    if(_sourceType == JXTableViewDataSourceTypeSingle) {
        [cell injectedModel:self.dataList[indexPath.row]];
    }else {
        [cell injectedModel:self.dataList[indexPath.section][indexPath.row]];
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
    
    // If you extends JXBaseTableView and you can implement tableView:didSelectRowAtIndexPath: action event
    JXLog(@"You can implement tableView:didSelectRowAtIndexPath: in class which is extends JXBaseTableView.");
    
}

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    
    // if set dataList by call setDataList:
    if (_sourceType == JXTableViewDataSourceTypeUnassigned) {
        _sourceType = [self dataSourceTypeWithDataList:dataList];
    }
    
    if (self.customSetter == false) { return; }
    
    // Need Custom implement setter dataList
    NSMutableArray *dataListM = [NSMutableArray arrayWithCapacity:[dataList count]];
    if (_sourceType == JXTableViewDataSourceTypeSingle) {
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


- (JXTableViewDataSourceType)dataSourceTypeWithDataList:(NSArray *)dataList {
    _sourceType = JXTableViewDataSourceTypeSingle;
    
    for (id subList in dataList) {
        if ([subList isKindOfClass:[NSArray class]]) {
            _sourceType = JXTableViewDataSourceTypeMulti;
            break;
        }
    }
    
    return _sourceType;
}

@end
