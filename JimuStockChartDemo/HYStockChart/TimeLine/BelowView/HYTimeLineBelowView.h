//
//  HYTimeLineBelowView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYTimeLineModel;
/************************分时线下面的view************************/
@interface HYTimeLineBelowView : UIView

@property(nonatomic,strong) NSArray *timeLineModels;

@property(nonatomic,strong) NSArray *xPositionArray;

/**
 *  画下面的view
 */
-(void)drawBelowView;

@end
