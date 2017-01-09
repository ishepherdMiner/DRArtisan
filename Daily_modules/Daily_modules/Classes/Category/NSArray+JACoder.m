//
//  NSArray+JACoder.m
//  Daily_modules
//
//  Created by Jason on 09/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "NSArray+JACoder.h"

@implementation NSArray (JACoder)
- (NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // 遍历数组
        [strM appendString:[NSString stringWithFormat:@"\t%@,\n",obj]];
    }];
    [strM appendString:@")"];
    return strM;
}

- (NSArray *)allFilesAtPath:(NSString*)dirString {
    
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    for (NSString* fileName in tempArray) {
        BOOL flag = YES;
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [array addObject:fullPath];
            }else {
                [self allFilesAtPath:fullPath];
            }
        }
    }
    return array;
}

- (NSArray *)interSet:(NSArray *)listB {
    NSArray *listA = self;
    NSMutableArray *listC = [NSMutableArray arrayWithCapacity:[listB count] + [listA count]];
    for (id obj  in listB) {
        if ([listA indexOfObject:obj] != NSNotFound) {
            [listC addObject:obj];
        }
    }
    return [listC copy];
}

- (NSArray *)unionSet:(NSArray *)listB {
    NSArray *listA = self;
    NSMutableArray *listC = [NSMutableArray arrayWithArray:listA];
    for (id obj in listB) {
        if ([listA indexOfObject:obj] == NSNotFound) {
            [listC addObject:obj];
        }
    }
    return [listC copy];
}

- (NSArray *)differenceSet:(NSArray *)listB {
    NSArray *listA = self;
    NSMutableArray *listC = [NSMutableArray arrayWithArray:listA];
    for (id obj in listB) {
        // belong B Set && belong A Set,remove it
        if ([listA indexOfObject:obj] != NSNotFound) {
            [listC removeObject:obj];
        }
    }
    return [listC copy];
}

- (BOOL)isContains:(NSArray *)listB {
    NSArray *listA = self;
    for (id obj in listB) {
        if ([listA indexOfObject:obj] == NSNotFound) {
            return false;
        }
    }
    return true;
}

@end
