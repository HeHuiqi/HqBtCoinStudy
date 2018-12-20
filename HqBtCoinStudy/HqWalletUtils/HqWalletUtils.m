//
//  HqWalletUtils.m
//  SolarWallet
//
//  Created by hqmac on 2018/4/19.
//  Copyright © 2018年 solar. All rights reserved.
//

#import "HqWalletUtils.h"
#import <BTUtils.h>
#import <NSData+Hash.h>
#import <BTBIP39.h>
#define kA1sk @"k_wallet_a"
#define kA1sk2 @"k_wallet_mnemonic"

#import <NSMutableData+Bitcoin.h>
#import "NSString+Public.h"

@implementation HqWalletUtils


//生成私钥、共钥、地址
//master.secret私钥、master.pubKey公钥、 master.address地址
+ (BTBIP32Key *)rootFromMnemonic:(NSString *)mnemonic {
    NSData *seed = [[BTBIP39 sharedInstance] toSeed:mnemonic withPassphrase:@""];
    BTBIP32Key *master = [[BTBIP32Key alloc] initWithSeed:seed];
    
    //清除私钥
    //    [master wipe];
    
    //    BTBIP32Key *purpose = [master deriveHardened:44];
    //    BTBIP32Key *coinType = [purpose deriveHardened:0];
    //    BTBIP32Key *account = [coinType deriveHardened:0];
    //    BTBIP32Key *external = [account deriveSoftened:0];
    //    [purpose wipe];
    //    [coinType wipe];
    //    [account wipe];
    return master;
}
+ (HqWallet *)importWalletWithMnemonic:(NSString *)mnemonic{
    HqWallet *wallet = [self createWalletWithMnemonic:mnemonic];
    return wallet;
}
+ (HqWallet *)createWalletWithMnemonic:(NSString *)mnemonic{
    BTBIP32Key *keys = [self rootFromMnemonic:mnemonic];
    HqWallet *wallet = [[HqWallet alloc] init];
    wallet.privatekey = [self toSimpleStringWithData:keys.secret];
    wallet.publickkey = [self toSimpleStringWithData:keys.pubKey];
    wallet.address = keys.address;
    return wallet;
}
/*
+ (NSString *)showMnemonic{
    NSData *data = GetUserDefault("kWalletMnemonic");
    if (data) {
//        data = [HqEncrypt AES256ParmDecryptWithKey:kA1sk2 Decrypttext:data];
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}
+ (void)saveMnemonic:(NSString *)mnemonic{
    NSData *data = [mnemonic dataUsingEncoding:NSUTF8StringEncoding];
//    data = [HqEncrypt AES256ParmEncryptWithKey:kA1sk2 Encrypttext:data];
    SetUserDefault(data, "kWalletMnemonic");
}
*/

