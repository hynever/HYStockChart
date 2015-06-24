//
//  HYConstant.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#ifndef __HYStockChartConstant__M__
#define __HYStockChartConstant__M__
#import <UIKit/UIKit.h>

/**
 *  K线图需要加载更多数据的通知
 */
NSString * const HYStockChartKLineNeedLoadMoreDataNotification = @"HYStockChartKLineNeedLoadMoreDataNotification";

/**
 *  K线图Y的View的宽度
 */
CGFloat const HYStockChartKLinePriceViewWidth = 50;

/**
 *  K线图的X的View的高度
 */
CGFloat const HYStockChartKLineTimeViewHeight = 20;

/**
 *  K线最大的宽度
 */
CGFloat const HYStockChartKLineMaxWidth = 27;

/**
 *  K线图最小的宽度
 */
CGFloat const HYStockChartKLineMinWidth = 2;

/**
 *  K线图缩放界限
 */
CGFloat const HYStockChartScaleBound = 0.03;

/**
 *  K线的缩放因子
 */
CGFloat const HYStockChartScaleFactor = 0.03;

/**
 *  UIScrollView的contentOffset属性
 */
NSString * const HYStockChartContentOffsetKey = @"contentOffset";

/**
 *  时分线的宽度
 */
CGFloat const HYStockChartTimeLineLineWidth = 0.5;

/**
 *  时分线图的Above上最小的X
 */
CGFloat const HYStockChartTimeLineAboveViewMinX = 0.0;

/**
 *  分时线的timeLabelView的高度
 */
CGFloat const HYStockChartTimeLineTimeLabelViewHeight = 19;

/**
 *  时分线的成交量的线宽
 */
CGFloat const HYStockChartTimeLineVolumeLineWidth = 0.5;

/**
 *  长按时的线的宽度
 */
CGFloat const HYStockChartLongPressVerticalViewWidth = 0.5;

/**
 *  MA线的宽度
 */
CGFloat const HYStockChartMALineWidth = 1;


/**
 *  所有profileView的高度
 */
CGFloat const HYStockChartProfileViewHeight = 50;


#endif
