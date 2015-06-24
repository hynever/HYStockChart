//
//  HYKLineVolumePositionModel.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/************************成交量位置模型************************/
@interface HYKLineVolumePositionModel : NSObject

@property(nonatomic,assign) CGPoint startPoint;

@property(nonatomic,assign) CGPoint endPoint;

/**
 *  根据x、y创建一个模型
 */
+(instancetype)volumePositionModelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
