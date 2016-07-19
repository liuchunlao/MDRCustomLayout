//
//  MDRRotateController.m
//  MDRCustomLayout
//
//  Created by 刘春牢 on 16/7/19.
//  Copyright © 2016年 liuchunlao. All rights reserved.
//

#import "MDRRotateController.h"
#import "CZMusicPlayerController.h"

@interface MDRRotateController ()

@end

@implementation MDRRotateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.center = self.view.center;
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick {
    
    CZMusicPlayerController *playerVc = [[CZMusicPlayerController alloc] init];
    
    [self presentViewController:playerVc animated:YES completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
