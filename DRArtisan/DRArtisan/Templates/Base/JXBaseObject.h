//
//  JXBaseObject.h
//  DRArtisan
//
//  Created by Jason on 7/9/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JXBaseObjectDelegate <NSObject>

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
 *          @{
 *            @"title_id":@"id", // client:server
 *            @"title":@"title",
 *            @"icon":@"icon"
 *          };
 *
 *  @return a dictioanry which describle the releative server properites with client properties
 */
- (NSDictionary *)mapper;

/**
 *  the properties which need map
 *
 *  @return need map properties array
 *  当对象属性很多,但只想映射部分属性时
 *
 */
- (NSArray *)whitelist;

/**
 *  the properties which need not map
 *
 *  @return need not map properteis array
 */
- (NSArray *)blacklist;

@end



/**
 *  Base Model
 *  Requires the following
 *      When the server can provide the client is not the same field of KVC capacity   OK
 *      Just Returns need to map attributes dictionary                                 OK
 *      Recursive call
 *      To a certain extent compatible with the type
 */
@interface JXBaseObject : NSObject <JXBaseObjectDelegate>

/// 简单数据类型的对象化
// ============================================
/// 数据源为字符串数组时,进行的包装
@property (nonatomic,copy) NSString *b_string;

/// 数据源为NSNumber数组时,进行的包装
@property (nonatomic,strong) NSNumber *b_number;

// =============================================

/**
 *  字典转模型方法
 */
+ (instancetype)modelWithDic:(NSDictionary *)dic;

/**
 *  字典数组转模型数组的方法
 *
 *  @param dics Array of NSDictionary object
 *
 *  @return array of model object
 */
+ (NSArray *)modelsWithDics:(NSArray *)dics;

/**
 *  Exchange method
 *
 *  @param cls              Which class
 *  @param originalSelector 类的原始方法的Sel指针
 *  @param swizzledSelector 类的目标方法的Sel指针
 */
+ (void)hookMethod:(Class)cls OriginSelector:(SEL)originalSelector SwizzledSelector:(SEL)swizzledSelector;


+ (instancetype)package2Model:(id)data;

@end

#warning 感觉需要修改
@interface JXBaseObject (JXTableView)

/**
 *  Calculate cell height
 *
 *  @return cell height
 */
- (CGFloat)calculateHeight;

/**
 *  Set cell height
 *
 *  @param height cell height
 */
- (void)injectedHeight:(CGFloat)height;

@end

@interface JXBaseObject (JXCollectionView)

/**
 *  The height about Cell which is in CollectionView
 *
 *  @param itemWidth cell width
 *  @param indexPath cell location
 *
 *  @return cell height
 *
 */
- (CGFloat)calculateHeightWithItemWidth:(CGFloat)itemWidth indexPath:(NSIndexPath *)indexPath;

/**
 *  The width about Cell which is in CollectionView
 *
 *  @param itemHeight cell height
 *  @param indexPath  cell location
 *
 *  @return cell width
 */
- (CGFloat)calculateWidthWithItemHeight:(CGFloat)itemHeight indexPath:(NSIndexPath *)indexPath;

@end
