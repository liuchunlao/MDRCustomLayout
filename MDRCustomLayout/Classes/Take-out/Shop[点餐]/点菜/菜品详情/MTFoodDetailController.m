//
//  MTFoodDetailController.m
//  MT_waimai[007]
//
//  Created by HM on 16/8/8.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MTFoodDetailController.h"
#import "MTFoodDetailHeaderView.h"
#import "UIImageView+WebCache.h"
#import "MTShopFood.h"


#define kTopImgVHeight 280

static NSString *cellID = @"cellID";
@interface MTFoodDetailController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tv;


/**
 *  图片框高度的约束!
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVH;

/**
 *  图片框
 */
@property (weak, nonatomic) IBOutlet UIImageView *iv;



@end

@implementation MTFoodDetailController

#pragma mark - 搭建界面
- (void)setupUI {
    
    // 1.设置基本属性,实现偏移
    _tv.contentInset = UIEdgeInsetsMake(kTopImgVHeight, 0, 0, 0);
    _tv.backgroundColor = [UIColor clearColor];
    _tv.showsVerticalScrollIndicator = NO;
    
    _tv.tableFooterView = [[UIView alloc] init];
    
//    _tv.scrollIndicatorInsets = UIEdgeInsetsMake(kTopImgVHeight, 0, 0, 0) ;
    
    // 2.设置headerView
    MTFoodDetailHeaderView *headerV = [MTFoodDetailHeaderView foodDetailHeaderView];
    
    headerV.bounds = CGRectMake(0, 0, 0, 200);
    
    _tv.tableHeaderView = headerV;

    // 3.设置数据
    // 3.1 设置图片框的图片
    // - urlStr图片链接的字符串
    NSString *urlStr = [_foodModel.picture stringByDeletingPathExtension];
    // - 转为URL
    NSURL *url = [NSURL URLWithString:urlStr];
    // - 设置图片
    [_iv sd_setImageWithURL:url];
    
    // 3.2 设置菜品的详情
    headerV.foodM = _foodModel;
}

#pragma mark - 代理方法
// 只要内容发生偏移就会调用!
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    // 1.获取内容的偏移量 y!
    CGFloat offsetY = scrollView.contentOffset.y;
    
    NSLog(@"%f", offsetY);
    //2.修改图片框的高度的约束!
    // - 计算目标的高度
//    CGFloat height = kTopImgVHeight - (offsetY + 280);
    CGFloat height = - offsetY;
    
    // 如果高度 < 0, 就直接 = 0;
    if (height < 0) {
        height = 0;
    }
    
    // - 修改约束
    _imgVH.constant = height;

}



@end
