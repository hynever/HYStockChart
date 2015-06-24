//
//  HYStockChartPriceView.h
//  jimustock
//
//  Created by jimubox on 15/5/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

/************************Y轴的View************************/
@interface HYStockChartYView : UIView

@property(nonatomic,assign) CGFloat maxValue;

@property(nonatomic,assign) CGFloat middleValue;

@property(nonatomic,assign) CGFloat minValue;

@property(nonatomic,copy) NSString *minLabelText;

@end
