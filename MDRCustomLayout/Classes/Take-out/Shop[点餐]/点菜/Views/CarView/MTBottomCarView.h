//
//  MTBottomCarView.h
//  MT_waimai[007]
//
//  Created by HM on 16/8/8.
//  Copyright © 2016年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTShopFood, MTBottomCarView;
@protocol MTBottomCarViewDelegate <NSObject>

@optional
- (void)bottomCarView:(MTBottomCarView *)carView needsDisplaySelectFoods:(NSMutableArray<MTShopFood *> *)selectFoods;

@end


@interface MTBottomCarView : UIView
/**
 *  负责创建视图的类方法
 */
+ (instancetype)bottomCarView;

/**
 *  接收到的菜品数据
 */
@property (strong, nonatomic) NSMutableArray<MTShopFood *> *shoppingCarList;

@property (weak, nonatomic) id<MTBottomCarViewDelegate> delegate;

@end
