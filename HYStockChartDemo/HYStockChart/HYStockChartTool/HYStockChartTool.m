//
//  HYStockChartTool.m
//  jimustock
//
//  Created by jimubox on 15/6/14.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYStockChartTool.h"
#import "HYStockChartGloablVariable.h"

@implementation HYStockChartTool

+(NSString *)currencySymbol
{
    HYStockType stockType = [HYStockChartGloablVariable stockType];
    switch (stockType) {
        case HYStockTypeUSA:
            return @"$";
            break;
        case HYStockTypeHK:
            return @"HKD";
            break;
        default:
            return @"￥";
            break;
    }
}

@end
