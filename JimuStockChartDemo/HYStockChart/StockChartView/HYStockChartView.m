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

@interface HYStockChartView ()<HYStockChartSegmentViewDelegate>

@property(nonatomic,strong) UIView *topView;

@property(nonatomic,strong) HYStockChartSegmentView *segmentView;

@property(nonatomic,strong) UILabel *companyNameLabel;

@property(nonatomic,strong) HYTimeLineView *timeLineView;

@property(nonatomic,strong) HYKLineView *kLineView;

@property(nonatomic,assign) HYStockChartCenterViewType currentCenterViewType;

@end

@implementation HYStockChartView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark topView的get方法
-(UIView *)topView
{
    if (!_topView) {
        _topView = [UIView new];
        [self addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@50);
        }];
    }
    return _topView;
}

#pragma mark segmentView的get方法
-(HYStockChartSegmentView *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[HYStockChartSegmentView alloc] init];
        _segmentView.delegate = self;
        [self addSubview:_segmentView];
        [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@50);
        }];
    }
    return _segmentView;
}

#pragma mark timeLineView的get方法
-(HYTimeLineView *)timeLineView
{
    if (!_timeLineView) {
        _timeLineView = [HYTimeLineView new];
        [self addSubview:_timeLineView];
        [_timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.topView.mas_bottom);
            make.bottom.equalTo(self.segmentView.mas_top);
        }];
    }
    return _timeLineView;
}

#pragma mark kLineView的get方法
-(HYKLineView *)kLineView
{
    if (!_kLineView) {
        _kLineView = [HYKLineView new];
        [self addSubview:_kLineView];
        [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.topView.mas_bottom);
            make.bottom.equalTo(self.segmentView.mas_top);
        }];
    }
    return _kLineView;
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
}


/**
 *  重新加载数据
 */
-(void)reloadData
{
}

#pragma mark HYStockChartSegmentViewDelegate代理方法
-(void)hyStockChartSegmentView:(HYStockChartSegmentView *)segmentView clickSegmentButtonIndex:(NSInteger)index
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(stockDatasWithIndex:)]) {
        NSArray *stockData = [self.dataSource stockDatasWithIndex:index];
        HYStockChartViewItemModel *itemModel = self.itemModels[index];
        HYStockChartCenterViewType type = itemModel.centerViewType;
        if (type != self.currentCenterViewType) {
            //移除原来的view，设置新的view
            self.currentCenterViewType = type;
            if (type == HYStockChartCenterViewTypeKLine) {
                self.timeLineView.hidden = YES;
                self.kLineView.hidden = NO;
                
            }else{
                self.timeLineView.hidden = YES;
                self.kLineView.hidden = NO;
            }
        }
        
        if (type == HYStockChartCenterViewTypeKLine) {
            self.kLineView.kLineModels = stockData;
        }else{
            self.timeLineView.timeLineGroupModel = [HYTimeLineGroupModel groupModelWithTimeModels:stockData lastDayEndPrice:0];
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