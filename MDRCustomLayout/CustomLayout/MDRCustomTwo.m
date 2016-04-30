//
//  MDRCustomTwo.m
//  MDRCustomLayout
//
//  Created by 刘春牢 on 16/4/30.
//  Copyright © 2016年 liuchunlao. All rights reserved.
//

#import "MDRCustomTwo.h"

@interface MDRCustomTwo ()

@property (nonatomic, strong) NSMutableArray *attrsArrM;

@end


@implementation MDRCustomTwo

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}


// 返回尺寸
- (CGSize)collectionViewContentSize {
    
    UICollectionViewLayoutAttributes *attr = self.attrsArrM.lastObject;
    CGFloat width = CGRectGetMaxY(attr.frame);
    return CGSizeMake(0, width);
    
}

// 布局准备操作
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


// 可见范围内cell的布局
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // 去计算所有cell的布局
    for (NSInteger i = 0, count = [self.collectionView numberOfItemsInSection:0]; i < count; i++) {
        
        // 计算每个位置cell的信息
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArrM addObject:attr];
    }
    return self.attrsArrM;
}


// 每个元素对应的布局
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // 宽、高
    CGFloat itemW = self.collectionView.bounds.size.width * 0.5;
    CGFloat itemH = 80;
    

    
    CGFloat biggerH = 2 * itemH;
    
    if (indexPath.item == 0) {
        
        attr.frame = CGRectMake(0, 0, itemW, biggerH);
        
    } else if (indexPath.item == 1) {
        
        attr.frame = CGRectMake(itemW, 0, itemW, itemH);
        
    } else if (indexPath.item == 2) {
        
        attr.frame = CGRectMake(itemW, itemH, itemW, itemH);
        
    } else if (indexPath.item == 3) {
        
        attr.frame = CGRectMake(0, biggerH, itemW, itemH);
        
    } else if (indexPath.item == 4) {
        
        attr.frame = CGRectMake(0, 3 * itemH, itemW, itemH);
        
    } else if (indexPath.item == 5) {
        
        attr.frame = CGRectMake(itemW, biggerH, itemW, biggerH);
        
    } else {
        
        UICollectionViewLayoutAttributes *lastAttr = self.attrsArrM[indexPath.item - 6];
        
        attr.frame = CGRectMake(lastAttr.frame.origin.x, lastAttr.frame.origin.y + 2 * biggerH, lastAttr.frame.size.width, lastAttr.frame.size.height);
        
    }
    NSLog(@"%@", NSStringFromCGRect(attr.frame));
    
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
