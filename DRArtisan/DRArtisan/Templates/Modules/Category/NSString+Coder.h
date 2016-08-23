//
//  NSString+Coder.h
//  Unicode
//
//  Created by Jason on 4/2/16.
//  Copyright © 2016 Jason. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface NSString (Coder)

/**
 *  以Bytes形式创建字符串对象
 *
 *  @param bytes  二进制 Bytes 数组
 *  @param length 数组长度
 *
 *  @return 字符串表示形式
 */
- (NSString *)stringWithBytes:(uint8_t *)bytes length:(int)length;

/**
 *  返回服务器基本授权字符串
 *  示例代码格式如下：
 *  @code
 *  [request setValue:[@"admin:123456" basicAuthString] forHTTPHeaderField:@"Authorization"];
 *  @endcode
 */
- (NSString *)jas_basicAuthString;

/**
 *  OC字符串转换为C语言字符串
 *
 *  @return C语言字符串
 */
- (const char *)cString;

/**
 *  C语言字符串转换成OC字符串
 *
 *  @param cString c语言字符串
 *
 *  @return OC字符串
 */
- (NSString *)ocString:(const char*)cString;

/**
 *  去除字符串两端空格后的字符串
 *
 *  @return 去除字符串两端空格后的字符串
 */
- (NSString *)trim;

/**
 *  保留指定精度
 *
 *  @param value 要保留的小数点位数
 *
 *  @return double类型的数据
 */
- (instancetype)accuracyDigital:(NSUInteger)value;

@end

typedef NS_ENUM(NSUInteger,JXRegularDigitalType){
    JXRegularDigitalTypeDefault,  // 连续的第一个数字串
    JXRegularDigitalTypeLast,     // 连续的最后一个字符串
};

/*
 *  正则语法表
 *
 *  .     匹配除换行符外的任意字符
 *  \w    匹配字母或者数字的字符
 *  \W    匹配任意不是字母或数字的字符
 *  \s    匹配任意的空白符(空格、制表符、换行符)
 *  \S    匹配任意不是空白符的字符
 *  \d    匹配任意数字
 *  \D    匹配任意非数字的字符
 *  \b    匹配单词的结尾或者开头的字符
 *  \B    匹配任意不是单词结尾或开头的字符
 * [^x]   匹配任意非x的字符。如[^[a-z]]匹配非小写字母的任意字符
 *  ^     匹配字符串的开头
 *  $     匹配字符串的结尾
 *  *     匹配重复任意次数
 *  +     匹配重复一次以上的次数
 *  ?     匹配一次或零次
 *  {n}   匹配重复n次
 *  {n,}  匹配重复n次或n次以上
 *  {n,m} 匹配重复最少n次最多m次
 */

@interface NSString (Regular)

/**
 *  筛选出字符串中首个连接的数字
 *
 *  @return 返回被筛选出的数字
 */
- (instancetype)filterDigital:(JXRegularDigitalType)type;

/**
 *  正则匹配替换内容
 *
 *  @param oPattern     正则匹配的源字符串
 *  @param targetString 目标的字符串
 *
 *  @return 返回匹配处理后的字符串
 */
- (instancetype)replaceOrigin:(NSString *)oPattern targetString:(NSString *)targetString;

@end

@interface NSString (CleanDescription)

- (NSString *)cleanDescription;

@end

@interface NSString (file)

/// .../sandbox/Document
#define kDir_Doc [NSString dirPath:NSDocumentDirectory]
/// .../sandbox/Library
#define kDir_Lib [NSString dirPath:NSLibraryDirectory]
/// .../sandbox/Library/Cache
#define kDir_Cache [NSString dirPath:NSCachesDirectory]
/// .../sandbox/Library/Documentation
#define kDir_Documentation [NSString dirPath:NSDocumentationDirectory]
/// .../sandbox/tmp
#define kDir_Tmp NSTemporaryDirectory();

/**
 *  获得用户沙盒的路径
 *
 *  @param pathType (NSSearchPathForDirectoriesInDomains 第二个默认传NSUserDomainMask)
 *
 *  @return 返回沙盒文件夹路径
 */
+ (NSString *)dirPath:(NSSearchPathDirectory)pathType;

/**
 *  指定文件是否存在,如果只是判断存在性,可以用这个方法,只是简单的封装
 *
 *  @param path 文件路径
 *
 *  @return 该文件是否存在
 */
- (BOOL)fileIsExists;
@end

