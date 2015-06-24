//
//  JMBBrokenLineLongPressProfileView.m
//  jimustock
//
//  Created by jimubox on 15/6/9.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYBrokenLineLongPressProfileView.h"
#import "UIColor+HYStockChart.h"
#import "HYStockChartGloablVariable.h"
#import "HYTimeLineModel.h"
#import "NSDateFormatter+HYStockChart.h"
#import "HYStockChartTool.h"

@interface HYBrokenLineLongPressProfileView ()

@property (weak, nonatomic) IBOutlet UILabel *chineseNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *appliesLabel;

@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@property (weak, nonatomic) IBOutlet UILabel *volumeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation HYBrokenLineLongPressProfileView

+(instancetype)brokenLineLongPressProfileView
{
    HYBrokenLineLongPressProfileView *brokenLineLongPressProfileView = (HYBrokenLineLongPressProfileView *)[[[NSBundle mainBundle] loadNibNamed:@"HYBrokenLineLongPressProfileView" owner:nil options:nil] lastObject];
    return brokenLineLongPressProfileView;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor assistBackgroundColor];
    self.chineseNameLabel.textColor = [UIColor mainTextColor];
    self.symbolLabel.textColor = [UIColor assistTextColor];
    self.priceLabel.textColor = [UIColor mainTextColor];
    self.appliesLabel.textColor = [UIColor assistTextColor];
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
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter stringFromDate:date];
    self.dateLabel.text = dateStr;
    formatter.dateFormat = @"HH:mm";
    NSString *timeStr = [formatter stringFromDate:date];
    self.timeLabel.text = timeStr;
}

@end
