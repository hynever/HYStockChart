//
//  HYStockChartSegmentView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/13.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYStockChartSegmentView.h"
#import "Masonry.h"

@interface HYStockChartSegmentView ()


@end

@implementation HYStockChartSegmentView

#pragma mark - 初始化方法
#pragma mark 通过items创建SegmentView
-(instancetype)initWithItems:(NSArray *)items
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.items = items;
    }
    return self;
}

#pragma mark - set方法
#pragma mark items的set方法
-(void)setItems:(NSArray *)items
{
    _items = items;
    if (items.count == 0 || !items) {
        return;
    }
    NSInteger index = 0;
    NSInteger count = items.count;
    UIButton *preBtn = nil;
    for (NSString *title in items) {
        UIButton *btn = [self private_createButtonWithTitle:title tag:index];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.height.equalTo(@50);
            make.width.equalTo(self).multipliedBy(1.0f/count);
            if (preBtn) {
                make.left.equalTo(preBtn.mas_right);
            }else{
                make.left.equalTo(self);
            }
        }];
        preBtn = btn;
        index++;
    }
}

#pragma mark - 私有方法
#pragma mark 根据title创建一个button
-(UIButton *)private_createButtonWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(event_segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    return btn;
}

#pragma mark - 事件执行方法
-(void)event_segmentButtonClicked:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hyStockChartSegmentView:clickSegmentButtonIndex:)]) {
        [self.delegate hyStockChartSegmentView:self clickSegmentButtonIndex:btn.tag];
    }
}


@end
