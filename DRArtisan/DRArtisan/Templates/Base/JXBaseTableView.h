//
//  BaseTableView.h
//  DRArtisan
//
//  Created by Jason on 7/11/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXAbstractBaseTableView.h"

/// 自定义的UITableView class的子类类型
typedef NS_ENUM(NSUInteger,JXTableViewClassType){
    JXTableViewClassTypeBase,           // 基础的UITableView,可以快速创建系统的cell
    JXTableViewClassTypeFlexibleHeight, // cell的高度可变化的View
    JXTableViewClassTypeAllTitle,       // 头视图与尾视图的都为Title
    JXTableViewClassTypeAllView,        // 头视图与尾视图的都为UIView
    JXTableViewClassTypeHeaderTitleMix, // 头视图为Title
    JXTableViewClassTypeHeaderViewMix,  // 头视图为UIView
    JXTableViewClassTypeCustomer = 99,  // 自定义UITableView
};

/// 数据源的状态
typedef NS_ENUM(NSUInteger,JXTableViewDataSourceType){
    JXTableViewDataSourceTypeUnassigned,// 未赋值
    JXTableViewDataSourceTypeSingle,    // 数据源为一维数组
    JXTableViewDataSourceTypeMulti,     // 数据源为二维数组
};

@interface JXBaseTableView : JXAbstractBaseTableView

/// 数据源状态
@property (nonatomic,assign,readonly) JXTableViewDataSourceType sourceType;

/// Every section header title
@property (nonatomic,strong) NSArray *headerTitles;

/// Every section footer title
@property (nonatomic,strong) NSArray *footerTitles;

/// Every section header height
@property (nonatomic,strong) NSArray *headerHeights;

/// Every section footer height
@property (nonatomic,strong) NSArray *footerHeights;

/**
 *  Custom UITableView
 *
 *  @param frame TableView frame
 *  @param style TableView style
 *
 *  @return a BaseTableView object
 */
+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style;
/**
 *  Create a BaseTableView class cluster object
 *
 *  @param frame     TableView frame
 *  @param style     TableView style
 *  @param classType Designation JXBaseTableView subclass
 *
 *  @return a BaseTableView object
 */
+ (instancetype)tableViewWithFrame:(CGRect)frame
                             style:(UITableViewStyle)style
                         classType:(JXTableViewClassType)classType;

@end
