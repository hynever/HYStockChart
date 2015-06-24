//
//  HYKLineLongPressProfileView.m
//  jimustock
//
//  Created by jimubox on 15/6/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYKLineLongPressProfileView.h"
#import "HYKLineModel.h"
#import "HYStockChartGloablVariable.h"
#import "UIColor+HYStockChart.h"
#import "HYStockChartTool.h"

@interface HYKLineLongPressProfileView ()

@property (weak, nonatomic) IBOutlet UILabel *chineseNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;

@property (weak, nonatomic) IBOutlet UILabel *closePriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *appliesLabel;

@property (weak, nonatomic) IBOutlet UILabel *openPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *openPriceNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *maxPriceNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *minPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *minPriceNameLabel;

@end

@implementation HYKLineLongPressProfileView

+(instancetype)kLineLongPressProfileView
{
    HYKLineLongPressProfileView *longPressProfileView = [[[NSBundle mainBundle] loadNibNamed:@"HYKLineLongPressProfileView" owner:nil options:nil] lastObject];
    longPressProfileView.chineseNameLabel.text = [HYStockChartGloablVariable stockChineseName];
//    longPressProfileView.symbolLabel.text = [HYStockChartGloablVariable stockSymbol];
    longPressProfileView.symbolLabel.text = @"APPL";
    return longPressProfileView;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor assistBackgroundColor];
    self.symbolLabel.textColor = [UIColor assistTextColor];
    self.chineseNameLabel.textColor = [UIColor mainTextColor];
    self.closePriceLabel.textColor = [UIColor mainTextColor];
    self.appliesLabel.textColor = [UIColor increaseColor];
    self.openPriceLabel.textColor = [UIColor mainTextColor];
    self.openPriceNameLabel.textColor = [UIColor assistTextColor];
    self.maxPriceLabel.textColor = [UIColor mainTextColor];
    self.maxPriceNameLabel.textColor = [UIColor assistTextColor];
    self.minPriceLabel.textColor = [UIColor mainTextColor];
    self.minPriceNameLabel.textColor = [UIColor assistTextColor];
}

#pragma mark - set方法
-(void)setKLineModel:(HYKLineModel *)kLineModel
{
    _kLineModel = kLineModel;
    
    NSString *currencySymbol = [HYStockChartTool currencySymbol];
    self.closePriceLabel.text = [NSString stringWithFormat:@"%@%.2f",currencySymbol,kLineModel.close];
    self.appliesLabel.text = [NSString stringWithFormat:@"%.2f%%",kLineModel.percentChangeFromOpen];
    UIColor *appliesLabelColor = kLineModel.percentChangeFromOpen > 0 ? [UIColor increaseColor] : [UIColor decreaseColor];
    self.appliesLabel.textColor = appliesLabelColor;
    self.openPriceLabel.text = [NSString stringWithFormat:@"%@%.2f",currencySymbol,kLineModel.open];
    self.maxPriceLabel.text = [NSString stringWithFormat:@"%@%.2f",currencySymbol,kLineModel.high];
    self.minPriceLabel.text = [NSString stringWithFormat:@"%@%.2f",currencySymbol,kLineModel.low];
}


@end
