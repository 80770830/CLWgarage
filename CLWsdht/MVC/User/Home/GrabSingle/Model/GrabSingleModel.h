//
//  GrabSingleModel.h
//  CLWsdht
//
//  Created by yang on 16/4/21.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrabSingleModel : NSObject

@property (nonatomic, strong) NSString *CarBrandName;//车辆信息

@property (nonatomic, strong) NSString *CarModelName;//车辆信息

@property (nonatomic, strong) NSString *UsrId;

@property (nonatomic, strong) NSArray *CompetitionOrderParts;//更换配件

@property (nonatomic, strong) NSString *UsrName;//发单人

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
