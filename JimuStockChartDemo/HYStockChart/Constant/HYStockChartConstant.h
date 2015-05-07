//
//  HYConstant.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#ifndef __HYStockChartConstant__H__
#define __HYStockChartConstant__H__
#import <UIKit/UIKit.h>

/**
 *  K线图Price的View的宽度
 */
extern CGFloat const HYStockChartKLinePriceViewWidth;

/**
 *  K线图的Time的View的高度
 */
extern CGFloat const HYStockChartKLineTimeViewHeight;

/**
 *  K线最大的宽度
 */
extern CGFloat const HYStockChartKLineMaxWidth;

/**
 *  K线图最小的宽度
 */
extern CGFloat const HYStockChartKLineMinWidth;

/**
 *  UIScrollView的contentOffset属性
 */
extern NSString * const HYStockChartContentOffsetKey;

/**
 *  K线图缩放界限
 */
extern CGFloat const HYStockChartScaleBound;

/**
 *  K线的缩放因子
 */
extern CGFloat const HYStockChartScaleFactor;

/**
 *  K线图上可画区域最小的Y
 */
#define HYStockChartAboveViewMinY 0

/**
 *  K线图上可画区域最大的Y
 */
#define HYStockChartAboveViewMaxY (self.frame.size.height-10)


#endif
