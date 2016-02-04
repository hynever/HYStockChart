//
//  HYStockChartSegmentView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/13.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYStockChartSegmentView.h"
#import "Masonry.h"
#import "UIColor+HYStockChart.h"
#import "UIFont+HYStockChart.h"

static NSInteger const HYStockChartSegmentStartTag = 2000;

static CGFloat const HYStockChartSegmentIndicatorViewHeight = 2;

static CGFloat const HYStockChartSegmentIndicatorViewWidth = 40;

@interface HYStockChartSegmentView ()

@property(nonatomic,strong,readwrite) UIButton *selectedBtn;

@property(nonatomic,strong) UIView *indicatorView;

@end

@implementation HYStockChartSegmentView

#pragma mark - 初始化方法
#pragma mark 通过items创建SegmentView
-(instancetype)initWithItems:(NSArray *)items
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.items = items;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor assistBackgroundColor];
    }
    return self;
}

#pragma mark - get方法

#pragma mark indicatorView的get方法
-(UIView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [UIView new];
        _indicatorView.backgroundColor = [UIColor mainTextColor];
        [self addSubview:_indicatorView];
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-HYStockChartSegmentIndicatorViewHeight);
            make.height.equalTo(@(HYStockChartSegmentIndicatorViewHeight));
            make.width.equalTo(@(HYStockChartSegmentIndicatorViewWidth));
            make.centerX.equalTo(self);
        }];
    }
    return _indicatorView;
}

#pragma mark - set方法
#pragma mark items的set方法
-(void)setItems:(NSArray *)items
{
    _items = items;
    if (items.count == 0 || !items) {
        return;
    }
    NSInteger index = 0;
    NSInteger count = items.count;
    UIButton *preBtn = nil;
    for (NSString *title in items) {
        UIButton *btn = [self private_createButtonWithTitle:title tag:HYStockChartSegmentStartTag+index];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom).offset(-2);
            make.width.equalTo(self).multipliedBy(1.0f/count);
            if (preBtn) {
                make.left.equalTo(preBtn.mas_right);
            }else{
                make.left.equalTo(self);
            }
        }];
        preBtn = btn;
        index++;
    }
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    UIButton *btn = (UIButton *)[self viewWithTag:HYStockChartSegmentStartTag+selectedIndex];
    NSAssert(btn, @"Segmetn的按钮还没有初始化完毕!");
    [self event_segmentButtonClicked:btn];
}

-(void)setSelectedBtn:(UIButton *)selectedBtn
{
    if (_selectedBtn == selectedBtn) {
        return;
    }
    _selectedBtn = selectedBtn;
    _selectedIndex = selectedBtn.tag - HYStockChartSegmentStartTag;
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-HYStockChartSegmentIndicatorViewHeight);
        make.height.equalTo(@(HYStockChartSegmentIndicatorViewHeight));
        make.width.equalTo(@(HYStockChartSegmentIndicatorViewWidth));
        make.centerX.equalTo(selectedBtn.mas_centerX);
    }];
    [UIView animateWithDuration:0.2f animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - 私有方法
#pragma mark 根据title创建一个button
-(UIButton *)private_createButtonWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor mainTextColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont f16Font];
    btn.tag = tag;
    [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

#pragma mark - 事件执行方法
-(void)event_segmentButtonClicked:(UIButton *)btn
{
    self.selectedBtn = btn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(hyStockChartSegmentView:clickSegmentButtonIndex:)]) {
        [self.delegate hyStockChartSegmentView:self clickSegmentButtonIndex:btn.tag-HYStockChartSegmentStartTag];
    }
}

//- (UIColor *)randomColor {
//    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
//    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//}



@end
