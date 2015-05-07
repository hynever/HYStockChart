//
//  HYStockChartGloablVariable.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/7.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYStockChartGloablVariable.h"
#import "HYStockChartConstant.h"

/**
 *  K线图的宽度，默认20
 */
static CGFloat HYStockChartKLineWidth = 20;

/**
 *  K线图的间隔，默认1
 */
static CGFloat HYStockChartKLineGap = 1;

@implementation HYStockChartGloablVariable

/**
 *  K线图的宽度，默认20
 */
+(CGFloat)kLineWidth
{
    return HYStockChartKLineWidth;
}
+(void)setkLineWith:(CGFloat)kLineWidth
{
    if (kLineWidth > HYStockChartKLineMaxWidth) {
        kLineWidth = HYStockChartKLineMaxWidth;
    }else if (kLineWidth < HYStockChartKLineMinWidth){
        kLineWidth = HYStockChartKLineMinWidth;
    }
    HYStockChartKLineWidth = kLineWidth;
}


/**
 *  K线图的间隔，默认1
 */
+(CGFloat)kLineGap
{
    return HYStockChartKLineGap;
}

+(void)setkLineGap:(CGFloat)kLineGap
{
    HYStockChartKLineGap = kLineGap;
}

@end
