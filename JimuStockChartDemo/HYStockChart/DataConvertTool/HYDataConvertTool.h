//
//  HYDataConvertTool.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/5.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYStockModel.h"


/************************数据转换工具************************/
@interface HYDataConvertTool : NSObject

/**
 *  根据股票数据转换成坐标数据
 */
-(NSArray *)convertToCoordinateWithStockData:(HYStockModel *)stockModel;


@end
