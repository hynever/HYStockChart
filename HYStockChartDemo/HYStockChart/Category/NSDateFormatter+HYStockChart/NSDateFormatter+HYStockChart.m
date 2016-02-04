//
//  NSDateFormatter+HYStockChart.m
//  jimustock
//
//  Created by jimubox on 15/6/14.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "NSDateFormatter+HYStockChart.h"

@implementation NSDateFormatter (HYStockChart)

+(NSDateFormatter *)shareDateFormatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSDateFormatter new];
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    });
    return formatter;
}

@end
