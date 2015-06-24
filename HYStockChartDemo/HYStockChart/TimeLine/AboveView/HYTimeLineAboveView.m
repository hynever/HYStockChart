//
//  HYTimeLineAboveView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYTimeLineAboveView.h"
#import "HYTimeLineModel.h"
#import "HYStockChartConstant.h"
#import "HYTimeLineAbovePositionModel.h"
#import "HYTimeLine.h"
#import "Masonry.h"
#import "HYTimeLineGroupModel.h"
#import "UIColor+HYStockChart.h"
#import "NSDateFormatter+HYStockChart.h"
#import "HYStockChartGloablVariable.h"
#import "MJExtension.h"

@interface HYTimeLineAboveView()

@property(nonatomic,strong) NSArray *positionModels;

@property(nonatomic,assign) CGFloat horizontalViewYPosition;

@property(nonatomic,strong) UIView *timeLabelView;

@property(nonatomic,strong) NSArray *timeLineModels;

@property(nonatomic,strong) UILabel *firstTimeLabel;

@property(nonatomic,strong) UILabel *secondTimeLabel;

@property(nonatomic,strong) UILabel *thirdTimeLabel;

@end

@implementation HYTimeLineAboveView

#pragma mark initWithFrame方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _positionModels = nil;
        _horizontalViewYPosition = 0;
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    if (!self.timeLineModels) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor backgroundColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetFillColorWithColor(context, [UIColor assistBackgroundColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, HYStockChartTimeLineAboveViewMaxY, self.frame.size.width, self.frame.size.height-HYStockChartTimeLineAboveViewMaxY));
    
    HYTimeLine *timeLine = [[HYTimeLine alloc] initWithContext:context];
    timeLine.positionModels = [self private_convertTimeLineModlesToPositionModel];
    timeLine.horizontalYPosition = self.horizontalViewYPosition;
    timeLine.timeLineViewWidth = self.frame.size.width;
    [timeLine draw];
    [super drawRect:rect];
}

#pragma mark - get&set方法
-(UIView *)timeLabelView
{
    if (!_timeLabelView) {
        _timeLabelView = [UIView new];
        [self addSubview:_timeLabelView];
        [_timeLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.width.left.equalTo(self);
            make.height.equalTo(@(HYStockChartTimeLineTimeLabelViewHeight));
        }];
        NSString *startTime = nil;
        NSString *middleTime = nil;
        NSString *endTime = nil;
        HYStockType stockType = [HYStockChartGloablVariable stockType];
        switch (stockType) {
            case HYStockTypeA:
                startTime = @"09:30";
                middleTime = @"13:00";
                endTime = @"15:00";
                break;
            case HYStockTypeUSA:
                startTime = @"09:30";
                middleTime = @"12:45";
                endTime = @"16:00";
                break;
            default:
                break;
        }
        self.firstTimeLabel = [self private_createTimeLabel];
        self.firstTimeLabel.text = startTime;
        [_timeLabelView addSubview:self.firstTimeLabel];
        self.secondTimeLabel = [self private_createTimeLabel];
        self.secondTimeLabel.text = middleTime;
        [_timeLabelView addSubview:self.secondTimeLabel];
        self.thirdTimeLabel = [self private_createTimeLabel];
        self.thirdTimeLabel.text = endTime;
        [_timeLabelView addSubview:self.thirdTimeLabel];
        [self.firstTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(_timeLabelView).offset(5);
            make.height.equalTo(@(10));
            make.width.equalTo(@(50));
        }];
        [self.secondTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_timeLabelView.mas_centerX);
            make.top.height.width.equalTo(self.firstTimeLabel);
        }];
        self.thirdTimeLabel.textAlignment = NSTextAlignmentRight;
        [self.thirdTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_timeLabelView.mas_right).offset(-5);
            make.top.height.width.equalTo(self.firstTimeLabel);
        }];
    }
    return _timeLabelView;
}

