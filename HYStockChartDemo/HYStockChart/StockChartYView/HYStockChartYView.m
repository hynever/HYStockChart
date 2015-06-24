//
//  HYStockChartPriceView.m
//  jimustock
//
//  Created by jimubox on 15/5/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYStockChartYView.h"
#import "UIFont+HYStockChart.h"
#import "UIColor+HYStockChart.h"
#import "Masonry.h"

@interface HYStockChartYView ()

@property(nonatomic,strong) UILabel *maxValueLabel;

@property(nonatomic,strong) UILabel *middleValueLabel;

@property(nonatomic,strong) UILabel *minValueLabel;

@end

@implementation HYStockChartYView

-(void)setMaxValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    self.maxValueLabel.text = [NSString stringWithFormat:@"%.2f",maxValue];
}

-(void)setMiddleValue:(CGFloat)middleValue
{
    _middleValue = middleValue;
    self.middleValueLabel.text = [NSString stringWithFormat:@"%.2f",middleValue];
}

-(void)setMinValue:(CGFloat)minValue
{
    _minValue = minValue;
    self.minValueLabel.text = [NSString stringWithFormat:@"%.2f",minValue];
}

-(void)setMinLabelText:(NSString *)minLabelText
{
    _minLabelText = minLabelText;
    self.minValueLabel.text = minLabelText;
}

#pragma mark - get方法
#pragma mark maxPriceLabel的get方法
-(UILabel *)maxValueLabel
{
    if (!_maxValueLabel) {
        _maxValueLabel = [self private_createLabel];
        [self addSubview:_maxValueLabel];
        [_maxValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@20);
            make.width.equalTo(self);
        }];
    }
    return _maxValueLabel;
}

#pragma mark middlePriceLabel的get方法
-(UILabel *)middleValueLabel
{
    if (!_middleValueLabel) {
        _middleValueLabel = [self private_createLabel];
        [self addSubview:_middleValueLabel];
        [_middleValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(self.maxValueLabel);
            make.width.equalTo(self.maxValueLabel);
        }];
    }
    return _middleValueLabel;
}

#pragma mark minPriceLabel的get方法
-(UILabel *)minValueLabel
{
    if (!_minValueLabel) {
        _minValueLabel = [self private_createLabel];
        [self addSubview:_minValueLabel];
        [_minValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(self.maxValueLabel);
            make.width.equalTo(self.maxValueLabel);
        }];
    }
    return _minValueLabel;
}

#pragma mark - 私有方法
#pragma mark 创建Label
-(UILabel *)private_createLabel
{
    UILabel *label = [UILabel new];
    label.font = [UIFont f39Font];
    label.textColor = [UIColor assistTextColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
