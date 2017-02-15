//
//  MTFoodViewController.m
//  MT_waimai[007]
//
//  Created by HM on 16/8/5.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MTFoodViewController.h"
#import "MTShopCategory.h"
#import "MTShopFood.h"
#import "MTCategoryCell.h"
#import "MTFoodCell.h"
#import "MTFoodHeaderView.h"
#import "MTBottomCarView.h"
#import "MTShoppingCarListController.h"
#import "MTNormalController.h"



// cell的重用标识符
static NSString *cellId = @"cellId";
// header的重用标识符
static NSString *headerId = @"headerId";

@interface MTFoodViewController () <UITableViewDelegate, UITableViewDataSource, MTFoodCellDelegate, MTBottomCarViewDelegate>

/**
 *  分类列表
 */
@property (weak, nonatomic) UITableView *tvCategory;

/**
 *  菜品列表
 */
@property (weak, nonatomic) UITableView *tvFood;

/**
 *  图片框  有问题!
 */
//@property (weak, nonatomic) UIImageView *imgView;

/**
 *  底部的购物车视图
 */
@property (weak, nonatomic) MTBottomCarView *carView;

@end

@implementation MTFoodViewController {

    /**
     *  保存所有分类数据的集合
     */
    NSArray<MTShopCategory *> *_categoryList;
    
    /**
     *  保存所有已经被用户选择菜品模型!
     */
    NSMutableArray<MTShopFood *> *_carList;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    // 打印第0个分类里面第0个菜品
//    NSArray *foods = _categoryList[0].spus;
//    NSLog(@"%@", foods);
    
    // 让分类视图,选中第一行!
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tvCategory selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
    
#warning - 实例化保存已选菜品的集合
    _carList = [NSMutableArray array];
    
    // MARK: - 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFoodNotification:) name:MTAddFoodToCarViewNotification object:nil];
}

- (void)addFoodNotification:(NSNotification *)noti {

    MTShopFood *addFood = noti.userInfo[MTAddFoodKey];
    
    if (![_carList containsObject:addFood]) {
        [_carList addObject:addFood];
    }
    
    // 让自己的购物车视图,更新数据!
    _carView.shoppingCarList = _carList;
    
    
    // 让菜品列表刷新
    [_tvFood reloadData];
    
}


#pragma mark - 移除通知
- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - 代理方法
// MTBottomCarViewDelegate
- (void)bottomCarView:(MTBottomCarView *)carView needsDisplaySelectFoods:(NSMutableArray<MTShopFood *> *)selectFoods {

    // 1.创建对象
    MTShoppingCarListController *listVc = [[MTShoppingCarListController alloc] init];
    
    // 2.modal
    [self presentViewController:listVc animated:YES completion:nil];

}


// ----- MTFoodCell
- (void)foodCell:(MTFoodCell *)foodCell didFinishIncreseFood:(MTShopFood *)food andStartPoint:(CGPoint)startPoint {
//    NSLog(@"%@ 增加菜品,来个动画", food);
    
    // MARK: - 0.保存菜品到集合中 -> 如果没有包含再进行添加!
    // [_carList containsObject:food] -> 判断数组集合中是否包含一个对象!
    if (![_carList containsObject:food]) {
        
        [_carList addObject:food];
    }
    
    // MARK: - 动画!
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
    _carView.shoppingCarList = _carList;

}

- (void)foodCell:(MTFoodCell *)foodCell didFinishDecreseFood:(MTShopFood *)food {
    
//    NSLog(@"%@ 减少菜品,不要动画", food);
    // 如果菜品的数量为0的话!移除!
    if (food.orderCount == 0) {
        [_carList removeObject:food];
    }
    
    // 赋值
    _carView.shoppingCarList = _carList;
}

// ----- tableView
// 选中的代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // 选中了分类里面的cell!
    if (tableView == _tvCategory) {
        
        // 需要让 菜品 列表进行滚动!
        // 选中分类的行 => 菜品列表对应的组!
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:indexPath.row];
        // 让列表视图滚动!
        [_tvFood scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        return;
    }
    
    // 选中了菜品里面的cell
    NSLog(@"food === cell");
    
#warning - 跳转到普通的控制器
    MTNormalController *normalVc = [[MTNormalController alloc] init];
    
    // 传递所有的菜品信息
    normalVc.categoryList = _categoryList;
    normalVc.path = indexPath;
    
    // 把已经选中的信息传过去!
    normalVc.selectFoods = _carList;
    
    [self.navigationController pushViewController:normalVc animated:YES];

}

// 将要显示cell的代理方法 -> 将要显示某一行cell时,调用的方法!
// Display 显示
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.如果是分类,直接返回
    if (tableView == _tvCategory) {
        return;
    }
    
    // 如果不是用户滚动的菜品,不做操作!
    if (!(_tvFood.isDragging || _tvFood.isDecelerating || _tvFood.isTracking)) {
        return;
    }

    // 2.菜品列表在滚动的时候,会显示下面的cell!
    NSLog(@"显示cell");
    
    // 计算需要选中的索引信息
    NSInteger row = indexPath.section;
    NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
    
    
    // 让分类列表选中行
    [_tvCategory selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionTop];

}


// 一定要设置组标题的高度,才会调用这个代理方法!
// 此方法,负责返回每组header对应的视图!
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // 0.如果是分类列表,直接返回
    if (tableView == _tvCategory) {
        return nil;
    }

    // 1.创建headerView
    MTFoodHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    
    // 2.设置数据