#pragma mark groupModel的set方法
-(void)setGroupModel:(HYTimeLineGroupModel *)groupModel
{
    _groupModel = groupModel;
    
    if (groupModel) {
        
        //先将groupModel里面的数组根据时间排序
        NSArray *timeLineModels = groupModel.timeModels;
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MM-dd-yyyy";
        NSDateFormatter *timeFormatter = [NSDateFormatter new];
        timeFormatter.dateFormat = @"hh:mm:ss a";
        NSArray *newTimeLineModels = [timeLineModels sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            HYTimeLineModel *timeLineModel1 = (HYTimeLineModel *)obj1;
            HYTimeLineModel *timeLineModel2 = (HYTimeLineModel *)obj2;
            NSDate *date1 = [dateFormatter dateFromString:timeLineModel1.currentDate];
            NSDate *date2 = [dateFormatter dateFromString:timeLineModel2.currentDate];
            if ([date1 compare:date2] != NSOrderedSame) {
                return [date1 compare:date2];
            }else{
                date1 = [timeFormatter dateFromString:timeLineModel1.currentTime];
                date2 = [timeFormatter dateFromString:timeLineModel2.currentTime];
                return [date1 compare:date2];
            }
            return YES;
        }];
        
        self.timeLineModels = newTimeLineModels;
        _groupModel.timeModels = newTimeLineModels;
        self.timeLabelView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - 公有方法
#pragma mark 画时分线的方法
-(void)drawAboveView
{
    NSAssert(self.timeLineModels, @"timeLineModels不能为空!");
    [self setNeedsDisplay];
}

#pragma mark 长按的时候根据原始的x的位置获得精确的X的位置
-(CGFloat)getRightXPositionWithOriginXPosition:(CGFloat)originXPosition
{
    NSAssert(_positionModels, @"位置数组不能为空!");
    CGFloat gap = 0.6;
    if (self.positionModels.count > 1) {
        HYTimeLineAbovePositionModel *firstModel = [self.positionModels firstObject];
        HYTimeLineAbovePositionModel *secondModel = self.positionModels[1];
        gap = (secondModel.currentPoint.x - firstModel.currentPoint.x)/2;
    }
    NSInteger idx = 0;
    for (HYTimeLineAbovePositionModel *positionModel in self.positionModels) {
        if (originXPosition < positionModel.currentPoint.x+gap && originXPosition > positionModel.currentPoint.x-gap) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(timeLineAboveViewLongPressTimeLineModel:)]) {
                [self.delegate timeLineAboveViewLongPressTimeLineModel:self.timeLineModels[idx]];
            }
            return positionModel.currentPoint.x;
        }
        idx++;
    }
    //这里必须为负数，没有找到的合适的位置，竖线就返回这个位置。
    return -10;
}