//签名消息
+ (NSData *)formatMessageForSigning1:(NSString *)message; {
    NSMutableData *data = [NSMutableData secureData];
    uint8_t length = (uint8_t) BITCOIN_SIGNED_MESSAGE_HEADER_BYTES.length;
    NSLog(@"header== %@",BITCOIN_SIGNED_MESSAGE_HEADER_BYTES);
    NSLog(@"length = %@",@(length));

    [data appendUInt8:length];
    [data appendData:BITCOIN_SIGNED_MESSAGE_HEADER_BYTES];
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    [data appendVarInt:messageData.length];
    [data appendData:messageData];
    return data;
}
+ (NSString *)signMessage:(NSString *)message privatekey:(NSString *)privatekey{
    
    //NSLog(@"原始消息===%@",message);

    NSData *msgData = [self formatMessageForSigning1:message];
    
    NSData *privatekeyData = [NSString convertHexStrToData:privatekey];
    BTKey *btkey = [[BTKey alloc] initWithSecret:privatekeyData compressed:YES];
//    BTKey *btkey = [[BTKey alloc] initWithPrivateKey:@"L2ZxvziVam5X4K8GepnKEymZvRng4UcGSPixgaoMroSAuz8t22vS"];
    btkey.compressed = YES;

    NSLog(@"msgData== %@",[NSString convertDataToHexStr:msgData]);
    NSLog(@"btkey.publicKey===%@",btkey.publicKey);
    NSLog(@"btkey.privateKey===%@",btkey.privateKey);
    NSLog(@",btkey.address===%@",btkey.address);
    NSData *d = [msgData SHA256_2];
    NSLog(@"d== %@",[NSString convertDataToHexStr:d]);
    NSData *reuslt = [btkey signHash:d];
    NSString *signStr = [self toSimpleStringWithData:reuslt];
    NSLog(@"签名结果===%@",signStr);


    return signStr;
}
//验证签名
//signature服务端返回是NSData类型的字符串
+ (BOOL)verifyMessage:(NSString *)message serverSignature:(NSString *)signature serverAddress:(NSString *)address{
    
    return  [self verifyMessage:message signature:signature address:address];
}
+ (BOOL)verifyMessage:(NSString *)message signature:(NSString *)signature address:(NSString *)address{
    NSData *singData  =[NSString convertHexStrToData:signature];
    singData = [singData base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *singDataBase64Str = [[NSString alloc] initWithData:singData encoding:NSUTF8StringEncoding];
    
    BTKey *key = [BTKey signedMessageToKey:message andSignatureBase64:singDataBase64Str];
    NSString *signAddress = [key address];
    NSLog(@"signAddress==%@",signAddress);
    return [BTUtils compareString:address compare:signAddress];
}

+ (NSString *)toSimpleStringWithData:(NSData *)data{
    NSString *str  = [NSString stringWithFormat:@"%@",data];
    str =  [str substringWithRange:NSMakeRange(1, str.length-2)];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
}


+ (void)saveWallet:(HqWallet *)newWallet{
    NSData *walletData = [NSKeyedArchiver archivedDataWithRootObject:newWallet];
    [self saveWalletData:walletData];
}

+ (BOOL) isExistWallet{
    
    HqWallet *wallet = [self getExistWallet];
    BOOL isExist  =  wallet.privatekey.length>0;
    if (isExist) {
         //SetUserDefault(@"1", kLocalIsLogin);
    }
   
    return isExist;
}
+ (HqWallet *)getExistWallet{
    
    NSData *walletData = [self queryWalletData];
    if (walletData) {
        HqWallet *wallet = [NSKeyedUnarchiver unarchiveObjectWithData:walletData];
       
        
//        NSLog(@"wallet.privatekey==%@",wallet.privatekey);
//        NSLog(@"wallet.address==%@",wallet.address);
//        NSLog(@"wallet.wid==%@",wallet.wid);
        return wallet;

    }
    return nil;
}
#pragma mark 重置钱包
+ (void)resetWallet{
    if ([HqWalletUtils deleteWallet]) {
        /*
        [AppDelegate shareApp].wallet = nil;
        //[[HqContactUtil initDBName:@"model.sqlite"] deleteAllContact];
        SetUserDefault(nil, gestureFinalSaveKey);
        SetUserDefault(nil, kWalletAddress);
        //SetUserDefault(nil, kIsNewWallet);
        SetUserDefault(nil, kWalletMnemonic);
        SetUserDefault(nil, kGesturePasswodStatus);
        SetUserDefault(nil, kBaiduFaceStatus);
        SetUserDefault(nil, kLocalIsLogin);
        */

    }
}
+ (BOOL)deleteWallet{
    
    NSString *sl_path = [self slWalletPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL suc = [fileManager removeItemAtPath:sl_path error:&error];
    if (suc) {
        //SetUserDefault(nil, kLocalIsLogin);
    }
    return suc;
    
}
+ (NSString *)slWalletPath{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"docDir:%@",docDir);
    NSString *sl_path = [docDir stringByAppendingPathComponent:@"sl_w_d.plist"];
    return sl_path;
}
+ (BOOL )saveWalletData:(NSData *)data{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL suc = NO;
    NSString *sl_path = [self slWalletPath];
    if (![fileManager fileExistsAtPath:sl_path]) {
        suc =[fileManager createFileAtPath:sl_path contents:nil attributes:nil];
    }
//    data =  [HqEncrypt AES256ParmEncryptWithKey:kA1sk Encrypttext:data];
    suc = [data writeToFile:sl_path atomically:YES];
    if (suc) {
//        SetUserDefault(@"1", kLocalIsLogin);
    }
    return suc;
}
+ (NSData *)queryWalletData{

    NSString *sl_path = [self slWalletPath];
    NSData *data = [[NSData alloc] initWithContentsOfFile:sl_path];
//    data = [HqEncrypt AES256ParmDecryptWithKey:kA1sk Decrypttext:data];
    return data;
}


@end
