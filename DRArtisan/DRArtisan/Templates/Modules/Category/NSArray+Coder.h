//
//  NSArray+Coder.h
//  JoySummer
//
//  Created by ishpherdme on 24/4/15.
//  Copyright (c) 2015 WDL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Coder)

/**
 *  根据文件路径 输出所有文件名
 *
 *  @param dirString 文件路径
 *
 *  @return 所有文件
 */
- (NSArray *)allFilesAtPath:(NSString*)dirString;

@end

@interface NSArray (Deprecated)

@end