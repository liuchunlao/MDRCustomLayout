//
//  MDRCustomThree.m
//  MDRCustomLayout
//
//  Created by 刘春牢 on 16/4/30.
//  Copyright © 2016年 liuchunlao. All rights reserved.
//

#import "MDRCustomThree.h"

@interface MDRCustomThree ()


@property (nonatomic, strong) NSMutableArray *attrsArrM;

@end


@implementation MDRCustomThree


// 返回尺寸
- (CGSize)collectionViewContentSize {
    
    UICollectionViewLayoutAttributes *attr = self.attrsArrM.lastObject;
    CGFloat width = CGRectGetMaxX(attr.frame) + 1;
    
    
    // MARK: - 如果是6的整数倍，则就是这个width
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    if (count % 6 != 0) {
        
        width = (count / 6 + 1) * self.collectionView.bounds.size.width;
    }
    
    return CGSizeMake(width, 0);
    
}


#pragma mark - 尺寸发生改变的时候再次进行计算
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {

    return YES;
}

#pragma mark -  布局准备操作，需要super
- (void)prepareLayout {
    
    [super prepareLayout];
    
    [self.attrsArrM removeAllObjects];
    
    // 去计算所有cell的布局
    for (NSInteger i = 0, count = [self.collectionView numberOfItemsInSection:0]; i < count; i++) {
        
        // 计算每个位置cell的信息
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArrM addObject:attr];
    }
    
    
}


#pragma mark - 可见范围内cell的布局
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attrsArrM;
}


#pragma mark - 每个元素对应的布局
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 确定宽度、高度
    CGFloat collectW = self.collectionView.bounds.size.width;
    CGFloat collectH = self.collectionView.bounds.size.height - 64;
    
    CGFloat scale = 1;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(1 * scale, 1 * scale, 1 * scale, 1 * scale); // 顶部、左边、下边、右边间距
    CGFloat colMargin = 1 * scale; // 列间距
    CGFloat rowMargin = 1 * scale;
    
    int colPerPage = 2;
    int rowPerPage = 3;

    
    CGFloat itemW = (collectW - (insets.left + insets.right + colMargin)) / colPerPage;
    CGFloat itemH = (collectH - (insets.top + insets.bottom + (rowPerPage - 1) * rowMargin)) / rowPerPage;
    
    NSInteger pageNumber = indexPath.item / 6; // 页码
    
    NSInteger index = indexPath.item % 6; // 序号
    
    NSInteger rowN = index / colPerPage;
    NSInteger colN = index % colPerPage;
    
    
    
    CGFloat itemX = insets.left + (itemW + colMargin) * colN + pageNumber * collectW;
    CGFloat itemY = insets.top + (itemH + rowMargin) * rowN;
    
//    NSLog(@"%f", itemX);
    
    attr.frame = CGRectMake(itemX, itemY, itemW, itemH);
    
//    NSLog(@"%@", NSStringFromCGRect(attr.frame));
    
    return attr;
    
}


#pragma mark - 懒加载
- (NSMutableArray *)attrsArrM {
    if (!_attrsArrM) {
        _attrsArrM = [NSMutableArray array];
    }
    return _attrsArrM;
}



@end
