//
//  NSString+JACoder.m
//  Daily_modules
//
//  Created by Jason on 09/01/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import "NSString+JACoder.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (JACoder)

- (const char *)ja_cString{
    const char *resultCString = NULL;
    if ([self canBeConvertedToEncoding:NSUTF8StringEncoding]) {
        resultCString = [self cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    return resultCString;
}

- (NSString *)ja_ocString:(const char*)cString {
    return [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
}

- (NSString *)stringWithBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    
    return [strM copy];
}

- (NSString *)ja_trim{
    NSCharacterSet  *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (instancetype)ja_accuracyDigital:(NSUInteger)pos {
    // 找到小数点位置
    NSRange pointRange = [self rangeOfString:@"."];
    return [self substringToIndex:(pointRange.location + 1 + pos)];
}

+ (NSString *)ja_encodeToPercentEscapeString:(NSString *)input{
    
    // Encode all the reserved characters, per RFC 3986
    
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 90000
    
    NSCharacterSet *set = [NSCharacterSet URLHostAllowedCharacterSet];
    NSString *outputStr = [input stringByAddingPercentEncodingWithAllowedCharacters:set];
    
#else
    
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)input,
                                                              
                                                              NULL,
                                                              
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              
                                                              kCFStringEncodingUTF8));
#endif
    
    return outputStr;
}

+ (NSString *)ja_decodeToUrlString:(NSString *)input{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > 90000
    return [outputStr stringByRemovingPercentEncoding];
#else
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#endif
}

- (CGSize)ja_singleLineWithFont:(UIFont *)font {
    
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, font.pointSize)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    
    return textRect.size;
}

- (CGSize)ja_multiLineWithFont:(UIFont *)font
                withinWidth:(CGFloat)width {
    
    return [self ja_multiLineWithFont:font
                          withinWidth:width
                              options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading];
}

- (CGSize)ja_multiLineWithFont:(UIFont *)font
                withinWidth:(CGFloat)width
                    options:(NSStringDrawingOptions)options {
    
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:options
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    
    return textRect.size;
    
}

- (NSAttributedString *)ja_matchWithRegex:(NSString *)regex
                                 attrs:(NSDictionary *)attrs{
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:self];
    // NSString *regex = @"[0-9.]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    for (int i = 0; i < self.length; ++i) {
        NSString *tmp = [self substringWithRange:NSMakeRange(i, 1)];
        if ([pred evaluateWithObject:tmp]) {
            // [hogan addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(i, 1)];
            [hogan addAttributes:attrs range:NSMakeRange(i, 1)];
        }
    }
    return hogan;
}

- (NSString *)ja_base64encode {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)ja_base64decode {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - 散列函数
- (NSString *)ja_md5String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringWithBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)ja_sha1String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)ja_sha256String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringWithBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)ja_sha512String {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    
    CC_SHA512(str, (CC_LONG)strlen(str), buffer);
    
    return [self stringWithBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - HMAC 散列函数
- (NSString *)ja_hmacMD5StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgMD5, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringWithBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)ja_hmacSHA1StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)ja_hmacSHA256StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringWithBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)ja_hmacSHA512StringWithKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA512, keyData, strlen(keyData), strData, strlen(strData), buffer);
    
    return [self stringWithBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

#pragma mark - 文件散列函数

#define FileHashDefaultChunkSizeForReadingData 4096

- (NSString *)ja_fileMD5Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_MD5_CTX hashCtx;
    CC_MD5_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_MD5_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(buffer, &hashCtx);
    
    return [self stringWithBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)ja_fileSHA1Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_SHA1_CTX hashCtx;
    CC_SHA1_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA1_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(buffer, &hashCtx);
    
    return [self stringWithBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)ja_fileSHA256Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_SHA256_CTX hashCtx;
    CC_SHA256_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA256_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(buffer, &hashCtx);
    
    return [self stringWithBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)ja_fileSHA512Hash {
    NSFileHandle *fp = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fp == nil) {
        return nil;
    }
    
    CC_SHA512_CTX hashCtx;
    CC_SHA512_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fp readDataOfLength:FileHashDefaultChunkSizeForReadingData];
            
            CC_SHA512_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            
            if (data.length == 0) {
                break;
            }
        }
    }
    [fp closeFile];
    
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512_Final(buffer, &hashCtx);
    
    return [self stringWithBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}


@end
