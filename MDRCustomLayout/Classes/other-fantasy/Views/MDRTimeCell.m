//
//  MDRTimeCell.m
//  timeLine
//
//  Created by 刘春牢 on 16/6/9.
//  Copyright © 2016年 刘春牢. All rights reserved.
//

#import "MDRTimeCell.h"
#import "Masonry.h"

@implementation MDRTimeCell {

    UIImageView *_roundImgView;
    
    UILabel *_titleLbl;
    UILabel *_subtitleLbl;
    UILabel *_timeLbl;
    
    UIView *_divideLine;
    
}

#pragma mark - 添加子控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // MARK: - 1.添加子控件
        [self setupUI];
        
        self.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)setupUI {

    // 1.上线
    UIView *upLine = [[UIView alloc] init];
    
    upLine.backgroundColor = [UIColor yellowColor];
    
    [self.contentView addSubview:upLine];
    _upLine = upLine;
    _upLine = upLine;
    
    // 2.下线
    UIView *bottomLine = [[UIView alloc] init];
    
    bottomLine.backgroundColor = [UIColor yellowColor];
    
    [self.contentView addSubview:bottomLine];
    _bottomLine = bottomLine;
    
    // 3.中间的图片框
    UIImageView *roundImgView = [[UIImageView alloc] init];
    
    roundImgView.backgroundColor = [UIColor orangeColor];
    
    [self.contentView addSubview:roundImgView];
    _roundImgView = roundImgView;
    
    // 4.标题
    UILabel *titleLbl = [[UILabel alloc] init];
    
    //    titleLbl.backgroundColor = [UIColor redColor];
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.font = [UIFont systemFontOfSize:15];
    
    [self.contentView  addSubview:titleLbl];
    _titleLbl = titleLbl;
    
    
    UIFont *font = [UIFont systemFontOfSize:10];
    
    // 5.子标题
    UILabel *subtitleLbl = [[UILabel alloc] init];
//    subtitleLbl.backgroundColor = [UIColor orangeColor];
    subtitleLbl.font = font;
    
    [self.contentView addSubview:subtitleLbl];
    
    _subtitleLbl = subtitleLbl;
    
    
    // 6.时间
    UILabel *timeLbl = [[UILabel alloc] init];
//    timeLbl.backgroundColor = [UIColor grayColor];
    
    timeLbl.textAlignment = NSTextAlignmentRight;
    timeLbl.font = font;
    
    [self.contentView addSubview:timeLbl];
    _timeLbl = timeLbl;
    
    // 7.分割线
    UIView *divideLine = [[UIView alloc] init];
    divideLine.backgroundColor = [UIColor lightGrayColor];
    divideLine.alpha = 0.3;
    [self.contentView addSubview:divideLine];
    _divideLine = divideLine;
    
}

#pragma mark - 设置数据
- (void)setItem:(NSDictionary *)item {

    _item = item;
    
    NSLog(@"xxxx");
    
    _titleLbl.text = item[@"title"];
    _subtitleLbl.text = item[@"subTitle"];
    
    _timeLbl.text = item[@"time"];
    
        
    // 需要更新约束
    [self setNeedsUpdateConstraints];
    
    [self updateConstraintsIfNeeded];

    
}

- (void)updateConstraints {

    [_titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.mas_equalTo(_divideLine);
        make.height.mas_equalTo(25);
        
        if (_subtitleLbl.text.length > 0) {
            
            make.top.mas_equalTo(self.contentView).with.offset(10);

            make.trailing.mas_equalTo(self.contentView.mas_centerX).with.offset(50);
            
        } else {
        
            make.centerY.mas_equalTo(self.contentView);
        }
        
        
        
    }];
    
    
    [super updateConstraints];
}

#pragma mark - 设置约束
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 25, 0, 20);
    
    [_upLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.contentView);
        
        make.left.mas_equalTo(self.contentView).with.offset(insets.left);
        
        make.height.mas_equalTo(20);
        
        make.width.mas_equalTo(1);
        
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.height.width.mas_equalTo(_upLine);
        
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    
    [_roundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_upLine.mas_bottom);
        
        make.bottom.mas_equalTo(_bottomLine.mas_top);
        
        make.centerX.mas_equalTo(_upLine.mas_centerX);
        
        make.width.mas_equalTo(_roundImgView.mas_height);
    }];
    
    _roundImgView.layer.cornerRadius = 15;
    _roundImgView.layer.masksToBounds = YES;
    
    [_divideLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(_bottomLine.mas_trailing).with.offset(insets.left);
        
        make.bottom.right.mas_equalTo(self.contentView);
        
        make.height.mas_equalTo(1);
    }];
    
//    if (subtitle.length > 0) {
    
    
//        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.mas_equalTo(_divideLine);
//            
//            make.top.mas_equalTo(self.contentView).with.offset(10);
//            
//            make.trailing.mas_equalTo(self.contentView.mas_centerX).with.offset(50);
//            
//            make.height.mas_equalTo(25);
//            
//        }];
    
//    } else {
//    
//        [_titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.mas_equalTo(_divideLine);
//            
//            make.trailing.mas_equalTo(self.contentView.mas_centerX).with.offset(50);
//            
//            make.centerY.mas_equalTo(self.contentView);
//            
//            make.height.mas_equalTo(25);
//            
//        }];
//        
//    }
    
    [_subtitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(_divideLine);
        
        make.bottom.mas_equalTo(_divideLine.mas_top).with.offset(-10);
        
        make.height.mas_equalTo(15);
        
        make.width.mas_equalTo(self.contentView);
        
    }];
    
    
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.mas_equalTo(self.contentView).with.offset(-20);
        
        make.bottom.mas_equalTo(_titleLbl);
        
        make.height.mas_equalTo(15);
        
        make.leading.mas_equalTo(self.contentView.mas_centerX).with.offset(50);
    }];

}


@end