#pragma mark - 私有方法
#pragma mark 将HYTimeLineModel转换成对应的position模型
-(NSArray *)private_convertTimeLineModlesToPositionModel
{
    NSAssert(self.timeLineModels, @"timeLineModels不能为空!");
    //1.算y轴的单元值
    HYTimeLineModel *firstModel = [self.timeLineModels firstObject];
    __block CGFloat minPrice = firstModel.currentPrice;
    __block CGFloat maxPrice = firstModel.currentPrice;
    [self.timeLineModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HYTimeLineModel *timeLineModel = (HYTimeLineModel *)obj;
        if (timeLineModel.currentPrice < minPrice) {
            minPrice = timeLineModel.currentPrice;
        }
        if (timeLineModel.currentPrice > maxPrice) {
            maxPrice = timeLineModel.currentPrice;
        }
    }];
    CGFloat minY = HYStockChartTimeLineAboveViewMinY;
    CGFloat maxY = HYStockChartTimeLineAboveViewMaxY;
    CGFloat yUnitValue = (maxPrice - minPrice)/(maxY-minY);
    
    self.horizontalViewYPosition = (self.groupModel.lastDayEndPrice-minPrice)/yUnitValue;
    
    //2.算出x轴的单元值
    CGFloat xUnitValue = [self private_getXAxisUnitValue];
    
    //转换成posisiton的模型，为了不多遍历一次数组，在这里顺便把折线情况下的日期也设置一下
    NSMutableArray *positionArray = [NSMutableArray array];
    NSInteger index = 0;

    //设置一下时间
    if (self.centerViewType == HYStockChartCenterViewTypeBrokenLine) {
        self.firstTimeLabel.text = [firstModel.currentDate substringToIndex:5];
        HYTimeLineModel *middleModel = [self.timeLineModels objectAtIndex:self.timeLineModels.count/2];
        self.secondTimeLabel.text = [middleModel.currentDate substringToIndex:5];
        HYTimeLineModel *lastModel = [self.timeLineModels lastObject];
        self.thirdTimeLabel.text = [lastModel.currentDate substringToIndex:5];
    }
    
    CGFloat oldXPosition = -1;
    for (HYTimeLineModel *timeLineModel in self.timeLineModels) {
        CGFloat xPosition = 0;
        CGFloat yPosition = 0;
        switch (self.centerViewType) {
            case HYStockChartCenterViewTypeTimeLine:
            {
                if (oldXPosition < 0) {
                    oldXPosition = 0;
                    xPosition = oldXPosition;
                }else{
                    //每2分钟一次数据
                    xPosition = oldXPosition+2*xUnitValue;
                    oldXPosition = xPosition;
                }
                yPosition = (maxY - (timeLineModel.currentPrice - minPrice)/yUnitValue);
            }
                break;
            case HYStockChartCenterViewTypeBrokenLine:
            {
                if (oldXPosition < 0) {
                    oldXPosition = HYStockChartTimeLineAboveViewMinX;
                    xPosition = oldXPosition;
                }else{
                    //5日线每10分钟取一次
                    xPosition = oldXPosition + 10*xUnitValue;
                    oldXPosition = xPosition;
                }
                yPosition = (maxY - (timeLineModel.currentPrice - minPrice)/yUnitValue);
            }
                break;
            default:break;
        }
        index++;
        NSAssert(!isnan(xPosition)&&!isnan(yPosition), @"x或y出现NAN值!");
        HYTimeLineAbovePositionModel *positionModel = [HYTimeLineAbovePositionModel new];
        positionModel.currentPoint = CGPointMake(xPosition, yPosition);
        [positionArray addObject:positionModel];
    }
    _positionModels = positionArray;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(timeLineAboveView:positionModels:)]) {
            [self.delegate timeLineAboveView:self positionModels:positionArray];
        }
    }
    return positionArray;
}

#pragma mark 创建时间的label
-(UILabel *)private_createTimeLabel
{
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.textColor = [UIColor colorWithRGBHex:0x2d333a];
    return timeLabel;
}

-(CGFloat)private_getXAxisUnitValue
{
    NSTimeInterval oneDayTradeTimes = [self private_oneDayTradeTimes];
    CGFloat xUnitValue = 0;
    if (self.centerViewType == HYStockChartCenterViewTypeTimeLine) {
        xUnitValue = (HYStockChartTimeLineAboveViewMaxX-HYStockChartTimeLineAboveViewMinX)/oneDayTradeTimes;
        return xUnitValue;
    }else{
        HYTimeLineModel *currentModel = [self.timeLineModels firstObject];
        NSInteger days = 1;
        for (HYTimeLineModel *timeLineModel in self.timeLineModels) {
            if (![currentModel.currentDate isEqualToString:timeLineModel.currentDate]) {
                currentModel = timeLineModel;
                days += 1;
            }
        }
        NSTimeInterval totalMinutes = days * oneDayTradeTimes;
        xUnitValue = (HYStockChartTimeLineAboveViewMaxX-HYStockChartTimeLineAboveViewMinX)/totalMinutes;
        
        return xUnitValue;
    }
}


