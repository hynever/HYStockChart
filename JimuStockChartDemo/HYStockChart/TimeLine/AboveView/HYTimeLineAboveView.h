//
//  HYTimeLineAboveView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYTimeLineGroupModel;
@protocol HYTimeLineAboveViewDelegate;
@class HYTimeLineModel;
/************************分时线上面的view************************/
@interface HYTimeLineAboveView : UIView

/**
 *  分时线的模型
 */
@property(nonatomic,strong) HYTimeLineGroupModel *groupModel;

@property(nonatomic,weak) id<HYTimeLineAboveViewDelegate> delegate;

/**
 *  画AboveView
 */
-(void)drawAboveView;

/**
 *  长按的时候根据原始的x的位置获得精确的X的位置
 */
-(CGFloat)getRightXPositionWithOriginXPosition:(CGFloat)originXPosition;


@end


@protocol HYTimeLineAboveViewDelegate <NSObject>

@optional
-(void)timeLineAboveView:(UIView *)timeLineAboveView positionModels:(NSArray *)positionModels;

@end