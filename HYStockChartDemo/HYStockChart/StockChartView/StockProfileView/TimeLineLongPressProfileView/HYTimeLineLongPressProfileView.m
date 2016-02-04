//
//  HYTimeLineLongPressProfileView.m
//  jimustock
//
//  Created by jimubox on 15/6/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYTimeLineLongPressProfileView.h"
#import "HYStockChartGloablVariable.h"
#import "HYTimeLineModel.h"
#import "UIColor+HYStockChart.h"
#import "NSDateFormatter+HYStockChart.h"
#import "HYStockChartTool.h"

@interface HYTimeLineLongPressProfileView ()

@property (weak, nonatomic) IBOutlet UILabel *chineseNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;



@property (weak, nonatomic) IBOutlet UILabel *appliesLabel;

@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *volumeNameLabel;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

@implementation HYTimeLineLongPressProfileView

+(instancetype)timeLineLongPressProfileView
{
    HYTimeLineLongPressProfileView *timeLineLongPressProfileView = [[[NSBundle mainBundle] loadNibNamed:@"HYTimeLineLongPressProfileView" owner:nil options:nil] lastObject];
    return timeLineLongPressProfileView;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor assistBackgroundColor];
    self.chineseNameLabel.textColor = [UIColor mainTextColor];
    self.symbolLabel.textColor = [UIColor assistTextColor];
    self.priceLabel.textColor = [UIColor mainTextColor];
    self.appliesLabel.textColor = [UIColor mainTextColor];
    self.volumeLabel.textColor = [UIColor mainTextColor];
    self.volumeNameLabel.textColor = [UIColor assistTextColor];
    self.timeLabel.textColor = [UIColor mainTextColor];
    self.dateLabel.textColor = [UIColor assistTextColor];
}

-(void)setTimeLineModel:(HYTimeLineModel *)timeLineModel
{
    NSDateFormatter *formatter = [NSDateFormatter shareDateFormatter];
    _timeLineModel = timeLineModel;
    self.chineseNameLabel.text = [HYStockChartGloablVariable stockChineseName];
    self.symbolLabel.text = [HYStockChartGloablVariable stockSymbol];
    NSString *currencySymbol = [HYStockChartTool currencySymbol];
    self.priceLabel.text = [NSString stringWithFormat:@"%@%.2f",currencySymbol,timeLineModel.currentPrice];
    self.appliesLabel.text = [NSString stringWithFormat:@"%.2f%%",timeLineModel.PercentChangeFromPreClose];
    UIColor *appliesTextColor = timeLineModel.PercentChangeFromPreClose > 0 ? [UIColor increaseColor] : [UIColor decreaseColor];
    self.appliesLabel.textColor = appliesTextColor;
    NSString *volumeString = [NSString stringWithFormat:@"%.ld",timeLineModel.volume];
    if (volumeString.length >= 9 ) {
        volumeString = [NSString stringWithFormat:@"%.2f亿股",timeLineModel.volume/100000000.0];
    }else{
        volumeString = [NSString stringWithFormat:@"%.2f万股",timeLineModel.volume/10000.0];
    }
    self.volumeLabel.text = volumeString;
    formatter.dateFormat = @"MM-dd-yyyy hh:mm:ss a";
    NSDate *date = [formatter dateFromString:timeLineModel.currentTime];
    formatter.dateFormat = @"HH:mm:ss";
    NSString *timeStr = [formatter stringFromDate:date];
    formatter.dateFormat = @"yyyy-dd-MM";
    NSString *dateStr = [formatter stringFromDate:date];
    self.timeLabel.text = timeStr;
    self.dateLabel.text = dateStr;
}


@end
