//
//  HqLoopView.m
//  GlobalPay
//
//  Created by hqmac on 2018/8/27.
//  Copyright © 2018年 solar. All rights reserved.
//

#import "HqLoopView.h"
#import "HqLoopImageCell.h"
#import "HqFlowlayout.h"

//轮播间隔
static CGFloat ScrollInterval = 3.0f;
@interface HqLoopView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) NSTimer *loopTimer;
@property (nonatomic,strong) NSMutableArray *hqImageData;

@end

@implementation HqLoopView

- (void)setLoopViewType:(HqLoopViewType)loopViewType{
    _loopViewType = loopViewType;
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    self.pageControl.center = CGPointMake(self.center.x, CGRectGetMaxY(self.bounds)-10);
}
- (void)setImages:(NSMutableArray *)images{
    _images = images;
    if (_images) {
        //设置数据时在第一个之前和最后一个之后分别插入数据
        _hqImageData = [NSMutableArray arrayWithArray:_images];
        [_hqImageData addObject:images.firstObject];
        [_hqImageData insertObject:images.lastObject atIndex:0];
        //设置_pageControl的显示页
        _pageControl.numberOfPages = images.count;
        [self.collectionView reloadData];
        //_collectionView滚动到第二页的位置
        [self initPostion];
      
        if (self.loop) {
            [self loopTimer];
        }
    }
}
- (void)initPostion{
    CGFloat itemOffetxSpace = self.collectionView.bounds.size.width;
    if (self.loopViewType == HqLoopViewTypeSpace) {
        itemOffetxSpace = (self.collectionView.bounds.size.width-40)-25;
    }
    dispatch_async( dispatch_get_main_queue(), ^{
        [self.collectionView setContentOffset:CGPointMake(itemOffetxSpace, self.collectionView.contentOffset.y)];
    });
}
- (NSTimer *)loopTimer{
    if (!_loopTimer) {
        _loopTimer = [NSTimer scheduledTimerWithTimeInterval:ScrollInterval target:self selector:@selector(showNext) userInfo:nil repeats:YES];
    }
    return _loopTimer;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
//        _pageControl.currentPageIndicatorTintColor = HqOrangeColor;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor blueColor];
    }
    return _pageControl;
}
- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        if (self.loopViewType == HqLoopViewTypePlain) {
            _flowLayout = [[UICollectionViewFlowLayout alloc] init];
            _flowLayout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
            _flowLayout.minimumInteritemSpacing = 0;
            _flowLayout.minimumLineSpacing = 0;
        }else{
            _flowLayout = [[HqFlowlayout alloc] init];
            _flowLayout.itemSize = CGSizeMake(self.bounds.size.width-50, self.bounds.size.height);
            _flowLayout.minimumInteritemSpacing = 0;
            _flowLayout.minimumLineSpacing = 10;

        }
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        if (self.loopViewType == HqLoopViewTypePlain) {
            _collectionView.pagingEnabled = YES;
        }
        [_collectionView registerClass:[HqLoopImageCell class] forCellWithReuseIdentifier:HqLoopImageCellIdentifer];
    }
    return _collectionView;
}
#pragma mark - UICollectionViewDelagate、DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.hqImageData.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HqLoopImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HqLoopImageCellIdentifer forIndexPath:indexPath];
    
//    cell.banner = self.hqImageData[indexPath.row];
//    cell.hqTitleLab.text = self.hqImageData[indexPath.row];
    NSString *name =self.hqImageData[indexPath.row];
    cell.bannerImageView.image = [UIImage imageNamed:name];
    cell.hqTitleLab.text = name;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    HqBanner *banner = self.hqImageData[indexPath.row];
    if (self.delegate) {
        [self.delegate HqLoopView:self selectedBanner:banner];
    }
}
//手动拖拽结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cycleScroll];
    });
    //拖拽动作后间隔3s继续轮播
    [_loopTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:ScrollInterval]];
}

//自动轮播结束
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cycleScroll];
    });
}

//循环显示
- (void)cycleScroll {
    
    if (self.loopViewType == HqLoopViewTypeSpace) {
        CGFloat itemOffetxSpace = (_collectionView.bounds.size.width-40)-_collectionView.contentInset.left;
        NSInteger page = _collectionView.contentOffset.x/itemOffetxSpace;
//        NSLog(@"page==%@",@(page));
//        NSLog(@"collectionView.contentOffset.x==%@",@(_collectionView.contentOffset.x));
//        NSLog(@"itemOffetxSpace==%@",@(itemOffetxSpace));

        if (page == 0) {//滚动到左边
            itemOffetxSpace = (_collectionView.bounds.size.width-40);
            _collectionView.contentOffset = CGPointMake(-_collectionView.contentInset.left+(_hqImageData.count-2)*itemOffetxSpace, _collectionView.contentOffset.y);
            _pageControl.currentPage = _hqImageData.count - 2;
        }
        else if (page >= _hqImageData.count - 1){//滚动到右边
            _collectionView.contentOffset = CGPointMake(itemOffetxSpace, _collectionView.contentOffset.y);
            _pageControl.currentPage = 0;
        }else{
            _pageControl.currentPage = page-1;
        }
    }else{
        CGFloat itemOffetxSpace = _collectionView.bounds.size.width;
        NSInteger page = _collectionView.contentOffset.x/itemOffetxSpace;
        if (page == 0) {//滚动到左边
            _collectionView.contentOffset = CGPointMake((_hqImageData.count-2)*itemOffetxSpace, _collectionView.contentOffset.y);
            _pageControl.currentPage = _hqImageData.count - 2;
        }
        else if (page >= _hqImageData.count - 1){//滚动到右边
            _collectionView.contentOffset = CGPointMake(itemOffetxSpace, _collectionView.contentOffset.y);
            _pageControl.currentPage = 0;
        }else{
            _pageControl.currentPage = page-1;
        }
    }
   
}

- (void)hqScrollCollectionViewWithOffsetX:(CGFloat)OffsetX{
    _collectionView.contentOffset = CGPointMake(OffsetX, _collectionView.contentOffset.y);

}
#pragma mark 轮播方法
//自动显示下一个
- (void)showNext {
    //手指拖拽是禁止自动轮播
    if (!_collectionView.isDragging ) {
        CGFloat targetX =  _collectionView.contentOffset.x + _collectionView.bounds.size.width;
        if (self.loopViewType == HqLoopViewTypeSpace) {
          targetX =  _collectionView.contentOffset.x + (_collectionView.bounds.size.width-40);
        }
        [_collectionView setContentOffset:CGPointMake(targetX, _collectionView.contentOffset.y) animated:true];
    }
}
- (void)dealloc {
    [_loopTimer invalidate];
}

@end
