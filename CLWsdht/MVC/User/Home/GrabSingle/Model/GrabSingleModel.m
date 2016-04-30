//
//  GrabSingleModel.m
//  CLWsdht
//
//  Created by yang on 16/4/21.
//  Copyright © 2016年 时代宏图. All rights reserved.
//

#import "GrabSingleModel.h"

@implementation GrabSingleModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
