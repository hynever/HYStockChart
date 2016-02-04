//
//  HYTimeLine.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTimeLineAbovePositionModel.h"

/************************用于画分时线的画笔************************/
@interface HYTimeLine : NSObject

@property(nonatomic,strong) NSArray *positionModels;

@property(nonatomic,assign) CGFloat horizontalYPosition;

@property(nonatomic,assign) CGFloat timeLineViewWidth;

-(instancetype)initWithContext:(CGContextRef)context;

-(void)draw;

@end
