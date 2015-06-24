//
//  JMBBrokenLineLongPressProfileView.h
//  jimustock
//
//  Created by jimubox on 15/6/9.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYTimeLineModel;
/************************折线长按的profileView************************/
@interface HYBrokenLineLongPressProfileView : UIView

@property(nonatomic,strong) HYTimeLineModel *timeLineModel;

/**
 *  工厂方法创建一个折线的详情view
 */
+(instancetype)brokenLineLongPressProfileView;

@end
