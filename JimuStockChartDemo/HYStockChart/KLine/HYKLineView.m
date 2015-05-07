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
#import "HYKLineAboveView.h"
#import "HYStockModel.h"
#import "HYKLineBelowView.h"

@interface HYKLineView ()<UIScrollViewDelegate,HYKLineAboveViewDelegate>

@property(nonatomic,strong) UIView *priceView;

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) HYKLineAboveView *kLineAboveView;

@property(nonatomic,strong) HYKLineBelowView *kLineBelowView;

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
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.aboveViewRatio = 0.7;
        self.kLineBelowView.backgroundColor = [UIColor yellowColor];
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

#pragma mark UIScrollView的get方法
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.alwaysBounceHorizontal = YES;
        [self addSubview:_scrollView];
        WS(weakSelf);
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf.priceView.mas_right);
            make.right.equalTo(weakSelf.mas_right);
            make.bottom.equalTo(weakSelf.priceView.mas_bottom);
        }];
    }
    return _scrollView;
}

#pragma mark kLineAboveView的get方法
-(HYKLineAboveView *)kLineAboveView
{
    if (!_kLineAboveView) {
        _kLineAboveView = [HYKLineAboveView new];
        _kLineAboveView.delegate = self;
        [self.scrollView addSubview:_kLineAboveView];
        [_kLineAboveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView.mas_height).multipliedBy(self.aboveViewRatio);
            make.width.equalTo(@0);
        }];
    }
    return _kLineAboveView;
}

#pragma mark kLineBelowView的get方法
-(HYKLineBelowView *)kLineBelowView
{
    if (!_kLineBelowView) {
        _kLineBelowView = [HYKLineBelowView new];
        [self.scrollView addSubview:_kLineBelowView];
        [_kLineBelowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.kLineAboveView);
            make.top.equalTo(self.kLineAboveView.mas_bottom);
            make.width.equalTo(self.kLineAboveView.mas_width);
            make.height.equalTo(self.scrollView.mas_height).multipliedBy((1-self.aboveViewRatio));
        }];
    }
    return _kLineBelowView;
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
    [self private_drawKLineAboveView];
}

#pragma mark - 私有方法
#pragma mark 画KLineAboveView
-(void)private_drawKLineAboveView
{
    NSAssert(self.kLineAboveView != nil, @"画kLineAboveView之前，kLineAboveView不能为空");
    self.kLineAboveView.stockModels = self.stockModels;
    [self.kLineAboveView drawAboveView];
}

#pragma mark - HYKLAboveView的代理方法
#pragma mark 长按时选中的HYKLineModel模型
-(void)kLineAboveViewLongPressKLineModel:(HYKLineModel *)kLineModel
{
    
}

#pragma mark HYKLAboveView的当前最大股价和最小股价
-(void)kLineAboveViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice
{
    //更新价格坐标轴
    
}

#pragma mark HYKAboveView的时间区间
-(void)kLineAboveViewCurrentTimeZone:(NSArray *)timeZone
{
    
}


@end
