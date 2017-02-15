//
//  MTShopViewController.m
//  MT_waimai[007]
//
//  Created by HM on 16/8/4.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MTShopViewController.h"
#import "MTCategoryView.h"

#define kHeaderHeight 123

@interface MTShopViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

/**
 *  顶部视图
 */
@property (weak, nonatomic) UIView *headerView;

/**
 *  中间的分类视图
 */
@property (weak, nonatomic) MTCategoryView *categoryView;

/**
 *  滚动视图
 */
@property (weak, nonatomic) UIScrollView *scrollView;

@end

@implementation MTShopViewController


#pragma mark - 监听事件
// 分类视图的值改变事件
- (void)categoryViewValuechanged:(MTCategoryView *)sender {

    NSLog(@"%zd", sender.pageNumber);
    // 让scrollView滚动
    CGRect rect = CGRectMake(_scrollView.bounds.size.width * sender.pageNumber, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    // 让scrollView滚动,把rect区域的内容展示出来!
    [_scrollView scrollRectToVisible:rect animated:YES];

}

#pragma mark - 代理方法
// UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 0.如果不是用户滚动的,就不要设置偏移量了!
    if (!(scrollView.isDecelerating || scrollView.isDragging || scrollView.isTracking)) {
        return;
    }

    // 1.获取内容的偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
//    NSLog(@"%f", offsetX);
    // 2.设置偏移距离给分类视图
    // 分类视图黄条的移动距离为 offsetX 的 3 分之 1
    _categoryView.offset_x = offsetX / 3;

}

// UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {

    return YES;
}


#pragma mark - 拖拽手势
- (void)panAction:(UIPanGestureRecognizer *)recognizer {

    
    // 1.获取用户的偏移量
    CGPoint translate = [recognizer translationInView:self.view];
    
#warning - 实用技巧 -> 如果用户在x方向偏移的比较多,那就直接返回!
    // 注意:需要取绝对值
    if (ABS(translate.x) > ABS(translate.y)) {
        return;
    }
    
    // 2.重置
    [recognizer setTranslation:CGPointZero inView:self.view];

//    NSLog(@"%f", translate.y);
    // 3.计算一个高度 -> 获取顶部视图本身的高度 ,进行计算!
    CGFloat height = translate.y + _headerView.bounds.size.height;
    
    // MARK: - 计算导航条的透明度!
    // - 计算单位透明度变化量
    CGFloat percent = 1.0 / (kHeaderHeight - 64);
    // - 计算需要的透明度
    CGFloat needAlpha = (height - 64) * percent;
    // - 真正需要的alpha
    CGFloat alpha = 1 - needAlpha;
    
    // - 修改透明度
    self.navigationController.navigationBar.alpha = alpha;
    
    
    // 4.2 不让超出范围 最大就是 123 最小高度 64!
    // 会有问题!
//    if (height > kHeaderHeight || height < 64) {
//        return;
//    }
    // 完善做法
    if (height > kHeaderHeight) {
        height = kHeaderHeight;
    }
    if (height < 64) {
        height = 64;
    }
    
    // 4.修改顶部视图的高度
    [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(height);
    }];
    
    // 5.布局子控件
    // layoutIfNeeded 强制视图重新布局自己的子控件!
    // 注意:如果需要做动画,那就必须使用 layoutIfNeeded
    [self.view layoutIfNeeded];
    
}

// 测试代码! 演示scrollView的滚动
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGRect rect = CGRectMake(_scrollView.bounds.size.width * 0, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    // 让scrollView滚动,把rect区域的内容展示出来!
    [_scrollView scrollRectToVisible:rect animated:YES];

}


#pragma mark - 搭建界面
- (void)setupUI {
 
    self.view.backgroundColor = [UIColor magentaColor];
    // MARK: - 1.设置标题
    self.navigationItem.title = @"粮新发现(上地店)";
    
    // MARK: - 2.让导航条透明!
    self.navigationController.navigationBar.alpha = 0;
    
    // MARK: - 3.搭建主视图界面!
    // 1.顶部视图
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor = [UIColor cz_randomColor];
    
    [self.view addSubview:headerV];
    
    [headerV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kHeaderHeight);
        
    }];
    
    // 2.中间的分类视图
    MTCategoryView *categoryV = [[MTCategoryView alloc] init];
    categoryV.backgroundColor = [UIColor lightGrayColor];
    
    // 2.2 监听事件 值改变事件
    [categoryV addTarget:self action:@selector(categoryViewValuechanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:categoryV];
    
    [categoryV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(headerV.mas_bottom);
        make.left.right.equalTo(headerV);
        make.height.mas_equalTo(37);
    }];
    
    
    // 3.底部的滚动视图 UIScrollView!
    UIScrollView *scrollV = [self setupContentView];
    
    [self.view addSubview:scrollV];
    
    [scrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(categoryV.mas_bottom);
        make.left.right.equalTo(categoryV);
        make.bottom.equalTo(self.view);
        
    }];
    
    // MARK: - 4.添加拖拽手势识别器
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    
    // 设置代理,解决冲突问题
    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
    
    // MARK: - 5.记录成员变量
    _headerView = headerV;
    _categoryView = categoryV;
    _scrollView = scrollV;
    
}

#pragma mark - 负责添加底部控制器视图的方法,并返回scrollView
- (UIScrollView *)setupContentView {
    
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    scrollV.backgroundColor = [UIColor whiteColor];
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.pagingEnabled = YES;
    
    // 设置代理!
    scrollV.delegate = self;
    
    // MARK: - 添加控制器的视图
    NSArray<NSString *> *clsNameArr = @[@"MTFoodViewController", @"MTAppraiseController", @"MTStoreController"];
    
    // 定义可变数组,负责存放底部控制器视图的view!
    NSMutableArray<UIView *> *tempArrM = [NSMutableArray array];
    
    [clsNameArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 根据字符串动态的创建类 & 对象
        Class cls = NSClassFromString(obj);
        
        UIViewController *vc = [[cls alloc] init];
        
        NSAssert([vc isKindOfClass:[UIViewController class]], @"%@ 控制器类名 写的不对!", obj);
        
        // 添加控制器视图!
        [self cz_addChildController:vc intoView:scrollV];
        
        // 添加view
        [tempArrM addObject:vc.view];
    }];
    
    // 布局控制器的视图
    // 三个摆开,x!
    [tempArrM mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    // y size!
    [tempArrM mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(scrollV);
        
        // 顶部距离 + 底部距离 + 自己的高度 才能够决定contentSize的高度!
        make.top.bottom.equalTo(scrollV);
        
    }];
    
    return scrollV;
}

















@end
