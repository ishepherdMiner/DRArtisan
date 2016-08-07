//
//  BaseTableView.h
//  DRArtisan
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "AbstractBaseTableView.h"

/// 自定义的UITableView class的子类类型
typedef NS_ENUM(NSUInteger,XCTableViewClassType){
    XCTableViewClassTypeBase,           // 基础的UITableView,可以快速创建系统的cell
    XCTableViewClassTypeFlexibleHeight, // cell的高度可变化的View
    XCTableViewClassTypeAllTitle,       // 头视图与尾视图的都为Title
    XCTableViewClassTypeAllView,        // 头视图与尾视图的都为UIView
    XCTableViewClassTypeHeaderTitleMix, // 头视图为Title
    XCTableViewClassTypeHeaderViewMix,  // 头视图为UIView
};

/// 数据源的状态
typedef NS_ENUM(NSUInteger,XCTableViewDataSourceType){
    XCTableViewDataSourceTypeUnassigned,// 未赋值
    XCTableViewDataSourceTypeSingle,    // 数据源为一维数组
    XCTableViewDataSourceTypeMulti,     // 数据源为二维数组
};

@interface BaseTableView : AbstractBaseTableView

/// 数据源状态
@property (nonatomic,assign,readonly) XCTableViewDataSourceType sourceType;

/// Every section header title
@property (nonatomic,strong) NSArray *headerTitles;

/// Every section footer title
@property (nonatomic,strong) NSArray *footerTitles;

/// Every section header height
@property (nonatomic,strong) NSArray *headerHeights;

/// Every section footer height
@property (nonatomic,strong) NSArray *footerHeights;

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

@end
