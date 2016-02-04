//
//  HYTimeLineGroupModel.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/11.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYTimeLineModel.h"

@interface HYTimeLineGroupModel : NSObject

/**
 *  这个数组装得是HYTimeLineModel
 */
@property(nonatomic,strong) NSArray *timeModels;

@property(nonatomic,assign) CGFloat lastDayEndPrice;

+(instancetype)groupModelWithTimeModels:(NSArray *)timeModels lastDayEndPrice:(CGFloat)lastDayEndPrice;

@end
