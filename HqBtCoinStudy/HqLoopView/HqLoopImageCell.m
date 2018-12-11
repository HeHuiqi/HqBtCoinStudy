//
//  HqLoopImageCell.m
//  GlobalPay
//
//  Created by hqmac on 2018/8/27.
//  Copyright © 2018年 solar. All rights reserved.
//

#import "HqLoopImageCell.h"

@implementation HqLoopImageCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    self.backgroundColor = [UIColor purpleColor];

    _bannerImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_bannerImageView];

    _hqTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    _hqTitleLab.backgroundColor = [UIColor redColor];
    _hqTitleLab.textAlignment = NSTextAlignmentCenter;
    _hqTitleLab.font = [UIFont systemFontOfSize:18];
    [self addSubview:_hqTitleLab];

}
- (void)setBanner:(HqBanner *)banner{
    _banner = banner;
    if (_banner) {
        //[_bannerImageView sd_setImageWithURL:[NSURL URLWithString:_banner.banner] placeholderImage:nil];
    }
}

@end
