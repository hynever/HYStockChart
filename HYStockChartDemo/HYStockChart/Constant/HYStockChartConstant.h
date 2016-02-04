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
 *  K线图需要加载更多数据的通知
 */
extern NSString * const HYStockChartKLineNeedLoadMoreDataNotification;

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
#define HYStockChartKLineAboveViewMinY 20

/**
 *  K线图上可画区域最大的Y
 */
#define HYStockChartKLineAboveViewMaxY (self.frame.size.height-20)

/**
 *  K线图的成交量上最小的Y
 */
#define HYStockChartKLineBelowViewMinY 0

/**
 *  K线图的成交量最大的Y
 */
#define HYStockChartKLineBelowViewMaxY (self.frame.size.height)


/**
 *  时分线图的Above上最小的Y
 */
#define HYStockChartTimeLineAboveViewMinY 0

/**
 *  时分线图的Above上最大的Y
 */
#define HYStockChartTimeLineAboveViewMaxY (self.frame.size.height-HYStockChartTimeLineTimeLabelViewHeight)

/**
 *  时分线图的Above上最小的X
 */
extern CGFloat const HYStockChartTimeLineAboveViewMinX;

/**
 *  时分线的宽度
 */
extern CGFloat const HYStockChartTimeLineLineWidth;

/**
 *  时分线图的Above上最大的Y
 */
#define HYStockChartTimeLineAboveViewMaxX (self.frame.size.width)

/**
 *  时分线图的Below上最小的Y
 */
#define HYStockChartTimeLineBelowViewMinY 0

/**
 *  时分线图的Below上最大的Y
 */
#define HYStockChartTimeLineBelowViewMaxY (self.frame.size.height)

/**
 *  时分线图的Below最大的X
 */
#define HYStockChartTimeLineBelowViewMaxX (self.frame.size.width)

/**
 * 时分线图的Below最小的X
 */
#define HYStockChartTimeLineBelowViewMinX 0

/**
 *  时分线的成交量的线宽
 */
extern CGFloat const HYStockChartTimeLineVolumeLineWidth;

/**
 *  分时线的timeLabelView的高度
 */
extern CGFloat const HYStockChartTimeLineTimeLabelViewHeight;

/**
 *  长按时的线的宽度
 */
extern CGFloat const HYStockChartLongPressVerticalViewWidth;


/**
 *  MA线的宽度
 */
extern CGFloat const HYStockChartMALineWidth;

/**
 *  所有profileView的高度
 */
extern CGFloat const HYStockChartProfileViewHeight;

//枚举
typedef NS_ENUM(NSUInteger, HYStockChartCenterViewType){
    HYStockChartCenterViewTypeKLine = 1,    //K线
    HYStockChartCenterViewTypeTimeLine,     //分时线
    HYStockChartCenterViewTypeBrokenLine    //折线（用的是分时线的图）
};

#endif
