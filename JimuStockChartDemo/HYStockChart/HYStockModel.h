//
//  HYStockModel.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface HYStockModel : NSObject

@property(nonatomic,assign) CGFloat adjClose;

@property(nonatomic,copy) NSString *date;

@property(nonatomic,assign) CGFloat high;

@property(nonatomic,assign) CGFloat low;

@property(nonatomic,assign) CGFloat open;

@property(nonatomic,assign) CGFloat close;

@property(nonatomic,assign) CGFloat volume;

@end
