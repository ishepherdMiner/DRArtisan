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
 *      3.能实现递归性质的调用      还未实现
 *      4.对类型不符时有一定兼容能力 还未实现
 */
@interface BaseObject : NSObject <BaseObjectProtocol>

/**
 *  字典转模型方法
 */
+ (instancetype)modelWithDic:(NSDictionary *)dict;

+ (void)jas_test;

/**
 *  交换方法
 *
 *  @param cls              交换哪个类
 *  @param originalSelector 类的原始方法的Sel指针
 *  @param swizzledSelector 类的目标方法的Sel指针
 */
+ (void)hookMethod:(Class)cls OriginSelector:(SEL)originalSelector SwizzledSelector:(SEL)swizzledSelector;
@end
