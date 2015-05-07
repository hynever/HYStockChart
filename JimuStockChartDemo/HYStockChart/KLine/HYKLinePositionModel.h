//
//  HYKLinePositionModel.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


/************************K线数据模型************************/
@interface HYKLinePositionModel : NSObject

/**
 *  开盘点
 */
@property(nonatomic,assign) CGPoint openPoint;

/**
 *  收盘点
 */
@property(nonatomic,assign) CGPoint closePoint;

/**
 *  最高点
 */
@property(nonatomic,assign) CGPoint highPoint;

/**
 *  最低点
 */
@property(nonatomic,assign) CGPoint lowPoint;


/**
 *  根据属性创建模型的工厂方法
 */
+(instancetype)modelWithOpen:(CGPoint)openPoint close:(CGPoint)closePoint high:(CGPoint)highPoint low:(CGPoint)lowPoint;

@end
