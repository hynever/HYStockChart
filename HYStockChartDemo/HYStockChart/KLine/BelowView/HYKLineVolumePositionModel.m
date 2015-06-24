//
//  HYKLineVolumePositionModel.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYKLineVolumePositionModel.h"

@implementation HYKLineVolumePositionModel

/**
 *  根据x、y创建一个模型
 */
+(instancetype)volumePositionModelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    HYKLineVolumePositionModel *volumePosition = [HYKLineVolumePositionModel new];
    volumePosition.startPoint = startPoint;
    volumePosition.endPoint = endPoint;
    return volumePosition;
}


@end
