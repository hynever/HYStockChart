//
//  HYKLineMAView.h
//  jimustock
//
//  Created by jimubox on 15/5/19.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

/************************MAView的模型************************/
@interface HYKLineMAModel : NSObject

@property(nonatomic,assign) CGFloat ma5Value;

@property(nonatomic,assign) CGFloat ma10Value;

@property(nonatomic,assign) CGFloat ma20Value;

@property(nonatomic,assign) CGFloat ma30Value;

+(instancetype)maModelWithMA5:(CGFloat)MA5 MA10:(CGFloat)MA10 MA20:(CGFloat)MA20 MA30:(CGFloat)MA30;

@end

/************************展示各种MA的View************************/
@interface HYKLineMAView : UIView

@property(nonatomic,strong) HYKLineMAModel *maModel;

/**
 *  创建HYKLineMAView的工厂方法
 */
+(instancetype)kLineMAView;

@end
