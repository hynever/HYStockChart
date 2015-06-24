//
//  HYTimeLineView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTimeLineGroupModel.h"
#import "HYStockChartConstant.h"

@interface HYTimeLineView : UIView

@property(nonatomic,strong) HYTimeLineGroupModel *timeLineGroupModel;

@property(nonatomic,assign) CGFloat aboveViewRatio;

@property(nonatomic,assign) BOOL isNeedDrawTime;

@property(nonatomic,assign) HYStockChartCenterViewType centerViewType;

/**
 *  重绘
 */
-(void)reDraw;

/**
 *  根据指定颜色清除背景
 */
-(void)clearRectWithColor:(UIColor *)bgColor NS_DEPRECATED_IOS(2_0,2_0,"这个方法暂时没有实现!");

@end
