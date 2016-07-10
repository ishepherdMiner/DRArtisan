//
//  BaseObject.h
//  DRArtisan
//
//  Created by Jason on 7/9/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseObjectProtocol <NSObject>

@optional

/**
 *  the server properties map to client properties
 *
 *  Demo
 *
 *  Client @{
 *            title_id:@"xxxx",
 *            @"title":@"xxx",
 *            @"icon":@"xxxx"
 *          }
 *
 *  Server @{
 *            @"id":@"xxx",
 *            @"title":@"xxx",
 *            @"icon":@"xxx"
 *          }
 *
 *
 *  @return a dictioanry which describle the releative server properites with client properties
 */
- (NSDictionary *)mapperProperties;

/**
 *  the properties which need map
 *
 *  @return need map properties array
 *  当对象属性很多,但只想映射部分属性时
 *
 */
- (NSArray *)whitePropertiesList;

/**
 *  the properties which need not map
 *
 *  @return need not map properteis array
 */
- (NSArray *)blackPropertiesList;

@end

/**
 *  Base Model
 *  Requires the following
 *      When the server can provide the client is not the same field of KVC capacity   OK
 *      Just Returns need to map attributes dictionary                                 OK
 *      3.能实现递归性质的调用
 *      4.对类型不符时有一定兼容能力
 */
@interface BaseObject : NSObject <BaseObjectProtocol>

/**
 *  字典转模型方法
 */
+ (instancetype)objWithDic:(NSDictionary *)dict;


@end