//
//  MDRLinerFlowLayout.m
//  MDRCustomLayout
//
//  Created by 刘春牢 on 16/5/20.
//  Copyright © 2016年 liuchunlao. All rights reserved.
//

#import "MDRLinerFlowLayout.h"

@implementation MDRLinerFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 1.设置滚动方向
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
    }
    return self;
}

#pragma mark - 只要需要计算布局，系统就会调用这个方法
- (void)prepareLayout {

    [super prepareLayout];
    
    // 1. 确定大小
    CGFloat itemH = self.collectionView.bounds.size.height * 0.8;
    CGFloat itemW = itemH;
    
    self.itemSize = CGSizeMake(itemW, itemH);

    // 2.设置最小间距
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;

    // 3.计算内边距
    CGFloat inset = (self.collectionView.bounds.size.width - itemW) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
}

#pragma mark - 只要显示的区域发生变化，就重新计算
// 区域发生变化，让布局失效！
// 失效后系统会重新计算布局信息
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {

    return YES;
}

#pragma mark - 计算cell的attr【要显示的和即将显示的cell】
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    // 1.获取系统计算好的信息
    NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
    
    // 2.此数组用于存放修改之后的信息，需要做一个copy操作，否则会报错，不崩溃，提示需要拷贝！
    NSMutableArray *arrM = [NSMutableArray array];
    
    // 3.遍历进行修改
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        
        // 3.1 copy
        UICollectionViewLayoutAttributes *newAttr = attr.copy;
        
        // 3.2 计算newAttr 与 中心线的距离
        // - 中心线的 x
        CGFloat screenCenterX = self.collectionView.bounds.size.width *0.5 + self.collectionView.contentOffset.x;
        
        // - 计算距离,区绝对值
        CGFloat distance = ABS(newAttr.center.x - screenCenterX);
        
        // - 计算比例, 距离越大，比例越小，距离越小比例越大
        CGFloat scale = 1 - distance / self.collectionView.bounds.size.width * 0.3;
        
        // 设置缩放效果
        CATransform3D transform3D = newAttr.transform3D;
        
        transform3D = CATransform3DScale(attr.transform3D, scale, scale, 1);
        
        // 设置旋转效果
        // 判断角度值的正负
        BOOL isLeft = ((newAttr.center.x - screenCenterX) > 0) ? YES : NO;
        CGFloat angle = scale * M_PI * 2 * (isLeft ? 1 : -1);
        
        transform3D.m34 = - 1.0 / 500;
        transform3D = CATransform3DRotate(transform3D, angle, 0, 1, 0);
        
        newAttr.transform3D = transform3D;
        
//        NSLog(@"%f", scale);
        
        // 添加到集合中
        [arrM addObject:newAttr];
    }
    
    return arrM;
    
}


#pragma mark - 系统预期会停留的位置
// proposedContentOffset 预期的便宜量
// velocity 速度
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {

    CGPoint point = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    
    // 1.找出距离中线最近的那个cell
    // - 获取屏幕中对应的范围
    CGRect visiableRect;
    visiableRect = self.collectionView.bounds;
    visiableRect.origin.x = proposedContentOffset.x;
    
    // - 获取能再屏幕中显示的所有cell
    NSArray<UICollectionViewLayoutAttributes *> *visiableAttrs = [self layoutAttributesForElementsInRect:visiableRect];
    
    // 2.遍历找出距离屏幕最近的cell
    // - 屏幕中线的位置
    CGFloat screenCenterX = proposedContentOffset.x + self.collectionView.bounds.size.width * 0.5;
    
    // - 定义最小间距，用于存放最小的间距
    CGFloat minMargin = MAXFLOAT;
    NSInteger idx = -1;
    
    for (NSInteger i = 0; i < visiableAttrs.count; i++) {
        
        // - 取出需要比较的家伙
        UICollectionViewLayoutAttributes *attr = visiableAttrs[i];
        
        // - 计算间距
        CGFloat distance = ABS(attr.center.x - screenCenterX);
        
        
        if (distance < minMargin) {
            // - 修改最小值
            minMargin = distance;
            
            // - 记录最小的那个家伙的索引
            idx = i;
        }
    }
    NSLog(@"找到的下标是%@  %@", @(idx), visiableAttrs);
    
    // 3.计算让collectionView停留的位置
    UICollectionViewLayoutAttributes *destAttr = visiableAttrs[idx];
    CGFloat offsetX = point.x + (destAttr.center.x - screenCenterX);
    
    // 4.返回
    return CGPointMake(offsetX, point.y);
}





@end
