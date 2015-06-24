//
//  JMSTimeLineModel.h
//  jimustock
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

/************************分时线的Model************************/
@interface JMSTimeLineModel : NSObject

@property(nonatomic,assign) CGFloat Close;

@property(nonatomic,copy) NSString *EndDate;

@property(nonatomic,copy) NSString *EndTime;

@property(nonatomic,assign) CGFloat High;

@property(nonatomic,assign) CGFloat Low;

@property(nonatomic,assign) CGFloat Open;

@property(nonatomic,copy) NSString *StartDate;

@property(nonatomic,copy) NSString *StartTime;

@property(nonatomic,assign) NSInteger Volume;

@property(nonatomic,assign) CGFloat VWAP;

@property(nonatomic,assign) CGFloat UTCOffset;

@property(nonatomic,assign) CGFloat Trades;

@property(nonatomic,assign) CGFloat TWAP;

@property(nonatomic,assign) CGFloat ChangeFromPreClose;

@property(nonatomic,assign) CGFloat PercentChangeFromPreClose;



@end
