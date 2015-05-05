//
//  HYKLine.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYKLine.h"

@interface HYKLine()

@property(nonatomic,assign) CGContextRef context;

@end

@implementation HYKLine


#pragma mark 根据context初始化
-(instancetype)initWithContext:(CGContextRef)context
{
    self = [super init];
    if (self) {
        _context = context;
        self.solidLineWidth = 5;
    }
    return self;
}


#pragma mark 绘制K线
-(void)draw
{
    //如果没有数据，直接返回
    if (!self.kLineModel || !self.context) {
        return;
    }
    
    CGContextRef context = self.context;
    
    //设置画笔颜色
    UIColor *strokeColor = nil;
    if (self.kLineModel.openPoint.y < self.kLineModel.closePoint.y) {
        strokeColor = [self increaseColor];
    }else{
        strokeColor = [self decreaseColor];
    }
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    
    //画上影线和下影线
    //设置上影线和下影线的线的宽度
    CGContextSetLineWidth(context, [self shadowLineWidth]);
    //画出上下影线
    const CGPoint shadowPoints[] = {self.kLineModel.highPoint,self.kLineModel.lowPoint};
    CGContextStrokeLineSegments(context, shadowPoints, 2);
    
    //画中间的开收盘线
    //设置开收盘线的宽度
    CGContextSetLineWidth(context, self.solidLineWidth);
    //画实体线
    const CGPoint solidPoints[] = {self.kLineModel.openPoint,self.kLineModel.closePoint};
    CGContextStrokeLineSegments(context, solidPoints, 2);
}

/**
 *  收盘价高于开盘价格的颜色
 */
-(UIColor *)increaseColor
{
    //1.A股是红色
    //2.美股是绿色
    //具体根据需求来确定，以后如果需求更改了，只要更改这两个方法就可以了
    return [UIColor redColor];
}

/**
 *  收盘价低于开盘价格的颜色
 */
-(UIColor *)decreaseColor
{
    return [UIColor greenColor];
}

/**
 *  影线的宽度
 */
-(CGFloat)shadowLineWidth
{
    return 1.0f;
}


@end
