//
//  MDRRecordVedioController.m
//  MDRCustomLayout
//
//  Created by 刘春牢 on 16/5/22.
//  Copyright © 2016年 liuchunlao. All rights reserved.
//

#import "MDRRecordVedioController.h"
#import "Masonry.h"

@interface MDRRecordVedioController ()

@end

@implementation MDRRecordVedioController {

    UIView *_containView; // 包含按钮的父视图
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // MARK: - 搭建界面
    [self setupUI];
    
    // MARK: - 设置约束
    [self seupContraints];
    
}


#pragma mark - 通过系统提供的UIImagePickerController录制视频
- (void)throughImagePickerControllerRecordVedio {

}

#pragma mark - 通过AVFoudation提供的API录制视频
- (void)throughAvfoundationRecordVedio {
    
}

#pragma mark - 通过AVCaptureOutput录制视频
- (void)throughAVCaptureDataOutputAndAVAssetWriterRecordVedio {
    
}


#pragma mark - 监听按钮点击事件
- (void)btnClick:(UIButton *)sender {

    NSInteger idx = [_containView.subviews indexOfObject:sender];
    
    switch (idx) {
        case 0:
            NSLog(@"picker");
            [self throughImagePickerControllerRecordVedio];
            break;
        case 1:
            NSLog(@"avfoundation");
            [self throughAvfoundationRecordVedio];
            break;
        case 2:
            NSLog(@"acaudio");
            [self throughAVCaptureDataOutputAndAVAssetWriterRecordVedio];
            break;
            
        default:
            break;
    }

}

#pragma mark - 搭建界面
- (void)setupUI {
    
    UIView *containerV = [[UIView alloc] init];
    [self.view addSubview:containerV];
    _containView = containerV;
    
    NSArray *titleArr = @[@"UIImagePickerController", @"AVFoundation", @"AVCaptureOutput & AVAssetWriter"];
    
    [titleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:obj forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
        
        [_containView addSubview:btn];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

#pragma mark - 设置约束
- (void)seupContraints {
    
    [_containView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.mas_topLayoutGuide); // y
        make.left.right.mas_equalTo(self.view);        // x & width
    }];
    
    [_containView.subviews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:20 tailSpacing:20];
    
    [_containView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_containView);
        make.height.mas_equalTo(35);
    }];
}

@end
