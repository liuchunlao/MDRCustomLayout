//
//  MTShopFood.m
//  MT_waimai[007]
//
//  Created by HM on 16/8/7.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MTShopFood.h"

@implementation MTShopFood

#pragma mark - 重写description方法,返回具体的内容!
// 在NSLog的时候,会调用对象的description方法! 默认返回 <类型: 地址>!
- (NSString *)description {

    return [NSString stringWithFormat:@"\n%@ %@ \n%@  %@", _name, _min_price, _desc, @(_orderCount).description];
}

#pragma mark - 具体处理desc!
- (void)setValue:(id)value forKey:(NSString *)key {

    [super setValue:value forKey:key];
    
    // 单独处理desc!
    if ([key isEqualToString:@"description"]) {
        [super setValue:value forKey:@"desc"];
    }

}


#pragma mark - 防止崩溃!
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
