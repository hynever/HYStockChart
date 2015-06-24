//
//  HYTimeLine.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYTimeLine.h"
#import "HYStockChartConstant.h"
#import "UIColor+HYStockChart.h"

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
    CGContextSetStrokeColorWithColor(self.context, [UIColor timeLineLineColor].CGColor);
    for (NSInteger index = 0; index < count; index++) {
        HYTimeLineAbovePositionModel *positionModel = (HYTimeLineAbovePositionModel *)positionModels[index];
        if (isnan(positionModel.currentPoint.x) || isnan(positionModel.currentPoint.y)) {
            continue;
        }
        NSAssert(!isnan(positionModel.currentPoint.x) && !isnan(positionModel.currentPoint.y) && !isinf(positionModel.currentPoint.x) && !isinf(positionModel.currentPoint.y), @"不符合要求的点！");
        CGContextMoveToPoint(self.context, positionModel.currentPoint.x, positionModel.currentPoint.y);
        if (index+1 < count) {
            HYTimeLineAbovePositionModel *nextPositionModel = (HYTimeLineAbovePositionModel *)positionModels[index+1];
            CGContextAddLineToPoint(self.context, nextPositionModel.currentPoint.x, nextPositionModel.currentPoint.y);
        }
        CGContextStrokePath(self.context);
    }
    //画中间那根横线
    CGContextSetStrokeColorWithColor(self.context, [UIColor timeLineLineColor].CGColor);
    const CGFloat lengths[] = {1,3};
    CGContextSetLineDash(self.context, 0, lengths, 2);
    if (isnumber(self.horizontalYPosition)) {
        CGContextMoveToPoint(self.context, 0, self.horizontalYPosition);
        CGContextAddLineToPoint(self.context, self.timeLineViewWidth, self.horizontalYPosition);
        CGContextStrokePath(self.context);
    }
    
}

@end
