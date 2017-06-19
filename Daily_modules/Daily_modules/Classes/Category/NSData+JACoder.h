//
//  NSData+JACoder.h
//  Summary
//
//  Created by Jason on 06/06/2017.
//  Copyright © 2017 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *
 还未测试
 NSString *key = @"my password";
 
 NSString *secret = @"text to encrypt";
 
 //加密
 
 NSData *plain = [secret dataUsingEncoding:NSUTF8StringEncoding];
 
 NSData *cipher = [plain AES256EncryptWithKey:key];
 
 NSLog(@"%@",[cipher newStringInBase64FromData]);
 
 printf("%s\n", [[cipher description] UTF8String]);
 
 NSLog(@"%@",[[NSString alloc] initWithData:cipher encoding:NSUTF8StringEncoding]);//打印出null,这是因为没有解密。
 
 //解密
 
 plain = [cipher AES256DecryptWithKey:key];
 
 printf("%s\n", [[plain description] UTF8String]);
 
 NSLog(@"%@",[[NSString alloc] initWithData:plain encoding:NSUTF8StringEncoding]);
 */
@interface NSData (JACoder)

- (NSData *)ja_AES256EncryptWithKey:(NSString *)key;   // 加密

- (NSData *)ja_AES256DecryptWithKey:(NSString *)key;   // 解密

- (NSString *)ja_newStringInBase64FromData;            // 追加base64编码

+ (NSString *)ja_base64encode:(NSString*)str;          // 同上base64编码

- (NSData *)convertHexStrToData:(NSString *)str;

@end
