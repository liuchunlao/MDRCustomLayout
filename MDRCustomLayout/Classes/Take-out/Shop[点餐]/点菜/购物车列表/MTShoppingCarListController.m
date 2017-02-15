//
//  MTShoppingCarListController.m
//  MT_waimai[007]
//
//  Created by HM on 16/8/8.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MTShoppingCarListController.h"
#import "MTCustomModal.h"


static NSString *cellID = @"cellID";

@interface MTShoppingCarListController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tv;

@end

@implementation MTShoppingCarListController {

    /**
     * 负责自定义modal的成员变量 -> 强引用!
     */
    MTCustomModal *_cstModal;
}

#pragma mark - 自定义modal的关键设置
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 设置这个属性保证可以看到背后的视图!
        self.modalPresentationStyle = UIModalPresentationCustom;
        
        // 设置代理
        _cstModal = [[MTCustomModal alloc] init];
        self.transitioningDelegate = _cstModal;
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [_tv registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.textLabel.text = @(indexPath.row).description;
    return cell;
    

}



@end
