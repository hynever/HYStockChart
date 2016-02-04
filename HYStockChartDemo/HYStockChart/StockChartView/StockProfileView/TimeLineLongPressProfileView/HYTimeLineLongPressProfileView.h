//
//  HYTimeLineLongPressProfileView.h
//  jimustock
//
//  Created by jimubox on 15/6/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYTimeLineModel;
/************************分时线长按的简介view************************/
@interface HYTimeLineLongPressProfileView : UIView

+(instancetype)timeLineLongPressProfileView;

@property(nonatomic,strong) HYTimeLineModel *timeLineModel;

@end
