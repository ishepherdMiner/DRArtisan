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

@end

@interface AbstractBaseTableView : UITableView <BaseTableViewProtocol>{
    NSArray *_dataList;
}

@property (nonatomic,weak,readonly) Class cellClass;
@property (nonatomic,copy,readonly) NSString *identifier;
@property (nonatomic,strong) NSArray *dataList;
@property (nonatomic,weak) id<BaseTableViewProtocol> vcDelegate;

/// 为了快捷显示系统的UITableViewCell而设置的属性
@property (nonatomic,assign) UITableViewCellStyle cellStyle;

/// 使用类名做复用ID的注册方法
- (void)registerClass:(Class)cellClass;

@end
