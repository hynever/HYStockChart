//
//  HYStockChartView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

/************************展示K线、成交量、趋势图、各种数据的最终的View************************/
@interface HYStockChartView : UIView

/**
 *  股票数据
 */
@property(nonatomic,strong) NSArray *stockData;

/**
 *  Y坐标轴上最大的值
 */
@property(nonatomic,assign,readonly) CGFloat maxYValue;

/**
 *  Y坐标轴上最小的值
 */
@property(nonatomic,assign,readonly) CGFloat minYValue;



/**
 *  重新加载数据
 */
-(void)reloadData;

@end
