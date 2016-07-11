//
//  BaseTableViewImpl.h
//  NormalCoder
//
//  Created by Jason on 7/7/16.
//  Copyright © 2016 JasCoder. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseTableViewProtocol <UITableViewDataSource,UITableViewDelegate>

@optional
/**
 *  Get the model location in tableview datasource
 *
 *  @param model which model object want to be located
 *
 *  @return an indexPath to describe model object location
 */
- (NSIndexPath *)locWithModel:(id)model;

/**
 *  Packing a foundation class to a JASBaseCellModel object,just for UITableViewCell at present
 *
 *  @param obj founcation class
 *
 *  @return a JASBaseCellModel object
 */
- (JASBaseCellModel *)packFoundationClass:(id)obj;
@end

@interface AbstractBaseTableView : UITableView <BaseTableViewProtocol>{
    NSArray *_dataList;
}

@property (nonatomic,weak,readonly) Class cellClass;
@property (nonatomic,copy,readonly) NSString *identifier;
@property (nonatomic,strong) NSArray *dataList;
@property (nonatomic,weak) id<BaseTableViewProtocol> vcDelegate;
@property (nonatomic,assign) BOOL customSetter;

/// 为了快捷显示系统的UITableViewCell而设置的属性
@property (nonatomic,assign) UITableViewCellStyle cellStyle;

/// 使用类名做复用ID的注册方法
- (void)registerClass:(Class)cellClass;

@end
