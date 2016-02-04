//
//  HYTimeLineModel.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYTimeLineModel : NSObject

@property(nonatomic,assign) CGFloat currentPrice;

@property(nonatomic,copy) NSString *currentTime;

@property(nonatomic,copy) NSString *currentDate;

@property(nonatomic,assign) NSInteger volume;

@property(nonatomic,assign) CGFloat ChangeFromPreClose;

@property(nonatomic,assign) CGFloat PercentChangeFromPreClose;

@end
