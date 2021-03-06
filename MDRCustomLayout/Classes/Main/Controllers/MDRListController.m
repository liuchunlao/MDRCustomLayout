//
//  MDRListController.m
//  MDRCustomLayout
//
//  Created by 刘春牢 on 16/5/20.
//  Copyright © 2016年 liuchunlao. All rights reserved.
//

#import "MDRListController.h"

@interface MDRListController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *listArr;

@end

@implementation MDRListController

NSString * const cellID = @"cellID";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // MARK: - 1.tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
    [self.view addSubview:tableView];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}


#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 获取选中的数据
    NSDictionary *cellItem = self.listArr[indexPath.section][@"items"][indexPath.row];
    
    // 获取目标控制器字符串
    NSString *vcStr = cellItem[@"targetVc"];
    
    Class calssName = NSClassFromString(vcStr);
    UIViewController *obj = [[calssName alloc] init];
    
    NSAssert([obj isKindOfClass:[UIViewController class]], @"%@ - 类名有错误", vcStr);
    
    obj.navigationItem.title = cellItem[@"title"];
    
    if (obj != nil) {
        [self.navigationController pushViewController:obj animated:YES];
    }

}


#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.listArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.listArr[section][@"items"] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    NSDictionary *cellItem = self.listArr[indexPath.section][@"items"][indexPath.row];
    
    
    cell.textLabel.text = cellItem[@"title"];
    
    
    return cell;
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return self.listArr[section][@"header"];
}

#pragma mark - lazy
- (NSArray *)listArr {
    
    if (_listArr == nil) {
        
        _listArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"HomeList.plist" ofType:nil]];
    }
                     
    return _listArr;
}



@end
