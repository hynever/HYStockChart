//
//  HYStockChartView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.

//  Date,Open,High,Low,Close,Volume,Adj Close

#import "HYStockChartView.h"
#import "HYKLine.h"
#import "HYKLineModel.h"
#import "Masonry.h"
#import "HYTimeLineView.h"
#import "HYKLineView.h"
#import "HYStockChartSegmentView.h"
#import "HYTimeLineGroupModel.h"
#import "HYStoctDefaultProfileView.h"
#import "MJExtension.h"
#import "HYStockChartGloablVariable.h"
#import "HYStockChartProfileModel.h"
#import "HYStockChartConstant.h"

@interface HYStockChartView ()<HYStockChartSegmentViewDelegate>

@property(nonatomic,strong) HYStoctDefaultProfileView *stockDefaultProfileView;

@property(nonatomic,strong) HYStockChartSegmentView *segmentView;

@property(nonatomic,strong) UILabel *companyNameLabel;

@property(nonatomic,strong) HYTimeLineView *timeLineView;   //分时线view

@property(nonatomic,strong) HYKLineView *kLineView;         //K线view

@property(nonatomic,strong) HYTimeLineView *brokenLineView; //折线view

@property(nonatomic,assign) HYStockChartCenterViewType currentCenterViewType;

@property(nonatomic,assign,readwrite) NSInteger currentIndex;

@end

@implementation HYStockChartView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

#pragma mark topView的get方法
-(HYStoctDefaultProfileView *)stockDefaultProfileView
{
    if (!_stockDefaultProfileView) {
        _stockDefaultProfileView = [HYStoctDefaultProfileView profileView];
        [self addSubview:_stockDefaultProfileView];
        [_stockDefaultProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@(HYStockChartProfileViewHeight));
        }];
    }
    return _stockDefaultProfileView;
}

#pragma mark segmentView的get方法
-(HYStockChartSegmentView *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[HYStockChartSegmentView alloc] init];
        _segmentView.delegate = self;
        [self addSubview:_segmentView];
        [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.equalTo(self);
            make.width.equalTo(self).multipliedBy(0.9);
            make.height.equalTo(@35);
        }];
    }
    return _segmentView;
}

#pragma mark kLineView的get方法
-(HYKLineView *)kLineView
{
    if (!_kLineView) {
        _kLineView = [HYKLineView new];
        [self addSubview:_kLineView];
        [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.stockDefaultProfileView.mas_bottom);
            make.bottom.equalTo(self.segmentView.mas_top);
        }];
    }
    return _kLineView;
}

#pragma mark timeLineView的get方法
-(HYTimeLineView *)timeLineView
{
    if (!_timeLineView) {
        _timeLineView = [HYTimeLineView new];
        _timeLineView.centerViewType = HYStockChartCenterViewTypeTimeLine;
        [self insertSubview:_timeLineView aboveSubview:self.stockDefaultProfileView];
        [_timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.stockDefaultProfileView.mas_bottom);
            make.bottom.equalTo(self.segmentView.mas_top);
        }];
    }
    return _timeLineView;
}

#pragma mark brokenLineView的get方法
-(HYTimeLineView *)brokenLineView
{
    if (!_brokenLineView) {
        _brokenLineView = [HYTimeLineView new];
        _brokenLineView.centerViewType = HYStockChartCenterViewTypeBrokenLine;
        [self insertSubview:_brokenLineView aboveSubview:self.stockDefaultProfileView];
        [_brokenLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.stockDefaultProfileView.mas_bottom);
            make.bottom.equalTo(self.segmentView.mas_top);
        }];
    }
    return _brokenLineView;
}

#pragma mark - set方法
#pragma mark items的set方法
-(void)setItemModels:(NSArray *)itemModels
{
    _itemModels = itemModels;
    if (itemModels) {
        NSMutableArray *items = [NSMutableArray array];
        for (HYStockChartViewItemModel *item in itemModels) {
            [items addObject:item.title];
        }
        self.segmentView.items = items;
        HYStockChartViewItemModel *firstModel = [itemModels firstObject];
        self.currentCenterViewType = firstModel.centerViewType;
    }
    if (self.dataSource) {
        self.segmentView.selectedIndex = 0;
    }
}

#pragma mark 设置股票简介模型
-(void)setStockChartProfileModel:(HYStockChartProfileModel *)stockChartProfileModel
{
    _stockChartProfileModel = stockChartProfileModel;
    [HYStockChartGloablVariable setStockChineseName:stockChartProfileModel.ChineseName.length > 0 ? stockChartProfileModel.ChineseName : stockChartProfileModel.Name];
    [HYStockChartGloablVariable setStockSymbol:stockChartProfileModel.Symbol];
    [HYStockChartGloablVariable setStockType:stockChartProfileModel.stockType];
    self.stockDefaultProfileView.profileModel = stockChartProfileModel;
}

#pragma mark dataSource的设置方法
-(void)setDataSource:(id<HYStockChartViewDataSource>)dataSource
{
    _dataSource = dataSource;
    if (self.itemModels) {
        self.segmentView.selectedIndex = 0;
    }
}

/**
 *  重新加载数据
 */
-(void)reloadData
{
    self.segmentView.selectedIndex = self.segmentView.selectedIndex;
}

#pragma mark HYStockChartSegmentViewDelegate代理方法
-(void)hyStockChartSegmentView:(HYStockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index
{
    self.currentIndex = index;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)]) {
        id stockData = [self.dataSource stockDatasWithIndex:index];
        
        if (!stockData) {
            return;
        }
        
        HYStockChartViewItemModel *itemModel = self.itemModels[index];
        HYStockChartCenterViewType type = itemModel.centerViewType;
        if (type != self.currentCenterViewType) {
            //移除原来的view，设置新的view
            self.currentCenterViewType = type;
            if (type == HYStockChartCenterViewTypeKLine) {
                self.kLineView.hidden = NO;
                self.brokenLineView.hidden = YES;
                self.timeLineView.hidden = YES;
                [self bringSubviewToFront:self.kLineView];
            }else if(HYStockChartCenterViewTypeTimeLine == type){
                self.timeLineView.hidden = NO;
                self.kLineView.hidden = YES;
                self.brokenLineView.hidden = YES;
            }else{
                self.brokenLineView.hidden = NO;
                self.kLineView.hidden = YES;
                self.timeLineView.hidden = YES;
            }
        }

        if (type == HYStockChartCenterViewTypeTimeLine ||
            HYStockChartCenterViewTypeBrokenLine == type) {
            NSAssert([stockData isKindOfClass:[HYTimeLineGroupModel class]], @"数据必须是HYTimeLineGroupModel类型!!!");
            HYTimeLineGroupModel *groupTimeLineModel = (HYTimeLineGroupModel *)stockData;
            if (type == HYStockChartCenterViewTypeTimeLine) {
                self.timeLineView.timeLineGroupModel = groupTimeLineModel;
                [self.timeLineView reDraw];
            }else{
                self.brokenLineView.timeLineGroupModel = groupTimeLineModel;
                [self.brokenLineView reDraw];
            }
        }else{
            NSArray *stockDataArray = (NSArray *)stockData;
            self.kLineView.kLineModels = stockDataArray;
            [self.kLineView reDraw];
        }
    }
}

@end


/************************ItemModel类************************/
@implementation HYStockChartViewItemModel
+(instancetype)itemModelWithTitle:(NSString *)title type:(HYStockChartCenterViewType)type
{
    HYStockChartViewItemModel *itemModel = [[HYStockChartViewItemModel alloc] init];
    itemModel.title = title;
    itemModel.centerViewType = type;
    return itemModel;
}
@end