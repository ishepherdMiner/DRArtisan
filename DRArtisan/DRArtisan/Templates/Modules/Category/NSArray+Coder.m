//
//  NSArray+Coder.m
//  JoySummer
//
//  Created by ishpherdme on 24/4/15.
//  Copyright (c) 2015 WDL. All rights reserved.
//

#import "NSArray+Coder.h"

@implementation NSArray (Coder)
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

@end
