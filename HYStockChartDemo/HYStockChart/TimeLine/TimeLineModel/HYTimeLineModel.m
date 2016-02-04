//
//  HYTimeLineModel.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYTimeLineModel.h"
#import "MJExtension.h"

@implementation HYTimeLineModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"currentPrice":@"Close",
             @"currentTime":@"EndTime",
             @"currentDate":@"EndDate",
             @"volume":@"Volume"
    };
}

-(NSString *)currentTime
{
    NSString *fullTime = [NSString stringWithFormat:@"%@ %@",_currentDate,_currentTime];
    return fullTime;
}

@end
