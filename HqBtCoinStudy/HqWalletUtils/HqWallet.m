//
//  HqWallet.m
//  SolarWallet
//
//  Created by hqmac on 2018/4/19.
//  Copyright © 2018年 solar. All rights reserved.
//

#import "HqWallet.h"

@implementation HqWallet

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.privatekey = [aDecoder decodeObjectForKey:@"privatekey"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.wid = [aDecoder decodeObjectForKey:@"wid"];
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.privatekey forKey:@"privatekey"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.wid forKey:@"wid"];
}
- (NSString *)wid{
    if (_wid.length==0) {
        return @"";
    }
    return _wid;
}

@end
