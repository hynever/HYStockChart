//
//  HYKLineVolume.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYKLineVolumePositionModel.h"
#import "HYKLineModel.h"

/************************画成交量线的画笔************************/
@interface HYKLineVolume : NSObject

/**
 *  位置模型
 */
@property(nonatomic,strong) HYKLineVolumePositionModel *positionModel;

/**
 *  K线模型，里面包含成交量
 */
@property(nonatomic,strong) HYKLineModel *kLineModel;

@property(nonatomic,strong) UIColor *lineColor;


-(instancetype)initWithContext:(CGContextRef)context;

/**
 *  绘制成交量
 */
-(void)draw;

@end
