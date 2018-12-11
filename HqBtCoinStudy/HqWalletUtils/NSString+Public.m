//
//  NSString+Public.m
//  VaktenUse
//
//  Created by iMac on 15/7/15.
//  Copyright (c) 2015年 iMac. All rights reserved.
//

#import "NSString+Public.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Public)

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    //中国手机号
    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[35678]|18[0-9]|14[57])[0-9]{8}$";
    //越南手机号
    phoneRegex = @"^(1[345789][0-9]{9}|01[0-9]{9}|08[0-9]{8}|09[0-9]{8})$";
    NSRegularExpression * regular = [[NSRegularExpression alloc]initWithPattern:phoneRegex options:NSRegularExpressionCaseInsensitive error:nil];
    return [regular numberOfMatchesInString:mobileNum options:NSMatchingReportCompletion range:NSMakeRange(0, mobileNum.length)];
}
/*
 用kCFStringTransformMandarinLatin方法转化出来的是带音标的拼音，
 如果需要去掉音标，则继续使用kCFStringTransformStripCombiningMarks方法即可。
 */
+ (NSString *)chineseTransforToPinyi:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return pinyin;
}

+ (BOOL)checkInputCode:(NSString *)input regex:(NSString *)regex
{
    NSRegularExpression * regular = [[NSRegularExpression alloc]initWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    return [regular numberOfMatchesInString:input options:NSMatchingReportCompletion range:NSMakeRange(0, input.length)];
}
#pragma mark - 随机生成SessionID
+ (NSString *)generateSessionId
{
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    return [self md5WithString:[NSString stringWithFormat:@"%fXWF%ld", timestamp, random() % 9999]];
}

+ (CGFloat )getTextHeightWithString:(NSString *)string fontSize:(CGFloat )size textWidth:(CGFloat)width
{
    CGSize contentSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size]} context:nil].size;
    return contentSize.height;
}
+ (CGFloat )getTextWidthWithString:(NSString *)string fontSize:(CGFloat )size textHeight:(CGFloat)height
{
    CGSize contentSize = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size]} context:nil].size;
    return contentSize.width;
}
- (BOOL)isContainsString:(NSString *)searchString{
    
    if (strstr([self UTF8String], [searchString UTF8String])) {
        return YES;
    }
    
    return NO;
}
+ (BOOL)isHaveNewV:(NSString *)newV oldV:(NSString *)oldV{
    if ([newV isEqualToString:oldV]) {
        
        return NO;
    }
//    int result = compare_version(newV.UTF8String, oldV.UTF8String);
//    if (result == 1) {
//        return YES;
//    }
    return YES;
}
#pragma mark -   二进制转十进制
+ (int)toDecimalSystemWithBinarySystem:(NSString *)binary
{
    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    
    return ll;
}
#pragma mark -   十进制转二进制
+ (NSMutableArray *)toBinarySystemWithDecimalSystem:(int)decimal
{
    NSMutableArray *resultArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    if (decimal == 0) {
        return nil;
    }
    int num = decimal;
    int remainder = 0;      //余数
    int divisor = 0;        //除数
    NSString * prepare = @"";
    
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%d",remainder];
        [resultArray addObject:[NSNumber numberWithInt:remainder]];
        if (divisor == 0)
        {
            break;
        }
    }
    return resultArray;
}
+ (NSData*)hexStringToNSData:(NSString*)hexString{
    if (!hexString){
        return [NSData data];
    }
    
    //栈缓冲区
    Byte stackBuffer[512];
    Byte *buffer;
    uint bufferLength = (uint)hexString.length / 2 + hexString.length % 2 ;
    
    if (bufferLength > sizeof(stackBuffer)) {
        //当字符串长度大于栈缓冲区时，使用堆内存
        buffer = (Byte*)malloc(bufferLength);
    }
    else{
        buffer = stackBuffer;
    }
    
    NSUInteger length = hexString.length;
    
    for (NSUInteger i = 0; i<length; i++) {
        unichar c = [hexString characterAtIndex:i];
        if (i & 0x1){
            //低四位（后处理）
            buffer[i >> 1] |= c & 0x0F;
        }
        else{
            //高四位（先处理）
            buffer[i >> 1] = c << 4;
        }
    }
    
    NSData *result = [NSData dataWithBytes:buffer length:bufferLength];
    
    if (buffer != stackBuffer) {
        //当字符串长度大于栈缓冲区时使用的是堆内存，在这里释放
        free(buffer);
    }
    
    return result;
}

#pragma mark - 十六进制字符串转long
+ (unsigned long)hexStrTolong:(NSString *)hexStr{
    char *rest = (char *)[hexStr UTF8String];
    unsigned long sum = 0;
    for (int i = 0; i<hexStr.length; i++) {
        char j[1] = {rest[i]};
        unsigned long k =  strtoul(j,0,16);
        sum = sum + k*powf(16, hexStr.length - i - 1);
    }
    return sum;
}
#pragma mark - data转十六进制字符串
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

#pragma mark - 十六进制转字符 GBK编码
+ (NSString *)stringFromHexString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr] ;
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:encode];
    return unicodeString;
}
+ (NSString *)hexStringToNSStringUTF8:(NSString *)hexString{
    if (hexString.length==0) {
        return nil;
    }
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr] ;
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:NSUTF8StringEncoding];
    return unicodeString;
}

#pragma mark - 十六进制字符串转换

+ (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}
+ (NSString *)toSimpleStringWithData:(NSData *)data{
    NSString *str  = [NSString stringWithFormat:@"%@",data];
    str =  [str substringWithRange:NSMakeRange(1, str.length-2)];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
}
#pragma mark - 加密
+ (NSMutableString *)sha1:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}
+ (NSMutableString *)sha256:(NSString *)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for(int i=0; i<CC_SHA256_DIGEST_LENGTH*2; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}
+ (NSString *)md5WithString:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}
@end
