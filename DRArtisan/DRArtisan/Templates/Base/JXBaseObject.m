//
//  JXBaseObject.m
//  DRArtisan
//
//  Created by Jason on 7/9/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "JXBaseObject.h"
#import <objc/message.h>

@interface JXBaseObject ()

@property (nonatomic,assign) CGFloat cellHeight;

@end

@implementation JXBaseObject

+ (NSArray *)modelsWithDics:(NSArray *)dics {
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:[dics count]];
    for (NSDictionary *dic in dics) {
        [models addObject:[self modelWithDic:dic]];
    }
    return models;
}

+ (instancetype)modelWithDic:(NSDictionary *)dic {
    
    id obj = [[self alloc] init];
    
    NSArray *propertyList = [self jas_propertyList];
    
    NSMutableDictionary *propertyDic = [NSMutableDictionary dictionaryWithCapacity:[propertyList  count]];
    
    // the Foundation class type solve step
    if (kFoundationProperty(obj)) {
        return obj = dic;
    }
    
    if (kCollectionProperty(obj)) {
        for (id element in obj) {
            [element modelWithDic:element];
        }
    }
    
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([obj respondsToSelector:@selector(whitelist)]) {
        propertyList = [obj whitelist];
    }
    
    if ([obj respondsToSelector:@selector(blacklist)]) {
        NSMutableArray *propertyListM = [NSMutableArray arrayWithArray:propertyList];
        for (id property in [obj blacklist]) {
            if ([propertyListM indexOfObject:property] != NSNotFound) {
                [propertyListM removeObject:property];
            }
        }
        propertyList = [propertyListM copy];
        
    }
    
    if ([obj respondsToSelector:@selector(mapper)]) {
        NSDictionary *mapDic = [obj performSelector:@selector(mapper)];
        for (NSString *property in propertyList) {
            id mapResult = [mapDic objectForKey:property];
            // the class property be mapped
            if(mapResult) {
                [propertyDic setValue:dic[mapResult] forKey:property];
            }else {
                
                // the class property not map but in property list
                // 1.Developer forget to map
                // 2.model property named is the same as server field
                if ([propertyList indexOfObject:property] != NSNotFound) {
                    [propertyDic setValue:dic[property] forKey:property];
                }else {
#if DEBUG
                    // the class property not in model which is from server
                    XcLog(@"the %@ property %@ not in model wihich is from server.",obj,property);
#endif
                }
            }
        }
        for (NSString *property in propertyList) {
            if ([propertyDic objectForKey:property]) {
                XcLog(@"value = %@, key = %@",[propertyDic objectForKey:property],property);
                [obj setValue:[propertyDic objectForKey:property] forKeyPath:property];
            }
        }
    }else {
        // Not implement mapping
        for (NSString *property in propertyList) {
            id mapResult = [dic objectForKey:property];
            if(mapResult){
                [obj setValue:mapResult forKey:property];
            }else {
                [obj setValue:[NSNull null] forKey:property];
            }
        }
    }
    
#pragma clang diagnostic pop
    
    return obj;
}

#pragma mark - DEBUG
+ (void)hookMethod:(Class)cls OriginSelector:(SEL)originalSelector SwizzledSelector:(SEL)swizzledSelector
{
    Method originalMethod = class_getInstanceMethod(cls, originalSelector); \
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector); \
    BOOL didAddMethod =
    class_addMethod(cls,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (instancetype)package2Model:(id)data {
    JXBaseObject *obj = [[self alloc] init];
    if ([data isKindOfClass:[NSString class]]) {
        obj.b_string = data;
    }else if([obj isKindOfClass:[NSNumber class]]){
        obj.b_number = data;
    }
    return obj;
}

- (void)dealloc {
    [self jx_logDealloc];
}
@end

@implementation JXBaseObject (JXTableView)

- (CGFloat)calculateHeight {
    return _cellHeight;
}

- (void)injectedHeight:(CGFloat)height {
    _cellHeight = height;
}

@end

@implementation JXBaseObject (JXCollectionView)

- (CGFloat)calculateHeightWithItemWidth:(CGFloat)itemWidth
                              indexPath:(NSIndexPath *)indexPath{
    
    AbstractMethodNotImplemented();
}

- (CGFloat)calculateWidthWithItemHeight:(CGFloat)itemHeight
                              indexPath:(NSIndexPath *)indexPath {
    
    AbstractMethodNotImplemented();
}

@end
