//
//  HYStockChartGloablVariable.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/7.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@end
