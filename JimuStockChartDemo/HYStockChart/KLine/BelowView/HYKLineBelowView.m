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
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark drawRect方法
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (!self.needDrawKLinePositionModels) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    HYKLineVolume *kLineVolume = [[HYKLineVolume alloc] initWithContext:context];
    [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
    self.needDrawKLinePositionModels = [self private_convertToKLinePositionModelWithKLineModels:self.needDrawKLineModels];
    [self setNeedsDisplay];
}

#pragma mark - 私有方法
#pragma mark 根据KLineMoel转换成Position数组
-(NSArray *)private_convertToKLinePositionModelWithKLineModels:(NSArray *)kLineModels
{
    CGFloat minY = HYStockChartBelowViewMinY;
    CGFloat maxY = HYStockChartBelowViewMaxY;
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
        if (ABS(yPosition - HYStockChartBelowViewMaxY) < 0.5) {
            yPosition = 1;
        }
        CGPoint startPoint = CGPointMake(xPosition, yPosition);
        CGPoint endPoint = CGPointMake(xPosition, HYStockChartBelowViewMaxY);
        HYKLineVolumePositionModel *volumePositionModel = [HYKLineVolumePositionModel volumePositionModelWithStartPoint:startPoint Y:endPoint];
        [volumePositionModels addObject:volumePositionModel];
    }];
    return volumePositionModels;
}


@end
