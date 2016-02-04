//
//  HYKLinePositionModel.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYKLinePositionModel.h"

@implementation HYKLinePositionModel

#pragma mark 用属性创建一个模型
+(instancetype)modelWithOpen:(CGPoint)openPoint close:(CGPoint)closePoint high:(CGPoint)highPoint low:(CGPoint)lowPoint
{
    HYKLinePositionModel *model = [HYKLinePositionModel new];
    model.openPoint = openPoint;
    model.closePoint = closePoint;
    model.highPoint = highPoint;
    model.lowPoint = lowPoint;
    return model;
}

@end
