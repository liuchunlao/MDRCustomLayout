//
//  MTNormalController.h
//  MT_waimai[007]
//
//  Created by HM on 16/8/10.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MTBaseViewController.h"

@class MTShopCategory;
@interface MTNormalController : MTBaseViewController

/**
 *  接收所有的数据信息!
 */
@property (strong, nonatomic) NSArray<MTShopCategory *> *categoryList;

/**
 *  记录第一次需要展示的菜品对应的索引!
 */
@property (strong, nonatomic) NSIndexPath *path;


/**
 *  负责接收已经选中的菜品信心
 */
@property (strong, nonatomic) NSMutableArray *selectFoods;

@end
