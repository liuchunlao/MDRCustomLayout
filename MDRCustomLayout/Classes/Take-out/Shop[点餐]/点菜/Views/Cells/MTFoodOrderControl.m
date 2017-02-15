//
//  MTFoodOrderControl.m
//  MT_waimai[007]
//
//  Created by HM on 16/8/8.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MTFoodOrderControl.h"

@interface MTFoodOrderControl ()

/**
 *  减少的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *decreaseBtn;

/**
 *  显示数量的label
 */
@property (weak, nonatomic) IBOutlet UILabel *numberLbl;

@end

@implementation MTFoodOrderControl

#pragma mark - 加载视图
+ (instancetype)foodOrderControl {

    return [[NSBundle mainBundle] loadNibNamed:@"MTFoodOrderControl" owner:nil options:nil].lastObject;

}


#pragma mark - 初始化设置
- (void)awakeFromNib {

    // 初始化设置!
    self.count = 0;
}


#pragma mark - 按钮事件
/**
 *  减少数量
 */
- (IBAction)decreaseBtnClick:(UIButton *)sender {

    // 通过self. 点语法,调用count的set方法!
    self.count--;
    
    // 减少
    _isIncrease = NO;

    // 数量减少,发送事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

/**
 *  增加数量
 */
- (IBAction)increaseBtnClick:(UIButton *)sender {
    // 通过self. 点语法,调用count的set方法
    self.count++;
    
    // 增加
    _isIncrease = YES;
    
    // 起始点 -> 相对于窗口!
    // 转换坐标
//    NSLog(@"-> 前  %@", NSStringFromCGPoint(sender.center));
    UIWindow *keyW = [UIApplication sharedApplication].keyWindow;
    _startP = [self convertPoint:sender.center toView:keyW];
    
//    NSLog(@"-> 后  %@", NSStringFromCGPoint(_startP));
    // 数量增加,发送事件!
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - 重写set方法,实现数量控制
- (void)setCount:(NSInteger)count {
    _count = count;

    // 判断数量,控制控件是否隐藏
    if (count > 0) {
        // 数量有值,可以进行减少的功能!
        _decreaseBtn.hidden = NO;
        _numberLbl.hidden = NO;
    } else {
        
        // 数量为0,隐藏控件!
        _decreaseBtn.hidden = YES;
        _numberLbl.hidden = YES;
    }
    
    // 将数量信息显示到label上!
    _numberLbl.text = @(count).description;
    
}


@end
