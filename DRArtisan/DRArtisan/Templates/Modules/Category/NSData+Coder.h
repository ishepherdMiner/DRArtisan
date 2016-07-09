//
//  NSData+Coder.h
//  JoySummer
//
//  Created by ishpherdme on 1/4/15.
//  Copyright (c) 2015年 ishpherdme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSData (Coder)

/**
 *  将文件写入指定路径
 *
 *  @param file     文件
 *  @param path     路径(默认是沙盒的document下)
 *  @param fileName 文件名
 */
+ (void)writeNewFileToPath:(id) file
                  WithPath:(NSString *)filePath
              WithFileName:(NSString *) fileName;
@end


@interface NSData (Deprecated)

@end
