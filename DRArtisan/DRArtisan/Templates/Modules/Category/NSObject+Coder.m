//
//  NSObject+Coder.m
//
//  Copyright (c) 2015年 coder. All rights reserved.
//

#import "NSObject+Coder.h"
#import <objc/runtime.h>

#define kFoundationProperty(property)   ([property isKindOfClass:[NSNumber class]]  \
|| [property isKindOfClass:[NSValue class]]   \
|| [property isKindOfClass:[NSString class]]) \
|| [property isKindOfClass:[NSDate class]]    \
|| [property isKindOfClass:[NSData class]]

#define kCollectionProperty(property)   ([property isKindOfClass:[NSArray class]]      \
|| [property isKindOfClass:[NSDictionary class]] \
|| [property isKindOfClass:[NSSet class]])

@implementation NSObject (Coder)

const char* propertiesKey = "md5(bundleId)_propertiesKey";

+ (instancetype)objWithDic:(NSDictionary *)dic {
    
    id obj = [[self alloc] init];
    
    NSArray *propertyList = [self jas_propertyList];
    
    NSMutableDictionary *propertyDic = [NSMutableDictionary dictionaryWithCapacity:[propertyList  count]];
    
    // the Foundation class type solve step
    if (kFoundationProperty(obj)) {
        return obj = dic;
    }
    
    if (kCollectionProperty(obj)) {
        for (id element in obj) {
            [element objWithDic:element];
        }
    }
    
    
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
                [propertyDic setValue:dic[mapResult] forKey:property];
            }else {
                //  the class property not map but in property list
                if ([propertyList indexOfObject:property] != NSNotFound) {
                    [propertyDic setObject:dic[property] forKey:property];
                }else {
#if DEBUG
                    // the class property not in model which is from server
                    JasLog(@"the %@ property %@ not in model wihich is from server.",obj,property);
#endif
                }
            }
        }
        for (NSString *property in propertyList) {
            if ([propertyDic objectForKey:property]) {
                JasLog(@"value = %@, key = %@",[propertyDic objectForKey:property],property);
                [obj setValue:[propertyDic objectForKey:property] forKeyPath:property];
            }
        }
    }else {
        // Not implement mapperProperties
        for (NSString *property in propertyList) {
            id mapResult = [dic objectForKey:property];
            if(mapResult){
                [obj setValue:mapResult forKey:property];
            }
        }
    }
    
#pragma clang diagnostic pop
    
    return obj;
}

+ (NSArray *)jas_propertyList {
    
    // 0. 判断是否存在关联对象，如果存在，直接返回
    /**
        1> 关联到的对象
        2> 关联的属性 key
     */
    NSArray *pList = objc_getAssociatedObject(self, propertiesKey);
    if (pList != nil) {
        return pList;
    }
    
    // 1. 获取`类`的属性
    /**
        参数
            1 > 类
            2 > 属性的计数指针
     */
    unsigned int count = 0;
    // 返回值是所有属性的数组 objc_property_t
    objc_property_t *list = class_copyPropertyList([self class], &count);
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:count];
    
    // 遍历数组
    for (unsigned int i = 0; i < count; ++i) {
        // 获取到属性
        objc_property_t pty = list[i];
        
        // 获取属性的名称
        const char *cname = property_getName(pty);
        
        [arrayM addObject:[NSString stringWithUTF8String:cname]];
    }
    // NSLog(@"%@", arrayM);
    
    // 释放属性数组
    free(list);
    
    // 设置关联对象
    /**
        1 > 关联的对象
        2 > 关联对象的 key
        3 > 属性数值
        4 > 属性的持有方式 reatin, copy, assign
     */
    objc_setAssociatedObject(self, propertiesKey, arrayM, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return arrayM.copy;
}

+ (void)jas_methodList:(Class )cls {
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
    
    printf("Found %d methods on '%s'\n", methodCount, class_getName(cls));
    
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        
        printf("\t'%s'|'%s' of encoding '%s'\n",
               class_getName(cls),
               sel_getName(method_getName(method)),
               method_getTypeEncoding(method));
        
        /**
         *  Or do whatever you need here...
         */
    }
    
    free(methods);
}


@end
