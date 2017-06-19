//
//  NSObject+JACoder.m
//  Daily_modules
//
//  Created by Jason on 09/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "NSObject+JACoder.h"
#import <objc/message.h>

@implementation NSObject (JACoder)

+ (void)ja_hookMethod:(Class)cls
       OriginSelector:(SEL)originSel
     SwizzledSelector:(SEL)swizzlSel
{
    Method originalMethod = class_getInstanceMethod(cls, originSel);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzlSel);
    BOOL didAddMethod =
    class_addMethod(cls,
                    originSel,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls,
                            swizzlSel,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

const void* propertiesKey = "com.coder.lldb-exclusive.propertiesKey";
const void* ivarKey = "com.coder.lldb-exclusive.ivarKey";
const void* methodKey = "com.coder.lldb-exclusive.methodKey";
const void* propertyAndEncodeTypeKey = "com.coder.lldb-excelusive.propertyAndEncodeTypeKey";

- (NSArray *)ja_propertyList:(BOOL)recursive {
    
    NSArray *glist = objc_getAssociatedObject([self class], propertiesKey);
    
    return glist == nil ? ^{
        
        unsigned int count = 0;
        NSMutableArray *plistM = [NSMutableArray arrayWithCapacity:count];
        
        Class cls = [self class];
        do {
            objc_property_t *list = class_copyPropertyList(cls, &count);
            for (int i = 0; i < count; ++i) {
                objc_property_t pty = list[i];
                const char *pname = property_getName(pty);
                [plistM addObject:[NSString stringWithUTF8String:pname]];
            }
            free(list);
            cls = [cls superclass];
        } while (cls && recursive);
        objc_setAssociatedObject([self class],propertiesKey, plistM, OBJC_ASSOCIATION_COPY_NONATOMIC);
        
#if DEBUG
        NSLog(@"[JA]:Found %ld properties on %@",(unsigned long)plistM.count,[self class]);
#endif
        
        return plistM.copy;
        
    }() : glist;
}

- (NSDictionary *)ja_propertyAndEncodeTypeList:(BOOL)recursive {
    
    NSDictionary *glist = objc_getAssociatedObject([self class], propertyAndEncodeTypeKey);
    
    return glist == nil ? ^{
        
        unsigned int count = 0;
        NSMutableDictionary *plistDicM = [NSMutableDictionary dictionaryWithCapacity:count];
        
        Class cls = [self class];
        do {
            objc_property_t *list = class_copyPropertyList(cls, &count);
            for (int i = 0; i < count; ++i) {
                objc_property_t pty = list[i];
                const char *pname = property_getName(pty);
                const char *pattr = property_getAttributes(pty);
                NSString *pname_utf8 = [NSString stringWithUTF8String:pname];
                NSString *pattr_utf8 = [NSString stringWithUTF8String:pattr];
                
                // https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
                if ([pattr_utf8 rangeOfString:@"NSString"].location != NSNotFound) {
                    pattr_utf8 = @"NSString";
                }else if ([pattr_utf8 rangeOfString:@"NSNumber"].location != NSNotFound) {
                    pattr_utf8 = @"NSNumber";
                }else if ([pattr_utf8 rangeOfString:@"TQ"].location != NSNotFound) {
                    pattr_utf8 = @"NSUInteger";
                }else if ([pattr_utf8 rangeOfString:@"NSArray"].location != NSNotFound) {
                    pattr_utf8 = @"NSArray";
                }
                
                // ...
                [plistDicM setObject:pattr_utf8 forKey:pname_utf8];
            }
            free(list);
            cls = [cls superclass];
        } while (cls && recursive);
        objc_setAssociatedObject([self class],propertyAndEncodeTypeKey, plistDicM, OBJC_ASSOCIATION_COPY_NONATOMIC);
        
#if DEBUG
        NSLog(@"[JA]:Found %ld properties on %@",(unsigned long)plistDicM.count,[self class]);
#endif
        
        return plistDicM.copy;
        
    }() : glist;
}


- (NSArray *)ja_ivarList:(BOOL)recursive{
    
    NSArray *glist = objc_getAssociatedObject([self class], ivarKey);
    
    return glist == nil ? ^{
        
        unsigned int count = 0;
        NSMutableArray *plistM = [NSMutableArray arrayWithCapacity:count];
        
        Class cls = [self class];
        do {
            Ivar *list = class_copyIvarList(cls, &count);
            for (int i = 0; i < count; ++i) {
                Ivar ity = list[i];
                const char *iname = ivar_getName(ity);
                [plistM addObject:[NSString stringWithUTF8String:iname]];
            }
            free(list);
            cls = [cls superclass];
        } while (cls && recursive);
        
        NSLog(@"Found %ld ivar on %@",(unsigned long)plistM.count,[self class]);
        objc_setAssociatedObject([self class],ivarKey, plistM, OBJC_ASSOCIATION_COPY_NONATOMIC);
        return plistM.copy;
        
    }() : glist;
}

- (NSArray *)ja_methodList:(BOOL)recursive {
    
    NSArray *glist = objc_getAssociatedObject([self class], methodKey);
    
    return glist == nil ? ^{
        
        unsigned int methodCount = 0;
        NSMutableArray *plistM = [NSMutableArray arrayWithCapacity:methodCount];
        
        Class cls = [self class];
        do {
            Method *methods = class_copyMethodList(cls, &methodCount);
            
            for (unsigned int i = 0; i < methodCount; i++) {
                Method method = methods[i];
                
                /*
                 printf("\t'%s'|'%s' of encoding '%s'\n",
                 class_getName(cls),
                 sel_getName(method_getName(method)),
                 method_getTypeEncoding(method));
                 */
                
                [plistM addObject:[NSString stringWithUTF8String:sel_getName(method_getName(method))]];
            }
            free(methods);
            cls = [cls superclass];
        }while (cls && recursive);
        printf("Found %d methods on '%s'\n", methodCount, class_getName([self class]));
        objc_setAssociatedObject([self class],ivarKey, plistM, OBJC_ASSOCIATION_COPY_NONATOMIC);
        
        return plistM.copy;
        
    }() : glist;
}

- (void)ja_cleanCacheList {
    objc_removeAssociatedObjects([self class]);
}

@end
