//
//  CZMusicPlayerController.m
//  customTransition
//
//  Created by 刘春牢 on 16/7/19.
//  Copyright © 2016年 刘春牢. All rights reserved.
//

#import "CZMusicPlayerController.h"
#import "CZCustomTransitionAnimator.h"

@interface CZMusicPlayerController ()

@end

@implementation CZMusicPlayerController {

    CZCustomTransitionAnimator *_animator;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        // 1.设置为自定义转场，就可以看到之前的视图！
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        // 2.设置专场动画的代理
        // - 需要 遵守 UIViewControllerTransitioningDelegate 的任意类型的对象
        // - 注意：默认是弱引用！weak修饰！ 需要定义成员变量接收！
        
        _animator = [[CZCustomTransitionAnimator alloc] init];
        self.transitioningDelegate = _animator;
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    // MARK: - 手势和按钮
    [self setupUI];
    
}

#pragma mark - 添加手势和dismiss按钮
- (void)setupUI {
    
    // MARK: - 1.按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:@"dismiss" forState:UIControlStateNormal];
    
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(40));
        make.width.equalTo(@(200));
        make.bottom.mas_equalTo(self.view).with.offset(-50);
        make.centerX.mas_equalTo(self.view);
        
    }];
    
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)dismiss {

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"music --- dealloc");
}
@end
