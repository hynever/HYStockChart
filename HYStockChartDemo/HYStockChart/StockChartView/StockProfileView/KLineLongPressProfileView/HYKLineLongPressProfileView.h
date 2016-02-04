//
//  HYKLineLongPressProfileView.h
//  jimustock
//
//  Created by jimubox on 15/6/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYKLineModel;
/************************K线长按的简介view************************/
@interface HYKLineLongPressProfileView : UIView

@property(nonatomic,strong) HYKLineModel *kLineModel;

/**
 *  工厂方法加载一个HYKLineLongPressProfileViewxib
 */
+(instancetype)kLineLongPressProfileView;

@end
