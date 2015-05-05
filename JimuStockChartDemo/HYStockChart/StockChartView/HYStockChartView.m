//
//  HYStockChartView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.

//  Date,Open,High,Low,Close,Volume,Adj Close

#import "HYStockChartView.h"
#import "HYKLine.h"
#import "HYStockModel.h"

@implementation HYStockChartView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    HYKLine *kLine1 = [[HYKLine alloc] initWithContext:context];
    kLine1.kLineModel = [HYKLineModel modelWithOpen:CGPointMake(10, 10) close:CGPointMake(10, 5) high:CGPointMake(10, 2) low:CGPointMake(10, 20)];
    [kLine1 draw];
    
    HYKLine *kLine2 = [[HYKLine alloc] initWithContext:context];
    kLine2.kLineModel = [HYKLineModel modelWithOpen:CGPointMake(20, 10) close:CGPointMake(20, 20) high:CGPointMake(20, 2) low:CGPointMake(20, 20)];
    [kLine2 draw];
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
    for (HYStockModel *stockModel in stockData) {
        
    }
    return nil;
}

@end
