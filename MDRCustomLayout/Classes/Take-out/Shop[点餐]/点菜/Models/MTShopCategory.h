//
//  MTShopCategory.h
//  MT_waimai[007]
//
//  Created by HM on 16/8/7.
//  Copyright © 2016年 HM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTShopFood;
@interface MTShopCategory : NSObject

/**
 *  分类名称
 */
@property (copy, nonatomic) NSString *name;

/**
 *  分类里面所有的菜品
 */
@property (strong, nonatomic) NSArray<MTShopFood *> *spus;


@end
