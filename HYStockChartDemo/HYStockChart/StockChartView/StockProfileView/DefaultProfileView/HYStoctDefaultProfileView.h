//
//  HYStockChartProfileView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/14.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYStockChartProfileModel;
/************************股票概要View(在顶部的view)************************/
@interface HYStoctDefaultProfileView : UIView

@property(nonatomic,strong) HYStockChartProfileModel *profileModel;

+(HYStoctDefaultProfileView *)profileView;

@end
