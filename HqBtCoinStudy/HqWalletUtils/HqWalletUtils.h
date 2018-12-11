//
//  HqWalletUtils.h
//  SolarWallet
//
//  Created by hqmac on 2018/4/19.
//  Copyright © 2018年 solar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HqWallet.h"
#import <BTBIP32Key.h>
@interface HqWalletUtils : NSObject

//由助记词导入钱包
+ (HqWallet *)importWalletWithMnemonic:(NSString *)mnemonic;
//由助记词创建钱包
+ (HqWallet *)createWalletWithMnemonic:(NSString *)mnemonic;
//+ (NSString *)showMnemonic;
//+ (void)saveMnemonic:(NSString *)mnemonic;
//客户端消息签名
+ (NSString *)signMessage:(NSString *)message privatekey:(NSString *)privatekey;
/*
服务端消息签名验证
 服务端返回json格式如下：
 {
 "data": "{\"code\":200,\"message\":\"Job Success\",\"time\":1524205025908,\"data\":{\"mnemonic\":\"crucial ranch reveal erode protect mobile child child risk flash wash wish\",\"wid\":\"18f7b2f4-484f-4393-b86d-1f3531cbe18e\",\"masterAddr\":\"1GjY8MmcLW9UHJ5UBGNZueZUSg5jtyxmFS\"}}",
 "signature": "1f332d35652b2865f7280cc3e9d3424d14fca2746f33e2c01c05fd692a6fb4099777fce243f70227741981d1ea7fa41915a3a1a323a2abc43362faf386665127a5"
 }
 参数说明：
 message:最外层data的值
 signature:返回的签名如上
 address:返回的地址如上内部data中masterAddr的值
 */
+ (BOOL)verifyMessage:(NSString *)message serverSignature:(NSString *)signature serverAddress:(NSString *)address;
+ (BOOL)verifyMessage:(NSString *)message signature:(NSString *)signature address:(NSString *)address;

#pragma mark 重置钱包
+ (void)resetWallet;

+ (void)saveWallet:(HqWallet *)newWallet;
+ (BOOL) isExistWallet;
+ (BOOL)deleteWallet;
+ (HqWallet *)getExistWallet;

@end
