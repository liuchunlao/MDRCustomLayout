//
//  MTFoodDetailHeaderView.m
//  MT_waimai[007]
//
//  Created by HM on 16/8/10.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MTFoodDetailHeaderView.h"
#import "MTShopFood.h"

@interface MTFoodDetailHeaderView ()

/**
 *  名称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
/**
 *  月售
 */
@property (weak, nonatomic) IBOutlet UILabel *monthLbl;

/**
 *  价格
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
/**
 *  简介
 */
@property (weak, nonatomic) IBOutlet UILabel *commentLbl;


@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end


@implementation MTFoodDetailHeaderView

#pragma mark - 创建视图的类方法
+ (instancetype)foodDetailHeaderView {

    return [[NSBundle mainBundle] loadNibNamed:@"MTFoodDetailHeaderView" owner:nil options:nil].lastObject;

}

- (void)awakeFromNib {

    self.foodM = nil;
    
    _addBtn.layer.cornerRadius = 4;
    _addBtn.layer.masksToBounds = YES;
}

#pragma mark - 添加到购物车按钮的事件
- (IBAction)addToCarViewBtnClick:(UIButton *)sender {

    // 目标:需要让普通控制器做动画!并改变数据! 让点菜控制器改变数据!
    // 通过通知来实现! -> 菜品! 按钮的中心点!
    
    // 按钮的中心点 -> 转为相对于窗口的一个点
    UIWindow *keyW = [UIApplication sharedApplication].keyWindow;
    CGPoint startPoint = [self convertPoint:sender.center toView:keyW];
    
    // 发通知 -> 通知中心负责所有的监听和发送操作 单例!
    // 需要传递的信息
    _foodM.orderCount++;
    
    NSDictionary *userInfo = @{
                               MTAddFoodKey : _foodM,
                               MTStartPointKey : [NSValue valueWithCGPoint:startPoint]
                               };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MTAddFoodToCarViewNotification object:self userInfo:userInfo];

}


#pragma mark - 设置数据
- (void)setFoodM:(MTShopFood *)foodM {

    _foodM = foodM;
    // 分发数据
    _nameLbl.text = foodM.name;
    _monthLbl.text = foodM.month_saled_content;
    _priceLbl.text = [@"¥ " stringByAppendingFormat:@"%.2f", foodM.min_price.floatValue];
    
    _commentLbl.text = [@"好吃不贵 " stringByAppendingFormat:@"%@", _priceLbl.text];
}


















@end
