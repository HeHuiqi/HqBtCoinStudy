//
//  HqLoopImageCell.h
//  GlobalPay
//
//  Created by hqmac on 2018/8/27.
//  Copyright © 2018年 solar. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HqLoopImageCellIdentifer @"HqLoopImageCell"
#import "HqBanner.h"
@interface HqLoopImageCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *bannerImageView;
@property (nonatomic,strong) UILabel *hqTitleLab;

@property (nonatomic,strong) HqBanner *banner;

@end
