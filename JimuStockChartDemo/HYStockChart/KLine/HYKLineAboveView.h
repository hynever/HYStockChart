//
//  HYKLineView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYKLineModel.h"

@protocol HYKLineAboveViewDelegate;

/************************上面的图(K线/折线)************************/
@interface HYKLineAboveView : UIView

/**
 *  股票模型数组
 */
@property(nonatomic,strong) NSArray *stockModels;

/**
 *  父view，该父view为UIScrollView
 */
@property(nonatomic,weak,readonly) UIScrollView *scrollView;

/**
 *  代理
 */
@property(nonatomic,weak) id<HYKLineAboveViewDelegate> delegate;


/**
 *  画AboveView上的所有图
 */
-(void)drawAboveView;

/**
 *  更新AboveView的宽度
 */
-(void)updateAboveViewWidth;

/**
 *  根据原始的x的位置获得精确的X的位置
 */
-(CGFloat)getRightXPositionWithOriginXPosition:(CGFloat)originXPosition;


@end



/************************HYKLineAboveView的代理方法************************/
@protocol HYKLineAboveViewDelegate <NSObject>

@optional
/**
 *  长按后展示手指按着的HYKLineModel
 */
-(void)kLineAboveViewLongPressKLineModel:(HYKLineModel *)kLineModel;

/**
 *  当前AboveView中的最大股价和最小股价
 */
-(void)kLineAboveViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice;

/**
 *  需要展示的kLineModel的模型数组
 */
-(void)kLineAboveViewNeedDrawKLineModels:(NSArray *)kLineModels;

@end
