//
//  NSData+Coder.m
//  JoySummer
//
//  Created by ishpherdme on 1/4/15.
//  Copyright (c) 2015年 ishpherdme. All rights reserved.
//

#import "NSData+Coder.h"

@implementation NSData (Coder)

+ (void)writeNewFileToPath:(id)file
                   WithPath:(NSString *)filePath
               WithFileName:(NSString *) fileName{
    
    NSData *data = [[NSData alloc] init];
    if ([file isKindOfClass:[UIImage class]]) {
        data = UIImagePNGRepresentation((UIImage *)file);
    }
    
    // 如果filepath不为空,就按指定路径
    NSString *path = filePath == nil ? [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName] : [filePath stringByAppendingPathComponent:fileName];
    
    [data writeToFile:path atomically:YES];
}

@end
