//
//  HYStockChartGloablVariable.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/7.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HYStockType)
{
    HYStockTypeUSA,   //美股
    HYStockTypeA,     //A股
    HYStockTypeHK,    //港股
};

@interface HYStockChartGloablVariable : NSObject

/**
 *  K线图的宽度，默认20
 */
+(CGFloat)kLineWidth;
+(void)setkLineWith:(CGFloat)kLineWidth;

/**
 *  K线图的间隔，默认1
 */
+(CGFloat)kLineGap;
+(void)setkLineGap:(CGFloat)kLineGap;


/**
 *  股票中文名
 */
+(NSString *)stockChineseName;
+(void)setStockChineseName:(NSString *)chineseName;

/**
 *  股票代号
 */
+(NSString *)stockSymbol;
+(void)setStockSymbol:(NSString *)symbol;

/**
 *  股票类型
 */
+(void)setStockType:(HYStockType)stockType;
+(HYStockType)stockType;


@end
