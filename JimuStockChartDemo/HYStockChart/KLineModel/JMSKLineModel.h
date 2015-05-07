//
//  JMSKLineModel.h
//  jimustock
//
//  Created by jimubox on 15/5/7.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSKLineModel : NSObject

@property(nonatomic,assign) CGFloat ChangeFromLastClose;

@property(nonatomic,assign) CGFloat ChangeFromOpen;

@property(nonatomic,assign) CGFloat CummulativeCashDividend;

@property(nonatomic,assign) CGFloat CummulativeStockDividendRatio;

@property(nonatomic,copy) NSString *Currency;

@property(nonatomic,copy) NSString *DataConfidence;

@property(nonatomic,copy) NSString *Date;

/**
 *  最高价
 */
@property(nonatomic,assign) CGFloat High;

/**
 *  收盘价
 */
@property(nonatomic,assign) CGFloat Last;

@property(nonatomic,assign) CGFloat LastClose;

/**
 *  最低价
 */
@property(nonatomic,assign) CGFloat Low;

/**
 *  开盘价
 */
@property(nonatomic,assign) CGFloat Open;

/**
 *  收盘价相对于开盘价的增减比例
 */
@property(nonatomic,assign) CGFloat PercentChangeFromLastClose;

@property(nonatomic,assign) CGFloat PercentChangeFromOpen;

/**
 *  成交量
 */
@property(nonatomic,assign) NSInteger Volume;

@end