#pragma mark 一天的交易总时间，单位是分钟
-(CGFloat)private_oneDayTradeTimes
{
    HYStockType stockType = [HYStockChartGloablVariable stockType];
    switch (stockType) {
        case HYStockTypeA:
            //（9：30-11：30，13：00-15：00）
            return 240;
            break;
        case HYStockTypeUSA:
            //（9：30-16：00）
            return 390;
            break;
        default:
            return 240;
            break;
    }
}

//-(CGFloat)private_getTodayTimeOffsetWithCurrentTime:(NSString *)currentTime
//{
//    NSDateFormatter *formatter = [NSDateFormatter shareDateFormatter];
//    formatter.dateFormat = @"MM-dd-yyyy hh:mm:ss a";
//    NSDate *currentDateTime = [formatter dateFromString:currentTime];
//
//    
//    NSArray *currentTimes = [currentTime componentsSeparatedByString:@" "];
//    NSString *formatStartTimeString = [[currentTimes firstObject] stringByAppendingString:@" 09:30:00 AM"];
//    NSDate *formatStartTime = [formatter dateFromString:formatStartTimeString];
//    
//    NSString *formatMiddleStartTimeString = [[currentTimes firstObject] stringByAppendingString:@" 01:00:00 PM"];
//    NSDate *formatMiddleStartTime = [formatter dateFromString:formatMiddleStartTimeString];
//    HYStockType stockType = [HYStockChartGloablVariable stockType];
//    switch (stockType) {
//        case HYStockTypeA:
//            if ([currentDateTime timeIntervalSinceDate:formatMiddleStartTime] >= 0) {
//                currentDateTime = [currentDateTime dateByAddingTimeInterval:-5400];
//            }
//            break;
//        case HYStockTypeUSA:break;
//        default:
//            break;
//    }
//
//    
//    NSTimeInterval rightTimeInterval = [currentDateTime timeIntervalSinceDate:formatStartTime]/60;
//    return rightTimeInterval;
//}

//-(CGFloat)private_getXOffsetFromTime:(NSString *)minTimeString toTime:(NSString *)maxTimeString xUnitValue:(CGFloat)xUnitValue
//{
//    NSDateFormatter *formatter = [NSDateFormatter shareDateFormatter];
//    formatter.dateFormat = @"MM-dd-yyyy hh:mm:ss a";
//
//    //0.格式化minTime为当天的日期和00:00:00
//    NSArray *minTimes = [minTimeString componentsSeparatedByString:@" "];
//    NSString *formatMinTimeString = [[minTimes firstObject] stringByAppendingString:@" 00:00:00 AM"];
//    NSDate *formatMinTime = [formatter dateFromString:formatMinTimeString];
//
//    //1.格式化maxTime为当天的日期和00:00:00
//    NSArray *maxTimes = [maxTimeString componentsSeparatedByString:@" "];
//    NSString *formatMaxTimeString = [[maxTimes firstObject] stringByAppendingString:@" 00:00:00 AM"];
//    NSDate *formatMaxTime = [formatter dateFromString:formatMaxTimeString];
//
//    //2.算出间隔有多少天
//    NSTimeInterval daysInterval = [formatMaxTime timeIntervalSinceDate:formatMinTime];
//    NSInteger days = daysInterval/(24*60*60);
//
//    //3.加上maxTime的time距离09:30:00有多少分钟
//    NSTimeInterval lastTimeInterval = [self private_getTodayTimeOffsetWithCurrentTime:maxTimeString];
//    NSTimeInterval totalTimeInterval = days*[self private_oneDayTradeTimes]+lastTimeInterval;
//
//    //4.除以xUnitValue
//    return totalTimeInterval/xUnitValue;
//}


@end
