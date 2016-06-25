//
//  MDRSwipeOneController.m
//  swipeModal
//
//  Created by 刘春牢 on 16/6/24.
//  Copyright © 2016年 刘春牢. All rights reserved.
//

#import "MDRSwipeOneController.h"
#import "MDRSwipeTransitionDelegate.h"
#import "MDRSwipeTwoController.h"
#import "Masonry.h"

@interface MDRSwipeOneController ()


/** 懒加载转场代理对象 */
@property (nonatomic, strong) MDRSwipeTransitionDelegate *customTransitionDelegate;

/** 手势识别器 */
@property (nonatomic, weak) UIScreenEdgePanGestureRecognizer *sender;

@end

@implementation MDRSwipeOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    // MARK - 1.按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"从右侧modal出vc" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(40));
        make.width.equalTo(@(200));
        make.bottom.mas_equalTo(self.view).with.offset(-50);
        make.centerX.mas_equalTo(self.view);
        
    }];
    
    [btn addTarget:self action:@selector(modalTwoVc) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)modalTwoVc {
    // 1.创建2vc
    MDRSwipeTwoController *twoVc = [[MDRSwipeTwoController alloc] init];
    
    // 2.present显示
    [self presentViewController:twoVc animated:YES completion:nil];
    
}


- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {

    self.customTransitionDelegate.gestureRecognizer = nil;
    
    // 右侧 -> 从左侧出来
    self.customTransitionDelegate.targetEdge = UIRectEdgeRight;
    
    // 设置转场动画代理
    viewControllerToPresent.transitioningDelegate = self.customTransitionDelegate;
    
    // 设置样式
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    
    
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    
}


#pragma mark - 懒加载
- (MDRSwipeTransitionDelegate *)customTransitionDelegate {
    if (!_customTransitionDelegate) {
        _customTransitionDelegate = [[MDRSwipeTransitionDelegate alloc] init];
    }
    return _customTransitionDelegate;
}

@end
