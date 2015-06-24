//
//  HYMALine.m
//  jimustock
//
//  Created by jimubox on 15/5/28.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYMALine.h"
#import "HYKLineModel.h"
#import "UIColor+HYStockChart.h"
#import "HYStockChartConstant.h"

@interface HYMALine ()

@property(nonatomic,assign) CGContextRef context;

@end

@implementation HYMALine

/**
 *  根据context初始化均线画笔
 */
-(instancetype)initWitContext:(CGContextRef)context
{
    self = [super init];
    if (self) {
        self.context = context;
    }
    return self;
}

-(void)draw
{
    if (!self.context || !self.MAPositions) {
        return;
    }
    
    UIColor *lineColor = nil;
    switch (self.MAType) {
        case HYMA5Type:
            lineColor = [UIColor ma5Color];
            break;
        case HYMA10Type:
            lineColor = [UIColor ma10Color];
            break;
        case HYMA20Type:
            lineColor = [UIColor ma20Color];
            break;
        case HYMA30Type:
            lineColor = [UIColor ma30Color];
            break;
        default:
            break;
    }

    CGContextSetStrokeColorWithColor(self.context,lineColor.CGColor);
    CGContextSetLineWidth(self.context, HYStockChartMALineWidth);
    
    NSInteger count = self.MAPositions.count;
    CGPoint point = [self.MAPositions[0] CGPointValue];
    NSAssert(!isnan(point.x) && !isnan(point.y), @"画MA线的时候出现NAN");
    CGContextMoveToPoint(self.context, point.x, point.y);
    for (NSInteger idx = 1; idx < count; idx++) {
        CGPoint point = [self.MAPositions[idx] CGPointValue];
        CGContextAddLineToPoint(self.context, point.x, point.y);
    }
    CGContextStrokePath(self.context);
}

@end
