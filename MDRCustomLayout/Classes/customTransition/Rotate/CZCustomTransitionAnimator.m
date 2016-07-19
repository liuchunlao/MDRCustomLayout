//
//  CZCustomTransitionAnimator.m
//  customTransition
//
//  Created by 刘春牢 on 16/7/19.
//  Copyright © 2016年 刘春牢. All rights reserved.
//

#import "CZCustomTransitionAnimator.h"

@interface CZCustomTransitionAnimator () <UIViewControllerAnimatedTransitioning>

@end

@implementation CZCustomTransitionAnimator

#pragma mark - UIViewControllerTransitioningDelegate
#pragma mark - 谁负责实现转场动画！
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {

    // 当前类型的对象负责实现动画！
    // 注意：需要遵守协议！
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
// MARK: - 1 动画时长！
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.5;
}

// MARK: - 2 动画效果
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    // 1.获取容器视图
    UIView *containView = [transitionContext containerView];
    
    // 2.获取进行转场的vc
    // 2.1 获取vc
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 2.2 判断是否为正在present
    if (toVc.presentingViewController == fromVc) {
        NSLog(@"present");
        
        [containView addSubview:toVc.view];
        
#warning - 修改锚点和位置点 才能达到效果！
        CGSize size = toVc.view.bounds.size;
        toVc.view.layer.position = CGPointMake(size.width * 0.5, size.height * 1.5);
        toVc.view.layer.anchorPoint = CGPointMake(0.5, 1.5);
        
        // 3.修改toVc的transform
        toVc.view.transform = CGAffineTransformRotate(toVc.view.transform, -M_PI_2);
        toVc.view.alpha = 0;
        
        // 4.通过动画显示
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            toVc.view.transform = CGAffineTransformIdentity;
            toVc.view.alpha = 1;
            
        } completion:^(BOOL finished) {
            
            // 动画结束后，修复锚点和位置点！
            toVc.view.layer.position = containView.center;
            toVc.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
            
            [transitionContext completeTransition:YES];
        }];
        
    } else {
        
        NSLog(@"dismiss");
        CGSize size = fromVc.view.bounds.size;
        fromVc.view.layer.position = CGPointMake(size.width * 0.5, size.height * 1.5);
        fromVc.view.layer.anchorPoint = CGPointMake(0.5, 1.5);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
           
            fromVc.view.transform = CGAffineTransformRotate(fromVc.view.transform, M_PI_2);
            fromVc.view.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [fromVc.view removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    }
}


// MARK: - 3 销毁时的动画效果
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return self;
}

@end
