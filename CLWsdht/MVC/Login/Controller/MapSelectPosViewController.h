//
//  MapSelectPosViewController.h
//  CLWsdht
//
//  Created by tom on 16/4/22.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapSelectPosDelegate;


@interface MapSelectPosViewController : UIViewController

@property (nonatomic, weak) id<MapSelectPosDelegate> delegate;

@end


@protocol MapSelectPosDelegate <NSObject>

- (void)mapSelectPos:(MapSelectPosViewController *)viewController latitude:(double)latitude longitude:(double)longitude;

@end