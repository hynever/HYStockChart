//
//  HYKLineView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYKLineModel.h"

@protocol HYKLineInnerViewDelegate;

/************************展示所有K线的View************************/
@interface HYKLineInnerView : UIView

/**
 *  股票模型数组
 */
@property(nonatomic,strong) NSArray *stockModels;

/**
 *  K线的宽度
 */
@property(nonatomic,assign) CGFloat kLineWidth;

/**
 *  K线之间的间隙
 */
@property(nonatomic,assign) CGFloat kLineGap;

/**
 *  父view，该父view为UIScrollView
 */
@property(nonatomic,weak,readonly) UIScrollView *scrollView;

/**
 *  代理
 */
@property(nonatomic,weak) id<HYKLineInnerViewDelegate> delegate;


/**
 *  画InnerView上的所有图
 */
-(void)drawInnerView;


@end



/************************HYKLineInnerView的代理方法************************/
@protocol HYKLineInnerViewDelegate <NSObject>

@optional
/**
 *  长按后展示手指按着的HYKLineModel
 */
-(void)kLineInnerViewLongPressKLineModel:(HYKLineModel *)kLineModel;

/**
 *  当前InnerView中的最大股价和最小股价
 */
-(void)kLineInnerViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice;

/**
 *  当前InnerView的时间区间
 */
-(void)kLineInnerViewCurrentTimeZone:(NSArray *)timeZone;

@end
