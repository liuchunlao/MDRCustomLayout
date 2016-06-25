//
//  MDRSwipeTransitionInteractionController.h
//  swipeModal
//
//  Created by 刘春牢 on 16/6/24.
//  Copyright © 2016年 刘春牢. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDRSwipeTransitionInteractionController : UIPercentDrivenInteractiveTransition


- (instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer edgeForDragging:(UIRectEdge)edge NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;


@end
