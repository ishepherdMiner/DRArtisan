//
//  BaseTableView.h
//  DRArtisan
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "AbstractBaseTableView.h"

typedef NS_ENUM(NSUInteger,XCTableViewClassType){
    XCTableViewClassTypeBase,
    XCTableViewClassTypeFlexibleHeight,
    XCTableViewClassTypeSupplementaryTitle,
    XCTableViewClassTypeSupplementaryView,
    XCTableViewClassTypeSupplementaryHeaderTitle,
    XCTableViewClassTypeSupplementaryHeaderView,
};

typedef NS_ENUM(NSUInteger,XCTableViewDataSourceType){
    XCTableViewDataSourceTypeUnassigned,
    XCTableViewDataSourceTypeSingle,
    XCTableViewDataSourceTypeMulti,
};

@interface BaseTableView : AbstractBaseTableView

/**
 *  数据源:
 *      一维数组(XCTableViewDataSourceTypeSingle)
 *      二维数组(XCTableViewDataSourceTypeMulti)
 *      初始值(XCTableViewDataSourceTypeUnassigned)
 */
@property (nonatomic,assign,readonly) XCTableViewDataSourceType sourceType;

/// Every section header title
@property (nonatomic,strong,readonly) NSArray *headerTitles;

/// Every section footer title
@property (nonatomic,strong,readonly) NSArray *footerTitles;

/// Every section header height
@property (nonatomic,strong,readonly) NSArray *headerHeights;

/// Every section footer height
@property (nonatomic,strong,readonly) NSArray *footerHeights;

/**
 *  Create a BaseTableView class cluster object
 *
 *  @param frame     TableView frame
 *  @param style     TableView style
 *  @param classType Designation BaseTableView subclass
 *
 *  @return a BaseTableView object
 */
+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                         classType:(XCTableViewClassType)classType;


- (void)titleWithSectionHeader:(NSArray *)headerTitles sectionFooter:(NSArray *)footerTitles;

- (void)heightWithSectionHeader:(NSArray *)headerHeights sectionFooter:(NSArray *)footerHeights;

@end
