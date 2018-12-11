//
//  ViewController.m
//  HqBtCoinStudy
//
//  Created by hqmac on 2018/12/10.
//  Copyright © 2018 HHQ. All rights reserved.
//

#import "ViewController.h"
#import "HqWalletUtils/HqWalletUtils.h"
#import "HqLoopView.h"

static  NSString *ZWCellID = @"cell";
@interface ViewController ()<HqLoopViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *hqImageData;
@property (nonatomic,strong) HqLoopView *hqLoopView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // msg: 'hello'
//    // privatekey: 9f9b465e5db8e793a71d116bcf595f098d5a2f928f1d292acc6a62900bdba58e
//    // signature: 1f6cace2e99f7514e2d50c1de7b2c90ab11562c9bda904aec783289400de3e3dab46181aa62a8cc52e69b316346783c908beeaa4500245174a5ffd6ce8ad916183
//
//    [HqWalletUtils signMessage:@"hello" privatekey:@"9f9b465e5db8e793a71d116bcf595f098d5a2f928f1d292acc6a62900bdba58e"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.hqLoopView];
    self.hqLoopView.images = @[@"1.jpeg",@"2.jpg",@"3.jpg"].mutableCopy;
   
}

- (HqLoopView *)hqLoopView{
    if (!_hqLoopView) {
        _hqLoopView = [[HqLoopView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 210)];
        _hqLoopView.delegate = self;
        _hqLoopView.loopViewType = HqLoopViewTypeSpace;
        _hqLoopView.loop = YES;
        
    }
    return _hqLoopView;
}

- (void)HqLoopView:(HqLoopView *)view selectedBanner:(HqBanner *)banner{
    
}
@end
