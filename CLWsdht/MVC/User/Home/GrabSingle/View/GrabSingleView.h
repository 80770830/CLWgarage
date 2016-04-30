//
//  GrabSingleView.h
//  CLWsdht
//
//  Created by yang on 16/4/20.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrabSingleModel.h"

@interface GrabSingleView : UIView

@property (nonatomic, strong) GrabSingleModel *model;

- (instancetype)initWithWidth:(CGFloat)width;

@end
