//
//  GrabSingleView.m
//  CLWsdht
//
//  Created by yang on 16/4/20.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "GrabSingleView.h"
#import <Masonry.h>
#import "BaseHeader.h"

@implementation GrabSingleView
{
    UIView *navigationView;
    UIButton *backButton;
    UIView *blackView;
    UILabel *personNameLabel;//发单人
    UILabel *carInforLabel;//车辆信息
    UILabel *partsLabel;//更换配件
    UILabel *partsContent;//更换配件信息
    UIView *whiteView;
    UIButton *button;//抢单按钮
    UILabel *singleTimeLabel;//倒计时
    UILabel *priceLabel;//预计维修费用
    UITextField *priceField;
    CGFloat currWidth;
}

- (instancetype)initWithWidth:(CGFloat)width
{
    self = [super init];
    if (self) {
        currWidth = width;
        [self setSubViews];
        [self regisiteNotification];
    }
    return self;
}

//模型赋值
- (void)setModel:(GrabSingleModel *)model
{
    _model = model;
    personNameLabel.text = [NSString stringWithFormat:@"发单人: %@", model.UsrName];
    carInforLabel.text = [NSString stringWithFormat:@"车辆信息: %@ %@", model.CarBrandName, model.CarModelName];
    partsContent.text = model.CompetitionOrderParts[0][@"PartsName"];
    for (NSInteger i = 1; i < model.CompetitionOrderParts.count; i++) {        [partsContent.text stringByAppendingString:[NSString stringWithFormat:@"、%@", model.CompetitionOrderParts[i][@"PartsName"]]];
    }
    [self setPartsContent:partsContent.text];
}

- (void)setPartsContent:(NSString *)text
{
    CGFloat height = [self textHeight:text andFont:17];
    if (height > 70) {
        height = 70;
    }
    [partsContent mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(partsLabel);
        make.left.equalTo(partsLabel.mas_right).offset(0);
        make.right.equalTo(blackView).offset(-20);
        make.height.mas_equalTo(height);
    }];
}

//计算文本高度
-(CGFloat)textHeight:(NSString *)str andFont:(CGFloat)font{
    CGRect newRect = [str boundingRectWithSize:CGSizeMake(currWidth - 115, 99999999999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return newRect.size.height;
}


//注册通知
- (void)regisiteNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(singleTimeChange:) name:@"singleTime" object:nil];
}

//倒计时通知
- (void)singleTimeChange:(NSNotification *)noti
{
    singleTimeLabel.text = [NSString stringWithFormat:@"您有%@秒抢单时间", [noti.userInfo objectForKey:@"time"]];
}

//抢单按钮
- (void)buttonClick:(UIButton *)sender
{
    [priceField resignFirstResponder];
    if ([priceField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入预计维修费用"];
        return;
    }
    NSDictionary *dic = @{@"price":priceField.text};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GrabSingle" object:nil userInfo:dic];
}

//点击空白处回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [priceField resignFirstResponder];
}

//布局UI
- (void)setSubViews
{
    blackView = [UIView new];
    blackView.backgroundColor = [UIColor blackColor];
    [self addSubview:blackView];
    whiteView = [UIView new];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor colorWithRed:252/255.0 green:68/255.0 blue:31/255.0 alpha:1.0];
    [button setTitle:@"抢单" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    singleTimeLabel = [UILabel new];
    singleTimeLabel.textColor = [UIColor whiteColor];
    singleTimeLabel.textAlignment = 1;
    singleTimeLabel.font = [UIFont systemFontOfSize:20];
    singleTimeLabel.text = @"您有30秒抢单时间";
    [blackView addSubview:singleTimeLabel];
    personNameLabel = [UILabel new];
    personNameLabel.textColor = [UIColor whiteColor];
    [blackView addSubview:personNameLabel];
    carInforLabel = [UILabel new];
    carInforLabel.textColor = [UIColor whiteColor];
    [blackView addSubview:carInforLabel];
    partsLabel = [UILabel new];
    partsLabel.text = @"更换配件:";
    partsLabel.textColor = [UIColor whiteColor];
    [blackView addSubview:partsLabel];
    partsContent = [UILabel new];
    partsContent.textColor = [UIColor whiteColor];
    partsContent.numberOfLines = 0;
    [blackView addSubview:partsContent];
    priceLabel = [UILabel new];
    priceLabel.text = @"预计维修费用:";
    [whiteView addSubview:priceLabel];
    priceField = [UITextField new];
    priceField.textAlignment = 2;
    priceField.placeholder = @"请输入预计维修费用";
    priceField.keyboardType = UIKeyboardTypeNumberPad;
    [whiteView addSubview:priceField];
}

//frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    __weak typeof(self) weakSelf = self;
    [blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(weakSelf).offset(0);
        make.width.equalTo(weakSelf);
        make.height.equalTo(weakSelf).multipliedBy(0.6);
    }];
    [personNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(blackView).offset(20);
        make.height.mas_equalTo(@30);
    }];
    [carInforLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(personNameLabel.mas_bottom).offset(30);
        make.left.height.equalTo(personNameLabel);
    }];
    [partsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(carInforLabel.mas_bottom).offset(30);
        make.left.height.equalTo(personNameLabel);
        make.width.mas_equalTo(@75);
    }];
    [partsContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(partsLabel);
        make.left.equalTo(partsLabel.mas_right).offset(0);
        make.right.equalTo(blackView).offset(-20);
        make.height.mas_equalTo(@0);
    }];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blackView.mas_bottom).offset(0);
        make.left.width.equalTo(blackView);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.width.mas_equalTo(@120);
        make.height.mas_equalTo(@40);
        make.bottom.equalTo(whiteView.mas_top).offset(20);
    }];
    [singleTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(button.mas_top).offset(-10);
        make.left.right.equalTo(blackView);
        make.height.equalTo(button);
    }];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(20);
        make.left.equalTo(whiteView).offset(20);
        make.height.equalTo(personNameLabel);
        make.width.mas_equalTo(@110);
    }];
    [priceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.mas_right).offset(10);
        make.right.equalTo(whiteView).offset(-20);
        make.centerY.equalTo(priceLabel.mas_centerY);
        make.height.mas_equalTo(30);
    }];
}

//移除target和通知
- (void)dealloc
{
    [button removeTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"singleTime" object:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
