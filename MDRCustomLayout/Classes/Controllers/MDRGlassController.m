//
//  MDRGlassController.m
//  MDRCustomLayout
//
//  Created by 刘春牢 on 16/5/20.
//  Copyright © 2016年 liuchunlao. All rights reserved.
//

#import "MDRGlassController.h"
#import "Masonry.h"

@interface MDRGlassController ()

@property (nonatomic, strong) NSArray *btnsArr;

@end

@implementation MDRGlassController {

    
    UIButton            *_firstBtn;         // 按钮
    
    UIVisualEffectView  *_effectView;       // 毛玻璃
    
    UILabel             *_textLabel;         // 文本视图
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.layer.contents = (__bridge id)[UIImage imageNamed:@"baby"].CGImage;
    
    [self setupUI];
    
    [self setupContraints];
}

#pragma mark - 监听事件
- (void)btnClick:(UIButton *)sender {

    sender.backgroundColor = [UIColor lightGrayColor];
    
    int idx = (int)[_btnsArr indexOfObject:sender];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:idx];
    
    _effectView.effect = effect;

}


#pragma mark - 搭建界面
- (void)setupUI {
    /**
     UIBlurEffectStyleExtraLight,
     UIBlurEffectStyleLight,
     UIBlurEffectStyleDark
     */

    // MARK: - 按钮
    NSArray *titleArr = @[@"extralight", @"light", @"dark"];
    
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3];
    [titleArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (idx == 0) {
            _firstBtn = btn;
        }
        
        [btn setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0]];
        [btn setTitle:obj forState:UIControlStateNormal];
        
        [self.view addSubview:btn];
    
        [temp addObject:btn];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }];
    
    _btnsArr = temp.copy;
    
    // MARK: - EffectView
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    
    [self.view addSubview:effectView];
    _effectView = effectView;
    
    // MARK: - 文本内容
    UILabel *textLbl = [[UILabel alloc] init];
    
    textLbl.backgroundColor = [UIColor lightGrayColor];
    
    textLbl.numberOfLines = 0;
    textLbl.text = @"这是一个毛玻璃的效果\n系统提供的有3种样式\n注意：添加子控件的时候，\n需要添加到contentView中";
    
    [effectView.contentView addSubview:textLbl];
    
    _textLabel = textLbl;
}

#pragma mark - 设置约束
- (void)setupContraints {

    // MARK: - 按钮的约束
    [self.btnsArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:30 tailSpacing:30];
    
    [self.btnsArr mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(self.mas_topLayoutGuide).with.offset(20);
        
    }];
    
    // MARK: - EffectView的约束
    UIEdgeInsets insets = UIEdgeInsetsMake(20, 20, -20, -20);
    [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_offset(insets.left);
        make.bottom.mas_offset(insets.bottom);
        make.right.mas_offset(insets.right);
        make.top.mas_equalTo(_firstBtn.mas_bottom).with.offset(insets.top);
    }];
    
    
    // MARK: - textLabel
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(250);
        make.height.mas_equalTo(100);
        make.center.mas_equalTo(_effectView);
    }];

}

@end
