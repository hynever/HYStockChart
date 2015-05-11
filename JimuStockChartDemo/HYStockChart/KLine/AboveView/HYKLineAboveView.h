//
//  HYKLineView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYKLinePositionModel.h"

@protocol HYKLineAboveViewDelegate;

/************************上面的图(K线/折线)************************/
@interface HYKLineAboveView : UIView

/**
 *  股票模型数组
 */
@property(nonatomic,strong) NSArray *kLineModels;

/**
 *  父view，该父view为UIScrollView
 */
@property(nonatomic,weak,readonly) UIScrollView *scrollView;

/**
 *  代理
 */
@property(nonatomic,weak) id<HYKLineAboveViewDelegate> delegate;

/**
 *  需要绘制的K线位置模型数组
 */
//@property(nonatomic,strong,readonly) NSMutableArray *needDrawKLinePositionModels;

/**
 *  需要绘制的K线模型数组
 */
//@property(nonatomic,strong,readonly) NSMutableArray *needDrawKLineModels;


/**
 *  画AboveView上的所有图
 */
-(void)drawAboveView;

/**
 *  更新AboveView的宽度
 */
-(void)updateAboveViewWidth;

/**
 *  长按的时候根据原始的x的位置获得精确的X的位置
 */
-(CGFloat)getRightXPositionWithOriginXPosition:(CGFloat)originXPosition;


@end



/************************HYKLineAboveView的代理方法************************/
@protocol HYKLineAboveViewDelegate <NSObject>

@optional
/**
 *  长按后展示手指按着的HYKLinePositionModel
 */
-(void)kLineAboveViewLongPressKLineModel:(HYKLinePositionModel *)kLineModel;

/**
 *  当前AboveView中的最大股价和最小股价
 */
-(void)kLineAboveViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice;

/**
 *  当前需要绘制的K线模型数组
 */
-(void)kLineAboveViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels;

/**
 *  当前需要绘制的K线位置模型数组
 */
-(void)kLineAboveViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels;

/**
 *  当前需要绘制的K线的颜色数组
 */
-(void)kLineAboveViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors;

@end
