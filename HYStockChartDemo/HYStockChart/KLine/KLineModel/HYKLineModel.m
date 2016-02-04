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
             @"volume":@"Volume",
             @"MA10":@"MA10",
             @"MA20":@"MA20",
             @"MA5":@"MA5",
             @"changeFromLastClose":@"ChangeFromLastClose",
             @"changeFromOpen":@"ChangeFromOpen",
             @"percentChangeFromLastClose":@"PercentChangeFromLastClose",
             @"percentChangeFromOpen":@"PercentChangeFromOpen"
    };
}

@end
