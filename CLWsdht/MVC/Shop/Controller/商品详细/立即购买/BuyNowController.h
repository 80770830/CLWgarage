//
//  BuyNowController.h
//  CLWsdht
//
//  Created by OYJ on 16/4/21.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodInfoData.h"

@interface BuyNowController : BaseViewController
//选择“我的”地址
@property(strong,nonatomic)GoodInfoData *goodInfo;
@property(strong,nonatomic)NSDictionary *selectAddressDic;
//选择用户列表中地址1还是用户登陆时地址0
@property(assign,nonatomic)BOOL newUsrAdsressState;
@end
