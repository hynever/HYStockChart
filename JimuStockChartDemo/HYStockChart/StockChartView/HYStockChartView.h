//
//  HYStockChartView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HYStockChartCenterViewType){
    HYStockChartCenterViewTypeKLine = 1,
    HYStockChartCenterViewTypeTimeLine
};

/************************ItemModel类************************/
@interface HYStockChartViewItemModel : NSObject
@property(nonatomic,copy) NSString *title;
@property(nonatomic,assign) HYStockChartCenterViewType centerViewType;
+(instancetype)itemModelWithTitle:(NSString *)title type:(HYStockChartCenterViewType)type;
@end


@protocol HYStockChartViewDataSource;
/************************展示K线、成交量、趋势图、各种数据的最终的View************************/
@interface HYStockChartView : UIView

@property(nonatomic,strong) NSArray *itemModels;

/**
 *  Y坐标轴上最大的值
 */
@property(nonatomic,assign,readonly) CGFloat maxYValue;

/**
 *  Y坐标轴上最小的值
 */
@property(nonatomic,assign,readonly) CGFloat minYValue;

@property(nonatomic,weak) id<HYStockChartViewDataSource> dataSource;

/**
 *  重新加载数据
 */
-(void)reloadData;

@end


/************************代理************************/
@protocol HYStockChartViewDelegate <NSObject>
@end

/************************数据源************************/
@protocol HYStockChartViewDataSource <NSObject>

@required
/**
 *  某个index指定的数据
 */
-(NSArray *)stockDatasWithIndex:(NSInteger)index;

@end
