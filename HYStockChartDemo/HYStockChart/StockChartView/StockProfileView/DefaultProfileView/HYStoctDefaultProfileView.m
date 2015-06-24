//
//  HYStockChartProfileView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/14.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYStoctDefaultProfileView.h"
#import "UIColor+HYStockChart.h"
#import "HYStockChartProfileModel.h"
#import "HYStockChartGloablVariable.h"
#import "HYStockChartTool.h"

@interface HYStoctDefaultProfileView ()

@property (weak, nonatomic) IBOutlet UILabel *chineseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *appliesLabel;


@property (weak, nonatomic) IBOutlet UILabel *volumeNameLabel;


@end

@implementation HYStoctDefaultProfileView

+(HYStoctDefaultProfileView *)profileView
{
    HYStoctDefaultProfileView *profileView = [[[NSBundle mainBundle] loadNibNamed:@"HYStoctDefaultProfileView" owner:nil options:nil] lastObject];
    return profileView;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor assistBackgroundColor];
    self.chineseNameLabel.textColor = [UIColor mainTextColor];
    self.currentPriceLabel.textColor = [UIColor mainTextColor];
    self.volumeLabel.textColor = [UIColor mainTextColor];
    self.updateTimeLabel.textColor = [UIColor mainTextColor];
    
    self.symbolLabel.textColor = [UIColor assistTextColor];
    self.appliesLabel.textColor = [UIColor assistTextColor];
    self.volumeNameLabel.textColor = [UIColor assistTextColor];
    self.updateDateLabel.textColor = [UIColor assistTextColor];
}

-(void)setProfileModel:(HYStockChartProfileModel *)profileModel
{
    _profileModel = profileModel;
    self.chineseNameLabel.text = [HYStockChartGloablVariable stockChineseName];
    self.symbolLabel.text = [HYStockChartGloablVariable stockSymbol];
    NSString *currencySymbol = [HYStockChartTool currencySymbol];
    self.currentPriceLabel.text = [NSString stringWithFormat:@"%@%.2f",currencySymbol,profileModel.CurrentPrice];
    NSString *volumeString = [NSString stringWithFormat:@"%.f",profileModel.Volume];
    if (volumeString.length >= 9 ) {
        volumeString = [NSString stringWithFormat:@"%.2f亿股",profileModel.Volume/100000000.0];
    }else{
        volumeString = [NSString stringWithFormat:@"%.2f万股",profileModel.Volume/10000.0];
    }
    self.volumeLabel.text = volumeString;
    self.appliesLabel.text = [NSString stringWithFormat:@"%.2f%%",profileModel.applies];
    UIColor *appliesTextColor = profileModel.applies > 0 ? [UIColor increaseColor] : [UIColor decreaseColor];
    self.appliesLabel.textColor = appliesTextColor;
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"HH:mm";
    self.updateTimeLabel.text = [formatter stringFromDate:[NSDate date]];
    formatter.dateFormat = @"yyyy-MM-dd";
    self.updateDateLabel.text = [formatter stringFromDate:[NSDate date]];
}


@end