//    NSLog(@"header");
    headerView.headerTitle = _categoryList[section].name;
    
    // 3.返回
    return headerView;
}

#pragma mark - 数据源方法
// 组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // 判断列表是谁?
    // 分类列表
    if (tableView == _tvCategory) {
        
        return 1;
    }
    
    // 菜品列表 -> 有几个分类,就有几组菜品!
    return _categoryList.count;
}

// 行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 分类列表
    if (tableView == _tvCategory) {
        
        return _categoryList.count;
    }
    
    // 菜品列表 -> 得知道是哪组?
    // 获取组内所有数据
    NSArray *foodsArr = _categoryList[section].spus;
    
    return foodsArr.count;

}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.创建cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    // 1.1 分类的cell
    if (tableView == _tvCategory) {
        
        // 1.1.1 设置分类的数据
        ((MTCategoryCell *)cell).categoryModel = _categoryList[indexPath.row];
        
        // 1.1.2 返回cell!
        return cell;
    }
    // 1.2 菜品的cell
    ((MTFoodCell *)cell).foodModel = _categoryList[indexPath.section].spus[indexPath.row];
    
    // 1.3 设置菜品cell的代理
    ((MTFoodCell *)cell).delegate = self;
    
    // 3.返回cell!
    return cell;

}

// 显示组标题
#warning - 此方法中字符串的字体大小及样式都是固定的!不能进行修改!
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//    // 一定得写!
//    if (tableView == _tvCategory) {
//        return nil;
//    }
//    
//    // 菜品列表视图 -> 就是组模型的名称!
//    return _categoryList[section].name;
//    
//
//}

#pragma mark - 加载数据
- (void)loadData {

    // 1.url
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"food.json" withExtension:nil];
    // 2.data
    NSData *totalData = [NSData dataWithContentsOfURL:url];
    // 3.反序列化
    NSDictionary *totalDict = [NSJSONSerialization JSONObjectWithData:totalData options:0 error:nil];
    // 4.取出想要的数据
    NSArray<NSDictionary *> *categoryDictArr = totalDict[@"data"][@"food_spu_tags"];
    
    // 5.遍历转模型
    NSMutableArray *biggerM = [NSMutableArray array];
    
    [categoryDictArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // obj 代表的是分类的字典!
        MTShopCategory *categoryModel = [[MTShopCategory alloc] init];
        [categoryModel setValuesForKeysWithDictionary:obj];
        
        [biggerM addObject:categoryModel];
        
    }];
    
    // 6.赋值
    _categoryList = biggerM.copy;


}

#pragma mark - 搭建界面
- (void)setupUI {
 
    self.view.backgroundColor = [UIColor yellowColor];
    
    // MARK: - 1.左侧的分类列表视图
    UITableView *tvCategory = [[UITableView alloc] init];
    
    [self.view addSubview:tvCategory];
    
    [tvCategory mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.view);
        make.width.mas_equalTo(86);
        make.bottom.equalTo(self.view).offset(-46);
        
    }];
    
    
    // MARK: - 2.右侧的菜品列表视图
    UITableView *tvFood = [[UITableView alloc] init];
    
    [self.view addSubview:tvFood];
    
    [tvFood mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(tvCategory);
        make.right.equalTo(self.view);
        make.left.equalTo(tvCategory.mas_right);
        
    }];
    
    // MARK: -----设置列表的属性-------
    // 1.设置数据源和代理对象
    tvCategory.dataSource = self;
    tvCategory.delegate = self;
    
    tvFood.dataSource = self;
    tvFood.delegate = self;
    
    // 2.注册cell
    [tvCategory registerClass:[MTCategoryCell class] forCellReuseIdentifier:cellId];
    [tvFood registerClass:[MTFoodCell class] forCellReuseIdentifier:cellId];
    
    // 注册header! -> 负责注册tableView的组标题视图的!
    // 类型-> 继承自UITaleViewHeaderFooterView!
    [tvFood registerClass:[MTFoodHeaderView class] forHeaderFooterViewReuseIdentifier:headerId];
#warning - 一定要设置这个属性,才会调用对应的代理方法
    tvFood.sectionHeaderHeight = 23;
    
    // 3.不显示多余的行
    tvCategory.tableFooterView = [[UIView alloc] init];
    tvFood.tableFooterView = [[UIView alloc] init];
    
    // 4.隐藏指示条子
    tvCategory.showsVerticalScrollIndicator = NO;
    tvFood.showsVerticalScrollIndicator = NO;
    
    // 5.设置行高
    tvCategory.rowHeight = 55;
    
    // MARK: ----设置预估行高!
    tvFood.estimatedRowHeight = 120;
    tvFood.rowHeight = UITableViewAutomaticDimension;
    
    
    // 6.取消分割线
    tvCategory.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    // MARK: - 3.底部的购物占位视图
    MTBottomCarView *carV = [MTBottomCarView bottomCarView];
//    carV.backgroundColor = [UIColor magentaColor];
    
    carV.delegate = self;
    
    [self.view addSubview:carV];
    
    [carV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(tvCategory.mas_bottom);
        make.left.equalTo(tvCategory);
        make.right.equalTo(tvFood);
        make.bottom.equalTo(self.view);
        
    }];
    
    // MARK: - 4.记录成员变量
    _tvFood = tvFood;
    _tvCategory = tvCategory;
    _carView = carV;
    
}

@end
