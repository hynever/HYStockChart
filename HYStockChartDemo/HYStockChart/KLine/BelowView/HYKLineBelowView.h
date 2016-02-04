//
//  HYKLineVolumeView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/7.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYKLineBelowViewDelegate;

/************************下面的图(成交量/平均线)************************/
@interface HYKLineBelowView : UIView

/**
 *  需要画出来的k线的模型数组
 */
@property(nonatomic,strong) NSArray *needDrawKLineModels;

/**
 *  需要绘制的K线的X位置的数组
 */
@property(nonatomic,strong) NSArray *needDrawKLinePositionModels;

/**
 *  K线的颜色
 */
@property(nonatomic,strong) NSArray *kLineColors;

/**
 *  代理
 */
@property(nonatomic,weak) id<HYKLineBelowViewDelegate> delegate;

/**
 *  根据指定颜色清除背景
 */
-(void)clearRectWithColor:(UIColor *)bgColor NS_DEPRECATED_IOS(2_0,2_0,"这个方法暂时没有实现!");

/**
 *  绘制BelowView
 */
-(void)drawBelowView;

@end


/************************HYKLineBelowView的代理方法************************/
@protocol HYKLineBelowViewDelegate <NSObject>

@optional
/**
 *  绘制的成交量中最大的成交量和最小的成交量
 */
-(void)kLineBelowViewCurrentMaxVolume:(CGFloat)maxVolume minVolume:(CGFloat)minVolume;

@end
