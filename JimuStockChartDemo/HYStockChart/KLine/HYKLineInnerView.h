//
//  HYKLineView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

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
 *  画InnerView上的所有图
 */
-(void)drawInnerView;


@end
