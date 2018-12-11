//
//  HqLoopView.h
//  GlobalPay
//
//  Created by hqmac on 2018/8/27.
//  Copyright © 2018年 solar. All rights reserved.
//
/*
 用法：
 - (HqLoopView *)hqLoopView{
     if (!_hqLoopView) {
         _hqLoopView = [[HqLoopView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 210)];
         _hqLoopView.delegate = self;
         _hqLoopView.loopViewType = HqLoopViewTypePlain;
         _hqLoopView.loop = YES;
     }
    return _hqLoopView;
 }
 [self.view addSubview:self.hqLoopView];
 self.hqLoopView.images = @[@"1.jpeg",@"2.jpeg",@"3.jpg"].mutableCopy
 
 
 */
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,HqLoopViewType) {
    HqLoopViewTypePlain,
    HqLoopViewTypeSpace,
};
@class HqBanner;
@protocol HqLoopViewDelegate;
@interface HqLoopView : UIView

@property (nonatomic,strong) NSMutableArray *images;//图片数据
@property (nonatomic,assign)  BOOL loop; //是否无限循环轮播
@property (nonatomic,assign) HqLoopViewType loopViewType;
@property (nonatomic,weak) id<HqLoopViewDelegate> delegate;


@end

@protocol HqLoopViewDelegate
@optional
- (void)HqLoopView:(HqLoopView *)view selectedBanner:(HqBanner *)banner;
@end
