//
//  MDRTimeCell.h
//  timeLine
//
//  Created by 刘春牢 on 16/6/9.
//  Copyright © 2016年 刘春牢. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDRTimeCell : UITableViewCell

/** 数据 */
@property (nonatomic, strong) NSDictionary *item;

/** 上线 */
@property (nonatomic, weak) UIView *upLine;

/** 下线 */
@property (nonatomic, weak) UIView *bottomLine;


@end
