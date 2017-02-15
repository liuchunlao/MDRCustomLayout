//
//  MTShopCategory.m
//  MT_waimai[007]
//
//  Created by HM on 16/8/7.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MTShopCategory.h"
#import "MTShopFood.h"

@implementation MTShopCategory

#pragma mark - 具体处理spus!
- (void)setValue:(id)value forKey:(NSString *)key {

    [super setValue:value forKey:key];
    
    // 单独处理spus的操作!
    if ([key isEqualToString:@"spus"]) {
        
        // 1.获取数据
//        NSLog(@"%@", value);
        NSArray<NSDictionary *> *foodsArr = value;
        
        // 2.转为模型数据
        NSMutableArray<MTShopFood *> *smallerArrM = [NSMutableArray array];
        [foodsArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            MTShopFood *foodModel = [[MTShopFood alloc] init];
            
            [foodModel setValuesForKeysWithDictionary:obj];
            
            [smallerArrM addObject:foodModel];
        }];
        
        // 3.赋值
        [super setValue:smallerArrM forKey:@"spus"];
        
    }
    
    
}


#pragma mark - 屏蔽崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
