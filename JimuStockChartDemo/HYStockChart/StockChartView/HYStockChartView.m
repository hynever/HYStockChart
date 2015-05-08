//
//  HYStockChartView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.

//  Date,Open,High,Low,Close,Volume,Adj Close

#import "HYStockChartView.h"
#import "HYKLine.h"
#import "HYKLineModel.h"

@implementation HYStockChartView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [super drawRect:rect];
}

/**
 *  重新加载数据
 */
-(void)reloadData
{
    [self setNeedsDisplay];
}

-(void)setStockData:(NSArray *)stockData
{
    _stockData = stockData;
    //通过解析器将数据解析成坐标数据
}


#pragma mark - 私有方法
-(NSArray *)private_parseToCoordinateWithStockData:(NSArray *)stockData
{
    for (HYKLineModel *stockModel in stockData) {
        
    }
    return nil;
}

@end
