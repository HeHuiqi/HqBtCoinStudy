//
//  HqWallet.h
//  SolarWallet
//
//  Created by hqmac on 2018/4/19.
//  Copyright © 2018年 solar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HqWallet : NSObject<NSCoding>

@property (nonatomic,copy) NSString *privatekey;
@property (nonatomic,copy) NSString *publickkey;
@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *masterAddr;//server钱包地址
@property (nonatomic,copy) NSString *mnemonic;//助记词
@property (nonatomic,copy) NSString *wid;//钱包id
@property (nonatomic,copy) NSString *signature;//签名

@end
