//
//  MTFoodDetailController.h
//  MT_waimai[007]
//
//  Created by HM on 16/8/8.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MTBaseViewController.h"

@class MTShopFood;
@interface MTFoodDetailController : MTBaseViewController

/**
 *  要显示详情的菜品
 */
@property (strong, nonatomic) MTShopFood *foodModel;
/**
 *  正在显示的模型对应的索引!
 */
@property (strong, nonatomic) NSIndexPath *path;

@end
