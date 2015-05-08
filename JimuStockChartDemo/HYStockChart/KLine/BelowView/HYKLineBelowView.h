//
//  HYKLineVolumeView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/7.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

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
 *  绘制BelowView
 */
-(void)drawBelowView;

@end
