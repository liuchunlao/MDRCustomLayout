//
//  MTFoodCell.m
//  MT_waimai[007]
//
//  Created by HM on 16/8/7.
//  Copyright © 2016年 HM. All rights reserved.
//

#import "MTFoodCell.h"
#import "MTShopFood.h"
#import "UIImageView+WebCache.h"
#import "MTFoodOrderControl.h"

@interface MTFoodCell ()

/**
 *  图片
 */
@property (weak, nonatomic) UIImageView *iconView;

/**
 *  名称
 */
@property (weak, nonatomic) UILabel *nameLbl;

/**
 *  月售
 */
@property (weak, nonatomic) UILabel *monthLbl;

/**
 *  赞数量
 */
@property (weak, nonatomic) UILabel *starLbl;

/**
 *  价格
 */
@property (weak, nonatomic) UILabel *priceLbl;

/**
 *  描述
 */
@property (weak, nonatomic) UILabel *descLbl;

/**
 *  负责显示菜品数量的控件
 */
@property (weak, nonatomic) MTFoodOrderControl *orderControl;

@end

@implementation MTFoodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }

    return self;
}

#pragma mark - 监听数量改变的事件
- (void)orderControlValueChanged:(MTFoodOrderControl *)sender {

//    NSLog(@"%@", @(sender.count));
    // 1.将接收的数量信息,设置给自己的模型!
    _foodModel.orderCount = sender.count;
    
    // 2.搞清楚,是增加还是减少
    if (sender.isIncrease) {
//        NSLog(@"增加,需要动画");
        if ([_delegate respondsToSelector:@selector(foodCell:didFinishIncreseFood:andStartPoint:)]) {
            
            [_delegate foodCell:self didFinishIncreseFood:_foodModel andStartPoint:sender.startP];
        }
        
        
    } else {
//        NSLog(@"减少,不需要动画");
        if ([_delegate respondsToSelector:@selector(foodCell:didFinishDecreseFood:)]) {
            [_delegate foodCell:self didFinishDecreseFood:_foodModel];
        }
        
    }
    

}

#pragma mark - 设置数据
- (void)setFoodModel:(MTShopFood *)foodModel {

    _foodModel = foodModel;
    
    // MARK: - 1.设置图片
    // 1.先要取出图片的链接字符串!
    // stringByDeletingPathExtension 可以删除字符串中最后一个".xxx!"
    // stringByDeletingLastPathComponent 可以删除字符串最后一个"/xxxx"
    NSString *urlStr = [foodModel.picture stringByDeletingPathExtension];
    // 2. 转为url
    NSURL *url = [NSURL URLWithString:urlStr];
    // 3. 设置图片 -> 负责设置图片的方法
    [_iconView sd_setImageWithURL:url];
    
    // MARK: - 2.设置其他信息
    _nameLbl.text = foodModel.name;
    _monthLbl.text = foodModel.month_saled_content;
    _starLbl.text = foodModel.praise_num.description;
    _priceLbl.text = [@"¥" stringByAppendingFormat:@"%.2f", foodModel.min_price.floatValue];
    _descLbl.text = foodModel.desc;
    
    // MARK: - 2.2 设置数量信息
    _orderControl.count = foodModel.orderCount;
    
//    // MARK: - 3.动态行高需要设置contentView的约束
    // 如果有描述 -> remake 重新设置contentView的约束!
//    if (foodModel.desc.length > 0) {
    
//        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.top.right.bottom.equalTo(self);
//            make.bottom.equalTo(_descLbl.mas_bottom).offset(10);
//            
//        }];
//    } else {
//    
//        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.top.right.bottom.equalTo(self);
//            make.bottom.equalTo(_priceLbl.mas_bottom).offset(10);
//            
//        }];
    
//    }
}

#pragma mark - 搭建界面
- (void)setupUI {
    
    // 间距
    CGFloat margin = 10;
    
    // MARK: - 0.选中cell的时候,没有任何颜色变化!也没有取消选中的动画!
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // MARK: - 1.图片框
    UIImageView *iconV = [[UIImageView alloc] init];
    iconV.backgroundColor = [UIColor redColor];
    
    // 设置圆角
    iconV.layer.cornerRadius = 25;
    iconV.layer.masksToBounds = YES;
    
    // 设置填充模式
    iconV.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.contentView addSubview:iconV];
    
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        // 如果不写参照,就相当于参照父控件!
        make.left.mas_equalTo(9);
        make.top.mas_equalTo(margin);
        
        make.size.mas_equalTo(CGSizeMake(50, 50));
        
    }];
    
    
    // MARK: - 2.名称
    UILabel *nameL = [UILabel cz_labelWithText:@"天堂饭" fontSize:13 color:[UIColor cz_colorWithHex:0x000000]];
    
    [self.contentView addSubview:nameL];
    
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iconV.mas_right).offset(margin);
        make.top.equalTo(iconV);
    }];
    
    // MARK: - 3.月售
    UILabel *monthL = [UILabel cz_labelWithText:@"月售3099" fontSize:11 color:[UIColor cz_colorWithHex:0x7e7e7e]];
    
    [self.contentView addSubview:monthL];
    
    [monthL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(nameL);
        make.top.equalTo(nameL.mas_bottom).offset(margin);
        
    }];
    
    // MARK: - 4.赞的图片
    UIImageView *starV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_food_review_praise"]];
    [self.contentView addSubview:starV];
    
    [starV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(monthL);
        make.left.equalTo(monthL.mas_right).offset(margin);
        
    }];
    
    // MARK: - 5.赞的数量
    UILabel *starL = [UILabel cz_labelWithText:@"109" fontSize:11 color:[UIColor cz_colorWithHex:0x7e7e7e]];
    [self.contentView addSubview:starL];
    
    [starL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(starV);
        make.left.equalTo(starV.mas_right).offset(margin);
    }];
    
    // MARK: - 6.价格
    UILabel *priceL = [UILabel cz_labelWithText:@"¥1.9" fontSize:14 color:[UIColor cz_colorWithHex:0xfa2a09]];
    
    [self.contentView addSubview:priceL];
    
    [priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(monthL);
        make.top.equalTo(monthL.mas_bottom).offset(margin);
    }];
    
    // MARK: - 7.描述
    UILabel *descL = [UILabel cz_labelWithText:@"特级黑芝麻" fontSize:11 color:[UIColor cz_colorWithHex:0x848484]];
    
    [self.contentView addSubview:descL];
    
    [descL mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(iconV.mas_bottom).offset(2 * margin);
        make.left.equalTo(iconV);
        make.right.equalTo(self.contentView).offset(-margin);
        make.bottom.equalTo(self.contentView).offset(-margin);
    }];
    
    
    // MARK: - 8.控制菜品的数量的界面!
    MTFoodOrderControl *orderControl = [MTFoodOrderControl foodOrderControl];
    
    // 监听数量控件的值改变事件
    [orderControl addTarget:self action:@selector(orderControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.contentView addSubview:orderControl];
    
    [orderControl mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(priceL);
        
        // 注意:我们在xib中,可以看见视图的大小!但是在代码中最好还是要控制视图的宽高!
        make.size.mas_equalTo(CGSizeMake(96, 27));
        
    }];
    
    
    // MARK: - 9.记录成员变量
    _iconView = iconV;
    _nameLbl = nameL;
    _monthLbl = monthL;
    _starLbl = starL;
    _priceLbl = priceL;
    _descLbl = descL;
    _orderControl = orderControl;
    
    
}


@end
