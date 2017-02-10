//
//  MDRLinerController.m
//  MDRCustomLayout
//
//  Created by 刘春牢 on 16/5/20.
//  Copyright © 2016年 liuchunlao. All rights reserved.
//

#import "MDRLinerController.h"
#import "UIView+MDRExtension.h"
#import "MDRLinerFlowLayout.h"
#import "MDRCustomLayoutCell.h"

@interface MDRLinerController () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation MDRLinerController


NSString * const cellId = @"liner";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"LinerScale";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // MARK: - collectionView
    MDRLinerFlowLayout *linerLayout = [[MDRLinerFlowLayout alloc] init];
    
    
    
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:linerLayout];
    
#warning - iOS 10以后以为预设二出现闪屏的问题
    collectionV.prefetchingEnabled = NO;
    
    collectionV.backgroundColor = [UIColor lightGrayColor];
    
    collectionV.dataSource = self;
    collectionV.delegate = self;
    
    [collectionV registerClass:[MDRCustomLayoutCell class] forCellWithReuseIdentifier:cellId];
    
    [self.view addSubview:collectionV];
    
    
    [collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(200);
        make.width.mas_equalTo(self.view);
        
        make.center.mas_equalTo(self.view);
        
    }];
    
}




#pragma mark - dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    MDRCustomLayoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    cell.name = [NSString stringWithFormat:@"这是第 %zd 个 item", indexPath.item];
    
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];

    return cell;
    
}












@end
