//
//  MTBottomCarView.m
//  MT_waimai[007]
//
//  Created by HM on 16/8/8.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MTBottomCarView.h"
#import "MTShopFood.h"

@interface MTBottomCarView ()

/**
 *  显示车篮子的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *shoppingCarBtn;

/**
 *  车篮子右上角的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *numberBtn;

/**
 *  结账按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *checkaccountBtn;

/**
 *  显示价格的lbl
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

/**
 *  记录之前的数量
 */
@property (assign, nonatomic) NSInteger oldCount;

@end

@implementation MTBottomCarView

+ (instancetype)bottomCarView {

    return [[NSBundle mainBundle] loadNibNamed:@"MTBottomCarView" owner:nil options:nil].lastObject;

}

- (void)awakeFromNib {

    self.shoppingCarList = nil;
}

#pragma mark - 监听事件
/**
 *  车篮子按钮
 */
- (IBAction)shoppingCarBtnClick:(UIButton *)sender {

//    NSLog(@"显示购物车详情");
    if ([_delegate respondsToSelector:@selector(bottomCarView:needsDisplaySelectFoods:)]) {
        [_delegate bottomCarView:self needsDisplaySelectFoods:_shoppingCarList];
    }

}

/**
 *  结账按钮事件
 */
- (IBAction)checkAccountBtnClick:(UIButton *)sender {

    NSLog(@"结账");
}

#pragma mark - 设置数据
- (void)setShoppingCarList:(NSMutableArray<MTShopFood *> *)shoppingCarList {

    _shoppingCarList = shoppingCarList;
    
    // 计算 菜品数量  菜品总价 结账按钮的控制
    
    // 1.遍历集合进行计算
    __block NSInteger count = 0;
    __block float money = 0;
    
    [shoppingCarList enumerateObjectsUsingBlock:^(MTShopFood * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 计算数量
        count += obj.orderCount;
        
        // 计算价格
        money += (obj.orderCount * obj.min_price.floatValue);
        
    }];
    
    NSLog(@"\n数量 %@  价格 %@", @(count), @(money));
    
    // 详细的控制
    // 最左侧按钮的控制
    if (count > 0) {
        [_numberBtn setTitle:@(count).description forState:UIControlStateNormal];
        _numberBtn.hidden = NO;
        
        _shoppingCarBtn.selected = YES;
    } else {
        
        _numberBtn.hidden = YES;
        
        _shoppingCarBtn.selected = NO;
        
    }
    
    // 中间label的控制
    if (money > 0) {
        _priceLbl.text = [@"¥ " stringByAppendingFormat:@"%.2f", money];
        _priceLbl.textColor = [UIColor redColor];
        
    } else {
        
        _priceLbl.text = @"购物车空空如也~";
        _priceLbl.textColor = [UIColor cz_colorWithHex:0x808080];
    }
    
    // 结账按钮的控制
    if (money > 20) {
        [_checkaccountBtn setTitle:@"结账" forState:UIControlStateNormal];
        [_checkaccountBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _checkaccountBtn.backgroundColor = [UIColor yellowColor];
        
    } else {
        
        float shortMoney = 20 - money;
        NSString *shortTitle = [@"还差 " stringByAppendingFormat:@"%.2f", shortMoney];
        [_checkaccountBtn setTitle:shortTitle forState:UIControlStateNormal];
        [_checkaccountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _checkaccountBtn.backgroundColor = [UIColor cz_colorWithHex:0xCCCCCC];
    }
    
    // 抖一抖
    /**
     参数1 动画的时长
     参数2 延时多长时间开始动画! 0
     参数3 震动的幅度!
     参数4 运动的速度
     参数5 动画的选项 -> 枚举
     参数6 执行动画的代码
     参数7 动画结束后需要做的操作
     */
    // 增加的时候,做动画
    if (count > _oldCount) {
        
        _shoppingCarBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            _shoppingCarBtn.transform = CGAffineTransformIdentity;
            
        } completion:nil];
    }
    
    // 记录新的数量
    _oldCount = count;
    
}














@end
