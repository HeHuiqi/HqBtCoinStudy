//
//  HqFlowlayout.m
//  HqBtCoinStudy
//
//  Created by hqmac on 2018/12/10.
//  Copyright © 2018 HHQ. All rights reserved.
//

#import "HqFlowlayout.h"

@implementation HqFlowlayout

/**
 * 用来做布局的初始化操作（不建议在init方法中进行布局的初始化操作）
 */
- (void)prepareLayout
{
    [super prepareLayout];
    //水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat margin = (self.collectionView.frame.size.width - self.itemSize.width) / 2;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, margin, 0, margin);
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;

}

/**
* 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局;
* 一旦重新刷新布局，就会重新调用下面的方法：
* 1.prepareLayout
* 2.layoutAttributesForElementsInRect:方法
*/
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
//需要在viewController中使用上ZWLineLayout这个类后才能重写这个方法！！

//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    //让父类布局好样式
//    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
//    //计算出collectionView的中心的位置
//    CGFloat ceterX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
//    /**
//     * 1.一个cell对应一个UICollectionViewLayoutAttributes对象
//     * 2.UICollectionViewLayoutAttributes对象决定了cell的frame
//     */
//    for (UICollectionViewLayoutAttributes *attributes in arr) {
//        //cell的中心点距离collectionView的中心点的距离，注意ABS()表示绝对值
//        CGFloat delta = ABS(attributes.center.x - ceterX);
//        //设置缩放比例
//        if (delta<0.8) {
//            delta = 0.1;
//        }
//        CGFloat scale = 1.0 - delta / self.collectionView.frame.size.width;
//        //设置cell滚动时候缩放的比例
//        attributes.transform = CGAffineTransformMakeScale(1.0, 1.0);
//    }
//
//    return arr;
//}

/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    
    CGSize size = self.collectionView.frame.size;
    // 计算可见区域的面积
    CGRect rect = CGRectMake(proposedContentOffset.x, proposedContentOffset.y, size.width, size.height);
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    // 标记 cell 的中点与 UICollectionView 中点最小的间距
    CGFloat minDetal = MAXFLOAT;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal){
        // 计算 CollectionView 中点值
        CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
        for (UICollectionViewLayoutAttributes *attrs in array){
            if (ABS(minDetal) > ABS(centerX - attrs.center.x)){
                minDetal = attrs.center.x - centerX;
            }
        }
        return CGPointMake(proposedContentOffset.x + minDetal, proposedContentOffset.y);
    }else{
        // 计算 CollectionView 中点值
        CGFloat centerY = proposedContentOffset.y + self.collectionView.frame.size.height * 0.5;
        for (UICollectionViewLayoutAttributes *attrs in array){
            if (ABS(minDetal) > ABS(centerY - attrs.center.y)){
                minDetal = attrs.center.y - centerY;
            }
        }
        return CGPointMake(proposedContentOffset.x, proposedContentOffset.y + minDetal);
    }
    
    return proposedContentOffset;
    
}
@end
