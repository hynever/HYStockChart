//
//  HYKLineView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYKLineView.h"
#import "Masonry.h"
#import "HYConstant.h"
#import "HYKLineInnerView.h"
#import "HYStockModel.h"

@interface HYKLineView ()<UIScrollViewDelegate,HYKLineInnerViewDelegate>

@property(nonatomic,strong) UIView *timeView;

@property(nonatomic,strong) UIView *priceView;

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) HYKLineInnerView *kLineInnerView;

@property(nonatomic,strong) NSMutableArray *needDrawStockModels;

@end

@implementation HYKLineView

#pragma mark initWithFrame方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.needDrawStockModels = [NSMutableArray array];
        self.priceView.backgroundColor = [UIColor redColor];
        self.timeView.backgroundColor = [UIColor yellowColor];
        self.scrollView.backgroundColor = [UIColor whiteColor];
//        self.kLineInnerView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - get&set方法
#pragma mark YView的get方法
-(UIView *)priceView
{
    _priceView = [UIView new];
    [self addSubview:_priceView];
    WS(weakSelf);
    [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf.mas_left);
        make.height.equalTo(weakSelf.mas_height);
        make.width.equalTo(@(HYStockChartKLinePriceViewWidth));
    }];
    return _priceView;
}

#pragma mark XView的get方法
-(UIView *)timeView
{
    if (!_timeView) {
        _timeView = [UIView new];
        [self addSubview:_timeView];
        WS(weakSelf);
        [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.priceView.mas_right);
            make.bottom.equalTo(weakSelf.mas_bottom);
            make.height.equalTo(@(HYStockChartKLineTimeViewHeight));
            make.right.equalTo(weakSelf.mas_right);
        }];
    }
    return _timeView;
}

#pragma mark UIScrollView的get方法
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
//        _scrollView.delegate = self;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 10.0;
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.alwaysBounceHorizontal = YES;
        [self addSubview:_scrollView];
        WS(weakSelf);
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf.priceView.mas_right);
            make.right.equalTo(weakSelf.mas_right);
            make.bottom.equalTo(weakSelf.timeView.mas_top);
        }];
    }
    return _scrollView;
}

#pragma mark kLineInnerView的get方法
-(HYKLineInnerView *)kLineInnerView
{
    if (!_kLineInnerView) {
        _kLineInnerView = [HYKLineInnerView new];
        _kLineInnerView.delegate = self;
        [self.scrollView addSubview:_kLineInnerView];
        WS(weakSelf);
        [_kLineInnerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(weakSelf.scrollView);
            make.height.equalTo(weakSelf.scrollView);
            make.width.equalTo(@0);
        }];
    }
    return _kLineInnerView;
}

#pragma mark stockModels的设置方法
-(void)setStockModels:(NSArray *)stockModels
{
    if (!stockModels) {
        return;
    }
    //根据时间进行排序
    NSArray *sortedStockModels = [stockModels sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        HYStockModel *preStockModel = (HYStockModel *)obj1;
        HYStockModel *subStockModel = (HYStockModel *)obj2;
        return [preStockModel.date compare:subStockModel.date];
    }];
    _stockModels = sortedStockModels;
    //画图
    [self private_drawKLineInnerView];
}

#pragma mark - 私有方法
#pragma mark 画KLineInnerView
-(void)private_drawKLineInnerView
{
    NSAssert(self.kLineInnerView != nil, @"画kLineInnerView之前，kLineInnerView不能为空");
    self.kLineInnerView.stockModels = self.stockModels;
    [self.kLineInnerView drawInnerView];
}

#pragma mark - HYKLInnerView的代理方法
#pragma mark 长按时选中的HYKLineModel模型
-(void)kLineInnerViewLongPressKLineModel:(HYKLineModel *)kLineModel
{
    
}

#pragma mark HYKLInnerView的当前最大股价和最小股价
-(void)kLineInnerViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice
{
    
}

#pragma mark HYKInnerView的时间区间
-(void)kLineInnerViewCurrentTimeZone:(NSArray *)timeZone
{
    
}


@end
