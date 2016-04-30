//
//  MDRCustomLayoutCell.m
//  MDRCustomLayout
//
//  Created by 刘春牢 on 16/4/30.
//  Copyright © 2016年 liuchunlao. All rights reserved.
//

#import "MDRCustomLayoutCell.h"

@interface MDRCustomLayoutCell ()

@property (nonatomic, weak) IBOutlet UILabel *textLabel;

@end

@implementation MDRCustomLayoutCell


- (void)setName:(NSString *)name {

    _name = name;
    
    self.textLabel.text = name;

}


@end
