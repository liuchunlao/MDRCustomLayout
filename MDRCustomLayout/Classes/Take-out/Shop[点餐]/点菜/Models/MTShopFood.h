//
//  MTShopFood.h
//  MT_waimai[007]
//
//  Created by HM on 16/8/7.
//  Copyright © 2016年 HM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTShopFood : NSObject

/**
 *  菜品的图片
 */
@property (copy, nonatomic) NSString *picture;

/**
 *  菜品的名称
 */
@property (copy, nonatomic) NSString *name;

/**
 *  价格
 */
@property (strong, nonatomic) NSNumber *min_price;

/**
 *  月售数量
 */
@property (copy, nonatomic) NSString *month_saled_content;

/**
 *  赞的数量
 */
@property (strong, nonatomic) NSNumber *praise_num;

/**
 *  描述
 * 注意: 不能直接写description,在打印对象的时候,会调用description方法!不能重名
 */
@property (copy, nonatomic) NSString *desc;

/**
 *  负责记录自己的数量
 */
@property (assign, nonatomic) NSInteger orderCount;


@end
