//
//  NSFileManager+JACoder.h
//  Summary
//
//  Created by Jason on 08/06/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (JACoder)

/// .../sandbox/Document
- (NSString *)documentOfPath;

/// .../sandbox/Library
- (NSString *)libraryOfPath;

/// .../sandbox/Library/Cache
- (NSString *)cacheOfPath;

/// .../sandbox/tmp
- (NSString *)tmpOfPath;

/// .../sandbox/Library/Documentation
- (NSString *)documentationOfPath;


/**
 追加文件路径格式的路径,主要是自动追加分隔符

 @param filePath 文件或文件夹名
 @param directory 文件夹
 @return 文件路径
 */
- (NSString *)appendFilePathFormat:(NSString *)filePath
                         directory:(NSString *)directory;

/// 在docuement文件夹下创建文件夹，若已存在，则返回路径
- (NSString *)createDirectoryAtDocumentWithName:(NSString *)name;
- (NSString *)createDirectoryAtCacheWithName:(NSString *)name;

@end
