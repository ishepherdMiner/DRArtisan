//
//  NSFileManager+JACoder.m
//  Summary
//
//  Created by Jason on 08/06/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "NSFileManager+JACoder.h"

@implementation NSFileManager (JACoder)

/**
 *  获得用户沙盒的路径
 *
 *  @param type (NSSearchPathForDirectoriesInDomains 第二个默认传NSUserDomainMask)
 *
 *  @return 返回指定沙盒文件夹下的文件名列表
 */
- (NSArray *)directoryPathWithType:(NSSearchPathDirectory)type{
    return NSSearchPathForDirectoriesInDomains(type, NSUserDomainMask, YES);
}

- (NSString *)appendFilePathFormat:(NSString *)filePath
                         directory:(NSString *)directory {
    
    return [directory stringByAppendingPathComponent:filePath];
}

- (NSString *)createDirectoryAtDocumentWithName:(NSString *)name {
    NSString *directoryPath = nil;
    if (name) {
        directoryPath = [self appendFilePathFormat:name directory:[self documentOfPath]];
    }else {
        directoryPath = [self documentOfPath];
    }
    
    BOOL isDirectory = false;
    if ([self fileExistsAtPath:directoryPath isDirectory:&isDirectory]) {
        if (isDirectory) {
#if DEBUG
            NSLog(@"%@",@"[JA]:文件夹已存在");
#endif            
            return directoryPath;
        }
    }
    
    NSError *error = nil;
    BOOL r = [self createDirectoryAtPath:directoryPath withIntermediateDirectories:true attributes:nil error:&error];
#if DEBUG
    if (r) {
        NSLog(@"%@",@"[JA]:成功创建文件夹");
    }else if (error) {
        NSLog(@"%@",[NSString stringWithFormat:@"[JA]:创建失败[%@]",error]);
    }
    
#endif
    return directoryPath;
}

- (NSString *)createDirectoryAtCacheWithName:(NSString *)name {
    NSString *directoryPath = nil;
    if (name) {
        directoryPath = [self appendFilePathFormat:name directory:[self cacheOfPath]];
    }else {
        directoryPath = [self cacheOfPath];
    }
    
    NSError *error = nil;
    BOOL r = [self createDirectoryAtPath:directoryPath withIntermediateDirectories:true attributes:nil error:&error];
#if DEBUG
    if (r) {
        NSLog(@"%@",@"[JA]:成功创建文件夹");
    }else if (error) {
        NSLog(@"%@",[NSString stringWithFormat:@"[JA]:创建失败[%@]",error]);
    }
    
#endif
    return directoryPath;

}

- (NSString *)documentOfPath {
    return [[self directoryPathWithType:NSDocumentDirectory] objectAtIndex:0];
}

- (NSString *)libraryOfPath {
    return [[self directoryPathWithType:NSLibraryDirectory] objectAtIndex:0];
}

- (NSString *)cacheOfPath {
    return [[self directoryPathWithType:NSCachesDirectory] objectAtIndex:0];
}

- (NSString *)documentationOfPath {
    return [[self directoryPathWithType:NSDocumentDirectory] objectAtIndex:0];
}

- (NSString *)tmpOfPath {
    return NSTemporaryDirectory();
}

@end
