//
//  ViewController.m
//  timeLine
//
//  Created by 刘春牢 on 16/6/9.
//  Copyright © 2016年 刘春牢. All rights reserved.
//

#import "TimelineController.h"
#import "MDRTimeCell.h"

@interface TimelineController () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation TimelineController {
    
    UITableView *_tableView;
    
    // 数据
    NSArray *_msgsArr;
    
    // 上线
    UIView *_topLine;
    
    // 下线
    UIView *_btmLine;
}


static NSString * const cellID = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerClass:[MDRTimeCell class] forCellReuseIdentifier:cellID];
    
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.rowHeight = 70;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:tableView];
    
    _tableView = tableView;
    
    // 两根线
    _topLine = [[UIView alloc] init];
    _topLine.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_topLine];
    
    
    _btmLine = [[UIView alloc] init];
    _btmLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_btmLine];
    
    
    
    
    _msgsArr = @[
                 @{
                     @"title"       : @"订单已提交",
                     @"subTitle"    : @"请耐心等待商家确认",
                     @"time"        : @"5月13日 16：18分"
                     },
                 @{
                     @"title"       : @"支付成功",
                     @"time"        : @"5月13日 16：18分"
                     },
                 @{
                     @"title"       : @"骑手正在赶往商家",
                     @"subTitle"    : @"骑手电话 138 **** 0074",
                     @"time"        : @"5月13日 16：20分"
                     },
                 @{
                     @"title"       : @"已送达",
                     @"time"        : @"5月13日 5点：25分"
                     }
                 ];
    
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _msgsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDRTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.item = _msgsArr[indexPath.row];
    
    int idx = (int)indexPath.row;
    
    NSLog(@"%@", @(idx));
    // 判断控制颜色 -> 最后一个cell下线显示浅灰色
    cell.bottomLine.backgroundColor = (idx ==  (_msgsArr.count - 1)) ? [UIColor lightGrayColor] : cell.upLine.backgroundColor;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MDRTimeCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _topLine.backgroundColor = cell.upLine.backgroundColor;
    
    [self scrollViewDidScroll:_tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _topLine.frame = CGRectMake(25, 0, 1, -scrollView.contentOffset.y);
    
    NSLog(@"%@", NSStringFromCGRect(_topLine.frame));
    
    CGFloat y = self.view.bounds.size.height - (scrollView.frame.size.height - scrollView.contentSize.height + scrollView.contentOffset.y);
    _btmLine.frame = CGRectMake(25, y, 1, self.view.bounds.size.height - y);
    
}
@end
