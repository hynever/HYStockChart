//
//  HYKLineVolume.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYKLineVolume.h"
#import "HYStockChartGloablVariable.h"

@interface HYKLineVolume()

@property(nonatomic,assign) CGContextRef context;

@end

@implementation HYKLineVolume

#pragma mark 根据context初始化模型
-(instancetype)initWithContext:(CGContextRef)context
{
    self = [super init];
    if (self) {
        _context = context;
    }
    return self;
}

#pragma mark 绘图方法
-(void)draw
{
    if (!self.kLineModel || !self.positionModel || !self.context || !self.lineColor) {
        return;
    }
    CGContextRef context = self.context;
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    //设置线的宽度
    CGContextSetLineWidth(context, [HYStockChartGloablVariable kLineWidth]);
    //画实体线
    const CGPoint solidPoints[] = {self.positionModel.startPoint,self.positionModel.endPoint};
    CGContextStrokeLineSegments(context, solidPoints, 2);
}

@end
