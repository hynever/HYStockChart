//
//  HYTimeLineGroupModel.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/11.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYTimeLineGroupModel.h"
#import "MJExtension.h"

@implementation HYTimeLineGroupModel

+(instancetype)groupModelWithTimeModels:(NSArray *)timeModels lastDayEndPrice:(CGFloat)lastDayEndPrice
{
    HYTimeLineGroupModel *groupModel = [[HYTimeLineGroupModel alloc] init];
    groupModel.timeModels = timeModels;
    groupModel.lastDayEndPrice = lastDayEndPrice;
    return groupModel;
}

@end
