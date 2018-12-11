//
//  NSString+Public.h
//  VaktenUse
//
//  Created by iMac on 15/7/15.
//  Copyright (c) 2015年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Public)

+ (NSString *)generateSessionId;

//判断手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)checkInputCode:(NSString *)input regex:(NSString *)regex;
/*
 用kCFStringTransformMandarinLatin方法转化出来的是带音标的拼音，
 如果需要去掉音标，则继续使用kCFStringTransformStripCombiningMarks方法即可。
 */
+ (NSString *)chineseTransforToPinyi:(NSString *)chinese;
+ (CGFloat )getTextHeightWithString:(NSString *)string fontSize:(CGFloat )size textWidth:(CGFloat)width;
+ (CGFloat )getTextWidthWithString:(NSString *)string fontSize:(CGFloat )size textHeight:(CGFloat)height;
#pragma mark - 是否包含字符串
- (BOOL)isContainsString:(NSString *)searchString;

//比较版本号 如 2.0.0 和 1.0.5 返回 true
+ (BOOL)isHaveNewV:(NSString *)newV oldV:(NSString *)oldV;


#pragma mark -   二进制转十进制
+ (int)toDecimalSystemWithBinarySystem:(NSString *)binary;
#pragma mark -   十进制转二进制
+ (NSMutableArray *)toBinarySystemWithDecimalSystem:(int)decimal;

#pragma mark - 十六进制字符串转NSData 
+ (NSData*)hexStringToNSData:(NSString*)hexString;

#pragma mark - 十六进制字符串转long
+ (unsigned long)hexStrTolong:(NSString *)hexStr;

#pragma mark - 十六进制转字符 GBK编码
+ (NSString *)stringFromHexString:(NSString *)hexString;
//UTF8
+ (NSString *)hexStringToNSStringUTF8:(NSString *)hexString;
+ (NSString *)toSimpleStringWithData:(NSData *)data;

#pragma mark - data转十六进制字符串
+ (NSString *)convertDataToHexStr:(NSData *)data;

#pragma mark - 十六进制字符串转换
+(NSData *)convertHexStrToData:(NSString *)str;

#pragma mark - 加密
+ (NSMutableString *)sha1:(NSString *)input;
+ (NSMutableString *)sha256:(NSString *)input;
+ (NSString *)md5WithString:(NSString *)str;

@end
