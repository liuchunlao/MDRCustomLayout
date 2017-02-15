//
//  MTNormalController.m
//  MT_waimai[007]
//
//  Created by HM on 16/8/10.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MTNormalController.h"
#import "MTFoodDetailController.h"
#import "MTShopCategory.h"
#import "MTBottomCarView.h"
#import "MTShoppingCarListController.h"

@interface MTNormalController () <UIPageViewControllerDataSource, MTBottomCarViewDelegate>

/**
 *  底部的购物车视图
 */
@property (weak, nonatomic) MTBottomCarView *carView;

@end

@implementation MTNormalController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    // 视图加载完毕,再设置数据!
    _carView.shoppingCarList = _selectFoods;
    
    // MARK: - 监听添加到购物车按钮的通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addToCarViewNotification:) name:MTAddFoodToCarViewNotification object:nil];
}

- (void)addToCarViewNotification:(NSNotification *)noti {

    NSLog(@"%@ %@", noti.object, noti.userInfo);
    // 需要添加的菜品
    MTShopFood *food = noti.userInfo[MTAddFoodKey];
    CGPoint startPoint = [noti.userInfo[MTStartPointKey] CGPointValue];
    
    // MARK: - 添加模型数据信息到集合
    if (![_selectFoods containsObject:food]) {
        [_selectFoods addObject:food];
    }
    
    // 开始动画!
    // - 1.添加图片框
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_food_count_bg"]];
    imgView.center = startPoint;
    
    // - 将图片框添加给窗口
    UIWindow *keyW = [UIApplication sharedApplication].keyWindow;
    [keyW addSubview:imgView];
    
    // - 2.开启核心动画,让图片框运动
    // 1.创建对象
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // 通过kvc给动画绑定imgView!
    // 只有kvc可以这么做,其他的对象,不ok!
    [anim setValue:imgView forKey:@"imgV"];
    
    // 2.设置属性
    // - 路径对象
    UIBezierPath *path = [UIBezierPath bezierPath];
    // - 移动到起点
    [path moveToPoint:startPoint];
    // - 添加完美曲线!
    /**
     * 参数1 -> 结束时的点
     * 参数2 -> 控制点
     */
    // 结束点
    CGPoint endP = CGPointMake(50, keyW.bounds.size.height - 45);
    // 控制点
    CGPoint controlP = CGPointMake(startPoint.x - 130, startPoint.y - 120);
    // 添加完美路径
    [path addQuadCurveToPoint:endP controlPoint:controlP];
    
    anim.path = path.CGPath;
    
    // 不让闪回去
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    anim.duration = 1;
    
    // 设置动画的代理
    anim.delegate = self;
    
    // 3.添加
    [imgView.layer addAnimation:anim forKey:nil];
    
}

// 核心动画的代理方法
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    // 1.移除图片框
    // - 取出图片框
    UIImageView *imgV = [anim valueForKey:@"imgV"];
    // - 移除核心动画
    [imgV.layer removeAllAnimations];
    
    // - 移除
    [imgV removeFromSuperview];
    
    // 2.将数据信息传递给购物车视图!
    _carView.shoppingCarList = _selectFoods;
    
}
#pragma mark - 移除通知
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - MTBottomCarViewDelegate
- (void)bottomCarView:(MTBottomCarView *)carView needsDisplaySelectFoods:(NSMutableArray<MTShopFood *> *)selectFoods {

    MTShoppingCarListController *listVc = [[MTShoppingCarListController alloc] init];
    
    [self presentViewController:listVc animated:YES completion:nil];
    
}


#pragma mark - UIPageViewControllerDataSource
// 询问前一个控制器是谁?
#warning - 需要记录当前正在显示的模型对应的索引!

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(MTFoodDetailController *)viewController {

    NSLog(@"xxxx%@", viewController.path);
    // 上一个vc -> 需要设置显示的模型!
    // 1.取出当前显示的索引
    NSIndexPath *currentPath = viewController.path;
    
    NSInteger section = currentPath.section;
    NSInteger row = currentPath.row;
    
    row--;
    
    if (row < 0) {
        
        // 1.rwo< 0说明当前组的第0个正在显示 -> 上一组的最后一个!
        
        section--;
        if (section < 0) {
            NSLog(@"没有上一个啦!");
            return nil;
        }
        // 上一组的最后一个!
        row = _categoryList[section].spus.count - 1;
        
        
    }
   
    // 2.创建新的path
    NSIndexPath *newPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    return [self detailVcWithIndexPath:newPath];
}

// 询问下一个控制器是谁?
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(MTFoodDetailController *)viewController {
    
    NSLog(@"yyyyy%@", viewController.path);
    // 下一个vc -> 需要设置显示的模型!
    NSIndexPath *currentPath = viewController.path;
    
    // 往下走!
    NSInteger section = currentPath.section;
    NSInteger row = currentPath.row;
    
    row++;
    
    if (row == _categoryList[section].spus.count) {
        
        // 下一组,第0行
        section++;
        row = 0;
        
        if (section == _categoryList.count) {
            NSLog(@"已经是最后一个啦!"); // 通过SVProgressHUD给用户提示!
            return nil;
        }
    }
    
    // 创建indexPath
    NSIndexPath *nextPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    return [self detailVcWithIndexPath:nextPath];
}

#pragma mark - 搭建界面
- (void)setupUI {
 
    // 1.背景!
    self.view.backgroundColor = [UIColor yellowColor];
    
    // 2.添加pageVc!
    // - 创建对象!
    NSDictionary *dict = @{
                           // 针对 UIPageViewControllerTransitionStylePageCurl 样式!
//                           UIPageViewControllerOptionSpineLocationKey : @2
                           
                           // 针对 UIPageViewControllerTransitionStyleScroll 样式!
                           UIPageViewControllerOptionInterPageSpacingKey : @10
                           
                           };
    UIPageViewController *pageVc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:dict];
    
    pageVc.view.backgroundColor = [UIColor grayColor];
    
    // MARK: - 1.设置数据源对象!
    pageVc.dataSource = self;
    
    [pageVc setViewControllers:@[[self detailVcWithIndexPath:_path]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    // - 添加控制器及其视图!
    [self cz_addChildController:pageVc intoView:self.view];
    
    // 3.添加购物车视图
    MTBottomCarView *carV = [MTBottomCarView bottomCarView];
    carV.delegate = self;
    
    
    [self.view addSubview:carV];
    
    [carV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(46);
        
    }];
    
    // 记录成员变量
    _carView = carV;
    
}

#pragma mark - 创建详情vc的方法!
- (MTFoodDetailController *)detailVcWithIndexPath:(NSIndexPath *)indexPath {

    // 1.创建
    MTFoodDetailController *detailVc = [[MTFoodDetailController alloc] init];
    
    // 2.设置数据
    detailVc.foodModel = _categoryList[indexPath.section].spus[indexPath.row];
    
#warning - 让详情控制器负责记录正在显示的模型对应的索引!
    // 记录正在显示模型的索引信息
    detailVc.path = indexPath;
    
    // 3.返回对象
    return detailVc;

}



@end
