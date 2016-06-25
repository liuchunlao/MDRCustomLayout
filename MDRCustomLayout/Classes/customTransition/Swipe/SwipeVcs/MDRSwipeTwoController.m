//
//  MDRSwipeTwoController.m
//  swipeModal
//
//  Created by 刘春牢 on 16/6/24.
//  Copyright © 2016年 刘春牢. All rights reserved.
//

#import "MDRSwipeTwoController.h"
#import "MDRSwipeTransitionDelegate.h"
#import "Masonry.h"

@interface MDRSwipeTwoController ()


@property (nonatomic, strong) id sender;

@end

@implementation MDRSwipeTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor magentaColor];
    
    // MARK: - 手势和按钮
    [self setupUI];

}

#pragma mark - 添加手势和dismiss按钮
- (void)setupUI {
    
    // MARK: - 1.策划手势
    UIScreenEdgePanGestureRecognizer *interactiveTransitionRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(interactiveTransitionRecognizerAction:)];
    
    interactiveTransitionRecognizer.edges = UIRectEdgeLeft;
    
    [self.view addGestureRecognizer:interactiveTransitionRecognizer];
    
    // MARK: - 2.按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"dismiss" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(40));
        make.width.equalTo(@(200));
        make.bottom.mas_equalTo(self.view).with.offset(-50);
        make.centerX.mas_equalTo(self.view);
        
    }];
    
    [btn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    

}

// 手势出发
- (void)interactiveTransitionRecognizerAction:(UIScreenEdgePanGestureRecognizer *)sender {

    if (sender.state == UIGestureRecognizerStateBegan) {
        
        self.sender = sender;
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

// 按钮出发
- (void)dismiss:(UIButton *)btn {
    
    self.sender = btn;
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 销毁时执行自定义的销毁方式
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    
    if (![self.transitioningDelegate isKindOfClass:[MDRSwipeTransitionDelegate class]]) {
    
        return;
    }
        
    MDRSwipeTransitionDelegate *transitionDelegate = self.transitioningDelegate;
    
    if ([self.sender isKindOfClass:UIGestureRecognizer.class]) {
        
        transitionDelegate.gestureRecognizer = self.sender;
    } else {
    
        transitionDelegate.gestureRecognizer = nil;
    }
    
    transitionDelegate.targetEdge = UIRectEdgeLeft;

    // dismiss销毁控制器
    [super dismissViewControllerAnimated:YES completion:nil];

}



- (void)dealloc {

    NSLog(@"dealloc");
}

@end
