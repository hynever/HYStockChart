//
//  HYKLineView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>


/************************展示K线图和数据更新的View************************/
@interface HYKLineView : UIView

@property(nonatomic,strong) NSArray *kLineModels;

/**
 *  上面那个view所占的比例
 */
@property(nonatomic,assign) CGFloat aboveViewRatio;

/**
 *  重绘
 */
-(void)reDraw;

/**
 *  根据指定颜色清除背景
 */
-(void)clearRectWithColor:(UIColor *)bgColor NS_DEPRECATED_IOS(2_0,2_0,"这个方法暂时没有实现!");

@end
