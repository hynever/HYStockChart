//
//  HYTimeLineVolume.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/11.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

/************************分时线上成交量的画笔************************/
@interface HYTimeLineVolume : NSObject

@property(nonatomic,strong) NSArray *timeLineVolumnPositionModels;

-(instancetype)initWithContext:(CGContextRef)context;

-(void)draw;

@end
