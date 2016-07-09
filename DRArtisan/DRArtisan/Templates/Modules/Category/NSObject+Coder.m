//
//  NSObject+Coder.m
//
//  Copyright (c) 2015年 coder. All rights reserved.
//

#import "NSObject+Coder.h"
#import <objc/runtime.h>

@implementation NSObject (Coder)

const char* propertiesKey = "md5(bundleId)_propertiesKey";

+ (instancetype)objectWithDict:(NSDictionary *)dict {
    
    id obj = [[self alloc] init];
    
    NSArray *properties = [self jas_propertyList];
    
    // Is exist high prior custom map model?
//    if ([obj respondsToSelector:@selector(mapperModel)]) {
//        NSDictionary *propertyDic = [obj performSelector:@selector(modelMapper)];
//        NSMutableArray *propertiesM = [NSMutableArray arrayWithCapacity:[properties count]];
//        for(NSString *key in properties) {
//            if ([propertyDic objectForKey:key]) {
//                [propertiesM addObject:propertyDic[key]];
//            }
//        }
//        properties = [propertiesM copy];
//    }
    
    // 遍历属性数组
    for (NSString *key in properties) {
        // 判断字典中是否包含这个key
        if (dict[key] != nil) {
            // 使用 KVC 设置数值
            [obj setValue:dict[key] forKeyPath:key];
        }
    }
    
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