//
//  HYStockChartProfileModel.h
//  jimustock
//
//  Created by jimubox on 15/6/6.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYStockChartGloablVariable.h"

@interface HYStockChartProfileModel : NSObject

@property(nonatomic,copy) NSString *Name;

@property(nonatomic,copy) NSString *ChineseName;

@property(nonatomic,copy) NSString *Symbol;

@property(nonatomic,assign) CGFloat CurrentPrice;

@property(nonatomic,assign) CGFloat Volume;

@property(nonatomic,assign) HYStockType stockType;

/**
 *  涨跌幅
 */
@property(nonatomic,assign) CGFloat applies;

@end
