//
//  HYKLineModel.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface HYKLineModel : NSObject

/**
 *  这个日期的格式必须为MM/dd/yyyy
 */
@property(nonatomic,copy) NSString *date;

@property(nonatomic,assign) CGFloat high;

@property(nonatomic,assign) CGFloat low;

@property(nonatomic,assign) CGFloat open;

@property(nonatomic,assign) CGFloat close;

@property(nonatomic,assign) CGFloat volume;
//10日平均线
@property(nonatomic,assign) CGFloat MA10;
//20日平均线
@property(nonatomic,assign) CGFloat MA20;
//5日平均线
@property(nonatomic,assign) CGFloat MA5;

@property(nonatomic,assign)  CGFloat MA30;

@property(nonatomic,assign) CGFloat changeFromLastClose;

@property(nonatomic,assign) CGFloat changeFromOpen;

@property(nonatomic,assign) CGFloat percentChangeFromLastClose;

@property(nonatomic,assign) CGFloat percentChangeFromOpen;

/**
 *  是否是某个月的第一个交易日
 */
@property(nonatomic,assign) BOOL isFirstTradeDate;

@end
