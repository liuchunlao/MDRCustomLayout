//
//  MDRRecordVedioController.m
//  MDRCustomLayout
//
//  Created by 刘春牢 on 16/5/22.
//  Copyright © 2016年 liuchunlao. All rights reserved.
//
//  学习网址：http://ios.jobbole.com/85069/

#import "MDRRecordVedioController.h"

#warning 必须要导入这个头文件才能设置录制视频的mediaType
#import <MobileCoreServices/MobileCoreServices.h>

#import <Photos/Photos.h>

#import "Masonry.h"
#import "MDRSessionController.h"

@interface MDRRecordVedioController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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

    // 1.实例化相机之前，先检查设置是否支持录制
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"支持相机使用");
        
        // 1.1 实例化
        UIImagePickerController *imgPickerVc = [[UIImagePickerController alloc] init];
        
        // 1.2 设置类型
        imgPickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // 1.3 设置格式 -> 直接录制视频【需要导入头文件才能进行设置】
        imgPickerVc.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
        
        // 1.4 同时支持拍照和录制视频
        // imgPickerVc.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        // 1.5 设置用哪个相机进行录制【前置或后置】
        // imgPickerVc.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        
        // 1.6 设置录制视频的画面清晰度【6种】
        // imgPickerVc.videoQuality = UIImagePickerControllerQualityTypeHigh;
        
        // 1.7 对录视频界面进行缩放或旋转等操作
        // imgPickerVc.cameraViewTransform = CGAffineTransformMakeScale(0.5, 0.5);
        
        // MARK: - 自定义视图界面
//        {
//            // 隐藏系统提供的按钮
//            imgPickerVc.showsCameraControls = NO;
//            
//            // 自定义界面
//            UIView *redV = [[UIView alloc] initWithFrame:imgPickerVc.view.bounds];
//            redV.backgroundColor = [UIColor redColor];
//            redV.alpha = 0.3;
//            // 添加按钮，自己执行录制和停止的功能 start 和 stop等方法
//            
//            // 设置给自定义view
//            imgPickerVc.cameraOverlayView = redV;
//        }
        
        // 1.9 设置代理
        imgPickerVc.delegate = self;
        
        /**
         Snapshotting a view that has not been rendered results in an empty snapshot. Ensure your view has been rendered at least once before snapshotting or snapshot after screen updates
         */
        [self presentViewController:imgPickerVc animated:YES completion:nil];
        
        
    } else {
        NSLog(@"当前设置不支持视频录制");
    }
    
}


// MARK: - iamgePickerController的代理方法
// MARK: - 点击取消按钮调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"点击了取消按钮");
    [self dismissViewControllerAnimated:YES completion:nil];
}

// MARK: - 视频录制成功后，点击使用视频时调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {

    NSLog(@"包含视频type和url的字典%@", info);
    NSURL *videoUrl = info[UIImagePickerControllerMediaURL];
    
    // 检查用户许可
    [self checkPhotoAccess];
    
    // 存储视频
    [self saveVedioToPhotosAlbum:videoUrl];
    
    /**
     // 系统报错
     -[UIWindow endDisablingInterfaceAutorotationAnimated:] called on <UIWindow: 0x15567bc10; frame = (0 0; 375 667); autoresize = W+H; gestureRecognizers = <NSArray: 0x15567d470>; layer = <UIWindowLayer: 0x15567b7d0>> without matching -beginDisablingInterfaceAutorotation. Ignoring.
     */
    [self dismissViewControllerAnimated:YES completion:nil];
}

// MARK: - 检查用户许可
- (void)checkPhotoAccess {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        
        switch (status) {
            case PHAuthorizationStatusAuthorized:
                
                NSLog(@"已经同意了");
                
                break;
            case PHAuthorizationStatusDenied:
                
                NSLog(@"拒绝");
                
                break;
            case PHAuthorizationStatusRestricted:
                NSLog(@"有限制");
                
                break;
            case PHAuthorizationStatusNotDetermined:
                
                NSLog(@"没有决定");
                
                break;
                
            default:
                break;
        }
        
    }];
  

    
}
// MARK: - 存储视频
- (void)saveVedioToPhotosAlbum:(NSURL *)videoUrl {
   
    // 获取相册资源库
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    
    // 让资源库将请求存储进去
    [library performChanges:^{
        
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoUrl];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        if (success) {
            NSLog(@"保存成功");
        } else {
            NSLog(@"视频保存失败 -> %@", error);
        }
        
    }];
    
}

#pragma mark - 通过AVFoudation提供的API录制视频
- (void)throughAvfoundationRecordVedio {
    
    MDRSessionController *sessionVc = [[MDRSessionController alloc] init];
    
    
    [self presentViewController:sessionVc animated:YES completion:nil];
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
