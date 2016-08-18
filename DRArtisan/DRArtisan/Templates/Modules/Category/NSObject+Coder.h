//
//  NSObject+Coder.h
//
//  Copyright (c) 2015年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Coder)

// + (instancetype)modelWithDic:(NSDictionary *)dic;

/**
 *  返回类的属性列表
 */
+ (NSArray *)jas_propertyList;

/**
 *  返回类的方法列表
 *
 *  @param cls 类
 */
+ (void)jas_methodList:(Class )cls;

/**
 *  class释放时,进行输出提示,辅助内存泄露
 */
- (void)jx_logDealloc;

/*
    Copyright (c) 2013,
    Alexey Aleshkov <djmadcat@gmail.com; https://github.com/djmadcat/>
    All rights reserved.

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
             SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
    CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

- (NSString *)jas_autoDescription;


@end

@interface NSObject (CleanDescription)

- (NSString *)jas_cleanDescription;

@end


@interface NSObject (Deprecated)

@end
