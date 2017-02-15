//
//  MTFoodCell.h
//  MT_waimai[007]
//
//  Created by HM on 16/8/7.
//  Copyright © 2016年 HM. All rights reserved.
//

#import <UIKit/UIKit.h>

// 协议
@class MTShopFood, MTFoodCell;
@protocol MTFoodCellDelegate <NSObject>

@optional
/**
 *  cell里面要增加的菜品
 *  要有菜品,还需要起始点!
 */
- (void)foodCell:(MTFoodCell *)foodCell didFinishIncreseFood:(MTShopFood *)food andStartPoint:(CGPoint)startPoint;

/**
 *  cell里面减少的菜品
 */
- (void)foodCell:(MTFoodCell *)foodCell didFinishDecreseFood:(MTShopFood *)food;

@end



@interface MTFoodCell : UITableViewCell

/**
 *  该行cell负责显示的菜品模型数据
 */
@property (strong, nonatomic) MTShopFood *foodModel;

/**
 *  代理属性
 */
@property (weak, nonatomic) id<MTFoodCellDelegate> delegate;

@end
