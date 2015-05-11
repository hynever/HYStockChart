//
//  HYTimeLine.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYTimeLine.h"
#import "HYStockChartConstant.h"

@interface HYTimeLine ()

@property(nonatomic,assign) CGContextRef context;

@end

@implementation HYTimeLine

-(instancetype)initWithContext:(CGContextRef)context
{
    self = [super init];
    if (self) {
        self.context = context;
        _horizontalYPosition = -1;
    }
    return self;
}

-(void)draw
{
    NSAssert(self.context && self.positionModels, @"context或者positionModel不能为空!");
    NSInteger count = self.positionModels.count;
    NSArray *positionModels = self.positionModels;
    CGContextSetLineWidth(self.context, HYStockChartTimeLineLineWidth);
    CGContextSetStrokeColorWithColor(self.context, [self private_timeLineColor].CGColor);
    for (NSInteger index = 0; index < count; index++) {
        HYTimeLineAbovePositionModel *positionModel = (HYTimeLineAbovePositionModel *)positionModels[index];
        CGContextMoveToPoint(self.context, positionModel.currentPoint.x, positionModel.currentPoint.y);
        if (index+1 < count) {
            HYTimeLineAbovePositionModel *nextPositionModel = (HYTimeLineAbovePositionModel *)positionModels[index+1];
            CGContextAddLineToPoint(self.context, nextPositionModel.currentPoint.x, nextPositionModel.currentPoint.y);
        }
        CGContextStrokePath(self.context);
    }
    //画中间那根横线
    HYTimeLineAbovePositionModel *lastModel = [self.positionModels lastObject];
    CGContextSetStrokeColorWithColor(self.context, [UIColor redColor].CGColor);
    const CGFloat lengths[] = {10,5};
    CGContextSetLineDash(self.context, 0, lengths, 2);
    CGContextMoveToPoint(self.context, 0, self.horizontalYPosition);
    CGContextAddLineToPoint(self.context, lastModel.currentPoint.x, self.horizontalYPosition);
    CGContextStrokePath(self.context);
    //画分时线下面的颜色
    
}

-(UIColor *)private_timeLineColor
{
    return [UIColor blueColor];
}

@end
