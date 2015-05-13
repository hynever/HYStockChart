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

@interface HYTimeLineAboveView()

@property(nonatomic,strong) NSArray *positionModels;

@property(nonatomic,assign) CGFloat horizontalViewYPosition;

@property(nonatomic,strong) UIView *timeLabelView;

@property(nonatomic,strong) NSArray *timeLineModels;

@end

@implementation HYTimeLineAboveView

#pragma mark initWithFrame方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _positionModels = nil;
//        self.timeLabelView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (!self.timeLineModels) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    HYTimeLine *timeLine = [[HYTimeLine alloc] initWithContext:context];
    timeLine.positionModels = [self private_convertTimeLineModlesToPositionModel];
    timeLine.horizontalYPosition = self.horizontalViewYPosition;
    [timeLine draw];
}

-(void)setGroupModel:(HYTimeLineGroupModel *)groupModel
{
    _groupModel = groupModel;
    if (groupModel) {
        self.timeLineModels = groupModel.timeModels;
        self.timeLabelView.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - get&set方法
-(UIView *)timeLabelView
{
    if (!_timeLabelView) {
        _timeLabelView = [UIView new];
        [self addSubview:_timeLabelView];
        [_timeLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom);
            make.width.left.equalTo(self);
            make.height.equalTo(@(HYStockChartTimeLineTimeLabelViewHeight));
        }];
        UILabel *firstTimeLabel = [self private_createTimeLabel];
        firstTimeLabel.text = @"09:00";
        [_timeLabelView addSubview:firstTimeLabel];
        UILabel *secondTimeLabel = [self private_createTimeLabel];
        secondTimeLabel.text = @"13:00";
        [_timeLabelView addSubview:secondTimeLabel];
        UILabel *thirdTimeLabel = [self private_createTimeLabel];
        thirdTimeLabel.text = @"15:00";
        [_timeLabelView addSubview:thirdTimeLabel];
        [firstTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(_timeLabelView).offset(5);
            make.height.equalTo(_timeLabelView);
            make.width.equalTo(@(50));
        }];
        [secondTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_timeLabelView.mas_centerX);
            make.top.height.width.equalTo(firstTimeLabel);
        }];
        thirdTimeLabel.textAlignment = NSTextAlignmentRight;
        [thirdTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_timeLabelView.mas_right).offset(-5);
            make.top.height.width.equalTo(firstTimeLabel);
        }];
    }
    return _timeLabelView;
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
    for (HYTimeLineAbovePositionModel *positionModel in self.positionModels) {
        if (originXPosition < positionModel.currentPoint.x+gap && originXPosition > positionModel.currentPoint.x-gap) {
            return positionModel.currentPoint.x;
        }
    }
    return 0;
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
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    NSDate *minTime = [formatter dateFromString:@"09:30"];
    NSDate *maxTime = [formatter dateFromString:@"15:00"];
    NSTimeInterval timeInterval = [maxTime timeIntervalSinceDate:minTime];
    CGFloat minX = HYStockChartTimeLineAboveViewMinX;
    CGFloat maxX = HYStockChartTimeLineAboveViewMaxX;
    CGFloat xUnitValue = (timeInterval)/(maxX - minX);
    
    NSMutableArray *positionArray = [NSMutableArray array];
    
    formatter.dateFormat = @"hh:mm:ss a";
    for (HYTimeLineModel *timeLineModel in self.timeLineModels) {
        NSDate *currentTime = [formatter dateFromString:timeLineModel.currentTime];
        CGFloat xPosition = [currentTime timeIntervalSinceDate:minTime]/xUnitValue;
        CGFloat yPosition = (maxY - (timeLineModel.currentPrice - minPrice)/yUnitValue);
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

-(UILabel *)private_createTimeLabel
{
    UILabel *timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor redColor];
    return timeLabel;
}

@end
