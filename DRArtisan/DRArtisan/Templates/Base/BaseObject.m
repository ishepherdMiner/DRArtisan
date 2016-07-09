//
//  BaseObject.m
//  DRArtisan
//
//  Created by Jason on 7/9/16.
//  Copyright © 2016 DR. All rights reserved.
//

#import "BaseObject.h"

#define kNativeProperty(property)  ([property isKindOfClass:[NSArray class]] \
                                || [property isKindOfClass:[NSDictionary class]] \
                                || [property isKindOfClass:[NSNumber class]] \
                                || [property isKindOfClass:[NSValue class]] \
                                || [property isKindOfClass:[NSString class]])

@implementation BaseObject

+ (instancetype)objectWithDict:(NSDictionary *)dict {
    
    id obj = [[self alloc] init];
    
    NSArray *propertyList = [self jas_propertyList];
    
    NSMutableDictionary *propertyDic = [NSMutableDictionary dictionaryWithCapacity:[propertyList  count]];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([obj respondsToSelector:@selector(whitePropertiesList)]) {
        propertyList = [obj whitePropertiesList];
    }
    
    if ([obj respondsToSelector:@selector(blackPropertiesList)]) {
        NSMutableArray *propertyListM = [NSMutableArray arrayWithArray:propertyList];
        for (id property in [obj blackPropertiesList]) {
            if ([propertyListM indexOfObject:property] != NSNotFound) {
                [propertyListM removeObject:property];
            }
        }
        propertyList = [propertyListM copy];
        
    }
    
    if ([obj respondsToSelector:@selector(mapperProperties)]) {
        NSDictionary *mapDic = [obj performSelector:@selector(mapperProperties)];
        for (NSString *property in propertyList) {
            id mapResult = [mapDic objectForKey:property];
            // the class property be mapped
            if(mapResult) {
                // when properyt exist in UIKit.framework(like NSString,NS
                if (kNativeProperty(dict[mapResult])) {
                    [propertyDic setObject:dict[mapResult] forKey:property];
                }else {
                    [[dict[mapResult] class] objectWithDict:dict[mapResult]];
                }
                
            }else {
                //  the class property not map but in property list
                if ([propertyList indexOfObject:property] != NSNotFound) {
                    [propertyDic setObject:dict[property] forKey:property];
                }else {
#if DEBUG
                    // the class property not in model which is from server
                    JasLog(@"the %@ property %@ not in model wihich is from server.",obj,property);
#endif
                }
            }
        }
    }
    
#pragma clang diagnostic pop
    
    for (NSString *property in propertyList) {
        if ([propertyDic objectForKey:property]) {
            JasLog(@"value = %@, key = %@",[propertyDic objectForKey:property],property);
            [obj setValue:[propertyDic objectForKey:property] forKeyPath:property];
        }
    }
    
    return obj;
}

- (NSString *)description {
    NSMutableString *descM = [NSMutableString stringWithFormat:@"<%@ %p>\n",self,self];
    for (NSString *property in [[self class] jas_propertyList]) {
        [descM appendString:[NSString stringWithFormat:@"%@ => %@",property,[self valueForKey:property]]];
    }
    return descM;
}
@end
