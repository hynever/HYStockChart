//
//  HYKLineVolumeView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/7.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYKLineBelowView.h"
#import "HYStockChartConstant.h"
#import "HYKLineModel.h"
#import "HYKLineVolumePositionModel.h"
#import "HYKLinePositionModel.h"
#import "HYKLineVolume.h"
#import "UIColor+HYStockChart.h"

@interface HYKLineBelowView()

/**
 *  需要绘制的成交量的位置模型数组
 */
@property(nonatomic,strong) NSArray *needDrawKLineVolumePositionModels;



@end

@implementation HYKLineBelowView

#pragma mark - 初始化方法
#pragma mark initWithFrame方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor backgroundColor];
    }
    return self;
}

#pragma mark drawRect方法
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (!self.needDrawKLineVolumePositionModels) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    HYKLineVolume *kLineVolume = [[HYKLineVolume alloc] initWithContext:context];
    [self.needDrawKLineVolumePositionModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HYKLineVolumePositionModel *volumePositionModel = (HYKLineVolumePositionModel *)obj;
        kLineVolume.positionModel = volumePositionModel;
        kLineVolume.kLineModel = self.needDrawKLineModels[idx];
        kLineVolume.lineColor = self.kLineColors[idx];
        [kLineVolume draw];
    }];
}

#pragma mark - 公有方法
#pragma mark 绘制BelowView方法
-(void)drawBelowView
{
    NSInteger kLineModelCount = self.needDrawKLineModels.count;
    NSInteger kLinePositionModelCount = self.needDrawKLinePositionModels.count;
    NSInteger kLineColorCount = self.kLineColors.count;
    NSAssert(self.needDrawKLineModels && self.needDrawKLinePositionModels && self.kLineColors && kLineColorCount == kLineModelCount && kLinePositionModelCount == kLineModelCount, @"条件不符合，不能绘制BelowView!");
    self.needDrawKLineVolumePositionModels = [self private_convertToKLinePositionModelWithKLineModels:self.needDrawKLineModels];
    [self setNeedsDisplay];
}

#pragma mark - 私有方法
#pragma mark 根据KLineMoel转换成Position数组
-(NSArray *)private_convertToKLinePositionModelWithKLineModels:(NSArray *)kLineModels
{
    CGFloat minY = HYStockChartKLineBelowViewMinY;
    CGFloat maxY = HYStockChartKLineBelowViewMaxY;
    HYKLineModel *firstModel = [kLineModels firstObject];
    __block CGFloat minVolume = [firstModel volume];
    __block CGFloat maxVolume = [firstModel volume];
    [kLineModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HYKLineModel *kLineModel = (HYKLineModel *)obj;
        if (kLineModel.volume < minVolume) {
            minVolume = kLineModel.volume;
        }
        if (kLineModel.volume > maxVolume) {
            maxVolume = kLineModel.volume;
        }
    }];
    CGFloat unitValue = (maxVolume - minVolume)/(maxY - minY);
    NSMutableArray *volumePositionModels = [NSMutableArray array];
    [kLineModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HYKLineModel *kLineModel = (HYKLineModel *)obj;
        HYKLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
        CGFloat xPosition = kLinePositionModel.highPoint.x;
        CGFloat yPosition = ABS(maxY - ((kLineModel.volume - minVolume)/unitValue));
        if (ABS(yPosition - HYStockChartKLineBelowViewMaxY) < 0.5) {
            //这里写错了容易导致成交量很少的时候画图不准确，不应该是1，而应该是HYStockChartKLineBelowViewMaxY-1
            yPosition = HYStockChartKLineBelowViewMaxY-1;
        }
        CGPoint startPoint = CGPointMake(xPosition, yPosition);
        CGPoint endPoint = CGPointMake(xPosition, HYStockChartKLineBelowViewMaxY);
        HYKLineVolumePositionModel *volumePositionModel = [HYKLineVolumePositionModel volumePositionModelWithStartPoint:startPoint endPoint:endPoint];
        [volumePositionModels addObject:volumePositionModel];
    }];
    
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(kLineBelowViewCurrentMaxVolume:minVolume:)]) {
            [self.delegate kLineBelowViewCurrentMaxVolume:maxVolume minVolume:minVolume];
        }
    }
    return volumePositionModels;
}


@end