@interface NSString (url)

/**
 *  对网络请求的特殊字符进行编码
 *  
 *  @param input 要进行编码的网络请求的字符串
 *  
 *  @return 编码后的字符串
 *
 */
+ (NSString *)encodeToPercentEscapeString:(NSString *)input;

/**
 *  将已经编码后的特殊字符进行解码
 *
 *  @param input 要解码的字符串
 *
 *  @return 解码后的字符串
 */
+ (NSString *)decodeToUrlString:(NSString *)input;


@end

@interface NSString (frame)

/**
 *  单行文本 自适应内容
 *
 *  @param font 字体(默认是系统字体)
 *
 *  @return 文本尺寸
 */
- (CGSize)singleLineWithFont:(UIFont *)font;

/**
 *  多行文本 指定宽度 自适应内容
 *
 *  @param font  字体
 *  @param width 行宽
 *
 *  @return 文本尺寸
 */
- (CGSize)multiLineWithFont:(UIFont *)font
                withinWidth:(CGFloat)width;

/**
 *  多行文本 指定宽度 截取选项 自适应内容
 *
 *  @param font    字体
 *  @param width   行宽
 *  @param options 截取选项
 *
 *  @return 文本尺寸
 */
- (CGSize)multiLineWithFont:(UIFont *)font
                withinWidth:(CGFloat)width
                    options:(NSStringDrawingOptions)options;
@end

@interface NSString (encode)

/**
 *  返回base64编码的字符串内容
 */
- (NSString *)base64encode;

/**
 *  返回base64解码的字符串内容
 */
- (NSString *)base64decode;

/**
 *  计算MD5散列结果
 *
 *  终端测试命令：
 *  @code
 *  md5 -s "string"
 *  @endcode
 *
 *  @return 32个字符的MD5散列字符串
 */
- (NSString *)md5String;

/**
 *  计算SHA1散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha1
 *  @endcode
 *
 *  @return 40个字符的SHA1散列字符串
 */
- (NSString *)sha1String;

/**
 *  计算SHA256散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha256
 *  @endcode
 *
 *  @return 64个字符的SHA256散列字符串
 */
- (NSString *)sha256String;

/**
 *  计算SHA 512散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha512
 *  @endcode
 *
 *  @return 128个字符的SHA 512散列字符串
 */
- (NSString *)sha512String;

// Refer
// https://en.wikipedia.org/wiki/Hash-based_message_authentication_code
// http://baike.baidu.com/item/hmac
/**
 *  计算HMAC MD5散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl dgst -md5 -hmac "key"
 *  @endcode
 *
 *  @return 32个字符的HMAC MD5散列字符串
 */
- (NSString *)hmacMD5StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA1散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha1 -hmac "key"
 *  @endcode
 *
 *  @return 40个字符的HMAC SHA1散列字符串
 */
- (NSString *)hmacSHA1StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA256散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha256 -hmac "key"
 *  @endcode
 *
 *  @return 64个字符的HMAC SHA256散列字符串
 */
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;

/**
 *  计算HMAC SHA512散列结果
 *
 *  终端测试命令：
 *  @code
 *  echo -n "string" | openssl sha -sha512 -hmac "key"
 *  @endcode
 *
 *  @return 128个字符的HMAC SHA512散列字符串
 */
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

/**
 *  计算文件的MD5散列结果
 *
 *  终端测试命令：
 *  @code
 *  md5 file.dat
 *  @endcode
 *
 *  @return 32个字符的MD5散列字符串
 */
- (NSString *)fileMD5Hash;

/**
 *  计算文件的SHA1散列结果
 *
 *  终端测试命令：
 *  @code
 *  openssl sha -sha1 file.dat
 *  @endcode
 *
 *  @return 40个字符的SHA1散列字符串
 */
- (NSString *)fileSHA1Hash;

/**
 *  计算文件的SHA256散列结果
 *
 *  终端测试命令：
 *  @code
 *  openssl sha -sha256 file.dat
 *  @endcode
 *
 *  @return 64个字符的SHA256散列字符串
 */
- (NSString *)fileSHA256Hash;

/**
 *  计算文件的SHA512散列结果
 *
 *  终端测试命令：
 *  @code
 *  openssl sha -sha512 file.dat
 *  @endcode
 *
 *  @return 128个字符的SHA512散列字符串
 */
- (NSString *)fileSHA512Hash;

@end

@interface NSString (Deprecated)

@end
