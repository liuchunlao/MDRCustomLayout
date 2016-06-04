//
//  MDRViewController.m
//  MDRCustomLayout
//
//  Created by 刘春牢 on 16/4/30.
//  Copyright © 2016年 liuchunlao. All rights reserved.
//

#import "MDRViewController.h"
#import "MDRCustomOne.h"
#import "MDRCustomTwo.h"
#import "MDRCustomThree.h"
#import "MDRCustomLayoutCell.h"


@interface MDRViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MDRViewController {

    UICollectionView *_collectionView;

}

static NSString *ID = @"collectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // MARK: - segment控件
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"one", @"tow", @"three"]];
    
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    
    
    // MARK: - collectionViewDelegate
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[MDRCustomThree alloc] init]];
    
    // 分页
    collectionView.pagingEnabled = YES;
    
    // 数据源和代理对象
    collectionView.dataSource = self;
    collectionView.delegate = self;
    
    collectionView.backgroundColor = [UIColor yellowColor];
    
    [collectionView registerNib:[UINib nibWithNibName:@"MDRCustomLayoutCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
    
    // MARK: - 横屏时铺满屏幕
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - 切换布局样式
- (void)segmentAction:(UISegmentedControl *)sender {
    
    UICollectionViewLayout *layout = nil;
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            
            layout = [[MDRCustomOne alloc] init];
            
            break;
            
        case 1:
            
            layout = [[MDRCustomTwo alloc] init];
            
            break;
            
        case 2:
            
            layout = [[MDRCustomThree alloc] init];
            
            break;
            
        default:
            break;
    }
    
    // MARK: - 防止循环引用
    typeof (_collectionView) weakCollectionView = _collectionView;
    [_collectionView setCollectionViewLayout:layout animated:YES completion:^(BOOL finished) {
        
        [weakCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop | UICollectionViewScrollPositionLeft animated:YES];
        
    }];
    
}



#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 33;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MDRCustomLayoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    
    cell.name = [NSString stringWithFormat:@"这是第 %zd 个 item", indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"选中了第 %@ 个item", @(indexPath.item));
    
}

@end

