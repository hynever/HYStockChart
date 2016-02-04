//
//  HYKLine.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYKLine.h"
#import "HYStockChartConstant.h"
#import "HYStockChartGloablVariable.h"
#import "UIColor+HYStockChart.h"
#import "UIFont+HYStockChart.h"

@interface HYKLine()

@property(nonatomic,assign) CGContextRef context;

@property(nonatomic,assign) CGPoint lastDrawDatePoint;

@end

@implementation HYKLine


#pragma mark 根据context初始化
-(instancetype)initWithContext:(CGContextRef)context
{
    self = [super init];
    if (self) {
        _context = context;
        _lastDrawDatePoint = CGPointZero;
    }
    return self;
}


#pragma mark 绘制K线
-(UIColor *)draw
{
    //如果没有数据，直接返回
    if (!self.kLineModel || !self.context || !self.kLineModel) {
        return nil;
    }
    
    CGContextRef context = self.context;
    
    //设置画笔颜色
    UIColor *strokeColor = nil;
    //减少的
    if (self.kLinePositionModel.openPoint.y < self.kLinePositionModel.closePoint.y) {
        strokeColor = [UIColor decreaseColor];
    }
    //增长的
    else{
        strokeColor = [UIColor increaseColor];
    }
    CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    
    //画中间的开收盘线
    //设置开收盘线的宽度
    CGContextSetLineWidth(context, [HYStockChartGloablVariable kLineWidth]);
    //画实体线
    const CGPoint solidPoints[] = {self.kLinePositionModel.openPoint,self.kLinePositionModel.closePoint};
    CGContextStrokeLineSegments(context, solidPoints, 2);
    
    //画上影线和下影线
    //设置上影线和下影线的线的宽度
    CGContextSetLineWidth(context, [self shadowLineWidth]);
    //画出上下影线
    const CGPoint shadowPoints[] = {self.kLinePositionModel.highPoint,self.kLinePositionModel.lowPoint};
    CGContextStrokeLineSegments(context, shadowPoints, 2);
    
    if (self.kLineModel.isFirstTradeDate) {
        
        NSString *dateStr = self.kLineModel.date;
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"MM/dd/yyyy";
        NSDate *date = [formatter dateFromString:dateStr];
        formatter.dateFormat = @"yyyy-MM-dd";
        dateStr = [formatter stringFromDate:date];
        CGSize dateSize = [dateStr sizeWithAttributes:@{NSFontAttributeName:[UIFont f39Font]}];
        CGPoint drawDatePoint = CGPointMake(self.kLinePositionModel.highPoint.x-dateSize.width/2, self.maxY+2);
        
        if (CGPointEqualToPoint(self.lastDrawDatePoint, CGPointZero) || drawDatePoint.x - self.lastDrawDatePoint.x > 100) {
            [dateStr drawAtPoint:drawDatePoint withAttributes:@{NSFontAttributeName:[UIFont f39Font],NSForegroundColorAttributeName:[UIColor assistTextColor]}];
            self.lastDrawDatePoint = drawDatePoint;
        }
    }
    
    return strokeColor;
}

/**
 *  影线的宽度
 */
-(CGFloat)shadowLineWidth
{
    return 1.0f;
}


@end
