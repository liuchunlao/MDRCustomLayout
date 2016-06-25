//
//  MDRSwipeTransitionDelegate.h
//  swipeModal
//
//  Created by 刘春牢 on 16/6/24.
//  Copyright © 2016年 刘春牢. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MDRSwipeTransitionDelegate : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *gestureRecognizer;

@property (nonatomic, readwrite) UIRectEdge targetEdge;


@end
