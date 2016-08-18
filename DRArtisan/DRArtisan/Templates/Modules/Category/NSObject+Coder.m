//
//  NSObject+Coder.m
//
//  Copyright (c) 2015年 coder. All rights reserved.
//

#import "NSObject+Coder.h"
#import <objc/runtime.h>

@interface LogDealloc : NSObject

@property (strong) NSString* message;

@end

@implementation NSObject (Coder)

const char* propertiesKey = "md5(bundleId)_propertiesKey";

+ (NSArray *)jx_propertyList {
    
    // 0. 判断是否存在关联对象，如果存在，直接返回
    /**
        1 关联到的对象
        2 关联的属性key
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
    JXLog(@"%@", arrayM);
    
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

static char __logDeallocAssociatedKey__;
- (void)jx_logDealloc{
    if( objc_getAssociatedObject( self, &__logDeallocAssociatedKey__ ) == nil ) {
        LogDealloc* log = [[LogDealloc alloc] init];
        log.message = NSStringFromClass( self.class );
        objc_setAssociatedObject( self, &__logDeallocAssociatedKey__, log, OBJC_ASSOCIATION_RETAIN);
    }
}

- (NSString *)jas_autoDescription{
    return [NSString stringWithFormat:@"<%@: %p; %@>", NSStringFromClass([self class]), self, [self keyValueAutoDescription]];
}

- (NSString *)keyValueAutoDescription{
    NSMutableString *result = [NSMutableString string];
    
    dispatch_queue_t currentQueue = dispatch_get_current_queue();
    
    id associatedObject = objc_getAssociatedObject(self, (__bridge const void *)(currentQueue));
    if (associatedObject) {
        return @"(self)";
    }
    
    objc_setAssociatedObject(self, (__bridge const void *)(currentQueue), result, OBJC_ASSOCIATION_RETAIN);
    
    Class currentClass = [self class];
    while (currentClass != [NSObject class]) {
        unsigned int propertyListCount = 0;
        objc_property_t *propertyList = class_copyPropertyList(currentClass, &propertyListCount);
        for (int i = 0; i < propertyListCount; i++) {
            const char *property_name = property_getName(propertyList[i]);
            NSString *propertyName = [NSString stringWithCString:property_name encoding:NSASCIIStringEncoding];
            
            if (propertyName) {
                id propertyValue = [self valueForKey:propertyName];
                if (i % 3 == 0) {
                    [result appendFormat:@"\n"];
                }
                [result appendFormat:@"%@ = %@; ", propertyName, [propertyValue jas_cleanDescription]];
            }
        }
        free(propertyList);
        currentClass = class_getSuperclass(currentClass);
    }
    NSUInteger length = [result length];
    if (length) {
        [result deleteCharactersInRange:NSMakeRange(length - 1, 1)];
    }
    
    objc_setAssociatedObject(self, (__bridge const void *)(currentQueue), nil, OBJC_ASSOCIATION_RETAIN);
    
    return result;
}


@end

@implementation NSObject (CleanDescription)

- (NSString *)jas_cleanDescription{
    NSString *result;
    result = [self description];
    return result;
}

@end

@implementation LogDealloc

- (void)dealloc{
    JXLog( @"dealloc: %@", self.message);
}

@end
