//
//  HYTimeLineView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYTimeLineView.h"
#import "HYTimeLineAboveView.h"
#import "HYTimeLineBelowView.h"
#import "Masonry.h"

@interface HYTimeLineView()

@property(nonatomic,strong) HYTimeLineAboveView *aboveView;

@property(nonatomic,strong) HYTimeLineBelowView *belowView;

@end

@implementation HYTimeLineView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.aboveViewRatio = 0.7;
        self.aboveView.backgroundColor = [UIColor lightGrayColor];
        self.belowView.backgroundColor = [UIColor grayColor];
    }
    return self;
}

#pragma mark set&get方法
#pragma mark aboveView的get方法
-(HYTimeLineAboveView *)aboveView
{
    if (!_aboveView) {
        _aboveView = [HYTimeLineAboveView new];
        [self addSubview:_aboveView];
        [_aboveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(self).multipliedBy(self.aboveViewRatio);
        }];
    }
    return _aboveView;
}

#pragma mark belowView的get方法
-(HYTimeLineBelowView *)belowView
{
    if (!_belowView) {
        _belowView = [HYTimeLineBelowView new];
        [self addSubview:_belowView];
        [_belowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.aboveView.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(self).multipliedBy(1-self.aboveViewRatio);
        }];
    }
    return _belowView;
}

#pragma mark aboveViewRatio的set方法
-(void)setAboveViewRatio:(CGFloat)aboveViewRatio
{
    _aboveViewRatio = aboveViewRatio;
    [_aboveView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self).multipliedBy(_aboveViewRatio);
    }];
    [_belowView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self).multipliedBy(1-_aboveViewRatio);
    }];
}

@end
