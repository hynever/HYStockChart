//
//  HYStockChartSegmentView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/13.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYStockChartSegmentViewDelegate;
@interface HYStockChartSegmentView : UIView

/**
 *  通过items创建SegmentView
 */
-(instancetype)initWithItems:(NSArray *)items;


@property(nonatomic,strong) NSArray *items;


@property(nonatomic,weak) id<HYStockChartSegmentViewDelegate> delegate;

@property(nonatomic,assign) NSUInteger selectedIndex;

@end



@protocol HYStockChartSegmentViewDelegate <NSObject>

@optional
-(void)hyStockChartSegmentView:(HYStockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index;

@end