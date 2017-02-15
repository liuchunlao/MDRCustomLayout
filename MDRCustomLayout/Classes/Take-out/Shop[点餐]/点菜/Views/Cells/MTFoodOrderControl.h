//
//  MTFoodOrderControl.h
//  MT_waimai[007]
//
//  Created by HM on 16/8/8.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MTBaseControl.h"

@interface MTFoodOrderControl : MTBaseControl

/**
 *  快速创建视图的方法
 */
+ (instancetype)foodOrderControl;

/**
 *  数量的属性! -> 记录菜品的数量
 *  下划线的成员变量
 *  set和get方法的声明和实现
 */
@property (assign, nonatomic) NSInteger count;

/**
 *  增加还是减少!
 */
@property (assign, nonatomic) BOOL isIncrease;

/**
 *  动画的起始点
 */
@property (assign, nonatomic) CGPoint startP;

@end
