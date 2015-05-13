//
//  HYTimeLineView.h
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTimeLineGroupModel.h"

@interface HYTimeLineView : UIView

@property(nonatomic,strong) HYTimeLineGroupModel *timeLineGroupModel;

@property(nonatomic,assign) CGFloat aboveViewRatio;

@property(nonatomic,assign) BOOL isNeedDrawTime;

@end
