//
//  HYKLineDetailView.h
//  jimustock
//
//  Created by jimubox on 15/5/25.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYKLineModel;
/************************某根K线的详细信息的View************************/
@interface HYKLineDetailView : UIView

@property(nonatomic,strong) HYKLineModel *kLineModel;

@end
