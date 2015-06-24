//
//  JMSKLineModel.h
//  jimustock
//
//  Created by jimubox on 15/5/7.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  股票类型
 */
typedef NS_ENUM(NSInteger, JMSStockType){
    JMSStockTypeUSA = 1,        //美股
    JMSStockTypeA,              //A股
    JMSStockTypeHK,             //港股
    JMSStockTypeChinaConcept,   //中概股
    JMSStockTypeNone            //没有赋值的类型
};

@interface JMSKLineModel : NSObject

@property(nonatomic,copy) NSString *Symbol;

@property(nonatomic,copy) NSString *Currency;

//股票类型
@property(nonatomic,assign) JMSStockType StockType;
//交易所代码
@property(nonatomic,copy) NSString *ExchangeCode;

@property(nonatomic,assign) CGFloat ChangeFromLastClose;

@property(nonatomic,assign) CGFloat ChangeFromOpen;

@property(nonatomic,assign) CGFloat CummulativeCashDividend;

@property(nonatomic,assign) CGFloat CummulativeStockDividendRatio;

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

@property(nonatomic,assign) CGFloat MA5;

@property(nonatomic,assign) CGFloat MA10;

@property(nonatomic,assign) CGFloat MA20;

@property(nonatomic,assign)  CGFloat MA30;

@end
