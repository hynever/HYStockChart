//
//  HYKLineModel.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYKLineModel.h"
#import "MJExtension.h"

@implementation HYKLineModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"date":@"Date",
             @"high":@"High",
             @"low":@"Low",
             @"close":@"Last",
             @"open":@"Open",
             @"volume":@"Volume"
    };
}

@end
