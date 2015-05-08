//
//  HYTimeLineAboveView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYTimeLineAboveViewDelegate;
/************************分时线上面的view************************/
@interface HYTimeLineAboveView : UIView

@property(nonatomic,weak) id<HYTimeLineAboveViewDelegate> delegate;

@end


@protocol HYTimeLineAboveViewDelegate <NSObject>

@optional


@end