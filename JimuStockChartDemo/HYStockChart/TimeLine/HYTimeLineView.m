//
//  HYTimeLineView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/8.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYTimeLineView.h"
#import "HYTimeLineAboveView.h"
#import "HYTimeLineBelowView.h"
#import "Masonry.h"
#import "HYStockChartConstant.h"
#import "HYTimeLineAbovePositionModel.h"

@interface HYTimeLineView()<HYTimeLineAboveViewDelegate>

@property(nonatomic,strong) HYTimeLineAboveView *aboveView;

@property(nonatomic,strong) HYTimeLineBelowView *belowView;

@property(nonatomic,strong) UIView *timeLineContainerView;

@property(nonatomic,strong) NSArray *timeLineModels;

@end

@implementation HYTimeLineView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.aboveViewRatio = 0.7;
        self.aboveView.backgroundColor = [UIColor lightGrayColor];
        self.belowView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


#pragma mark set&get方法
#pragma mark aboveView的get方法
-(HYTimeLineAboveView *)aboveView
{
    if (!_aboveView) {
        _aboveView = [HYTimeLineAboveView new];
        _aboveView.delegate = self;
        [self.timeLineContainerView addSubview:_aboveView];
        [_aboveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.timeLineContainerView);
            make.height.equalTo(self.timeLineContainerView).multipliedBy(self.aboveViewRatio);
        }];
    }
    return _aboveView;
}

#pragma mark belowView的get方法
-(HYTimeLineBelowView *)belowView
{
    if (!_belowView) {
        _belowView = [HYTimeLineBelowView new];
        [self.timeLineContainerView addSubview:_belowView];
        [_belowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.aboveView.mas_bottom);
            make.left.right.equalTo(self.timeLineContainerView);
            make.height.equalTo(self.timeLineContainerView).multipliedBy(1-self.aboveViewRatio);
        }];
    }
    return _belowView;
}

#pragma mark timeLineContainerView的get方法
-(UIView *)timeLineContainerView
{
    if (!_timeLineContainerView) {
        _timeLineContainerView = [UIView new];
        [self addAllEvent];
        [self addSubview:_timeLineContainerView];
        [_timeLineContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.right.equalTo(self);
            make.height.equalTo(self);
        }];
    }
    return _timeLineContainerView;
}

#pragma mark - 模型设置方法
#pragma mark aboveViewRatio设置方法
-(void)setAboveViewRatio:(CGFloat)aboveViewRatio
{
    _aboveViewRatio = aboveViewRatio;
    [_aboveView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self).multipliedBy(_aboveViewRatio);
    }];
    [_belowView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self).multipliedBy(1-_aboveViewRatio);
    }];
}

#pragma mark timeLineModels的设置方法
-(void)setTimeLineGroupModel:(HYTimeLineGroupModel *)timeLineGroupModel
{
    _timeLineGroupModel = timeLineGroupModel;
    if (timeLineGroupModel) {
        self.timeLineModels = timeLineGroupModel.timeModels;
        self.aboveView.groupModel = timeLineGroupModel;
        self.belowView.timeLineModels = self.timeLineModels;
        [self.aboveView drawAboveView];
    }
}

#pragma mark - 私有方法
-(void)addAllEvent
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(event_longPressMethod:)];
    [self.timeLineContainerView addGestureRecognizer:longPress];
}

#pragma mark - Event执行方法
#pragma mark 长按执行方法
-(void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress
{
    static UIView *verticalView = nil;
    CGPoint pressPosition = [longPress locationInView:self.aboveView];
    if (UIGestureRecognizerStateBegan == longPress.state || UIGestureRecognizerStateChanged == longPress.state) {
        if (!verticalView) {
            verticalView = [UIView new];
            verticalView.clipsToBounds = YES;
            [self.timeLineContainerView addSubview:verticalView];
            verticalView.backgroundColor = HYVerticalViewColor;
            [verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.width.equalTo(@1);
                make.height.equalTo(self.mas_height);
                make.left.equalTo(@0);
            }];
        }
        //改变竖线的位置
        CGFloat xPosition = [self.aboveView getRightXPositionWithOriginXPosition:pressPosition.x];
        [verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(xPosition));
        }];
        [verticalView layoutIfNeeded];
        verticalView.hidden = NO;
    }else{
        if (verticalView) {
            verticalView.hidden = YES;
        }
    }
}

#pragma mark - HYTimeLineAboveViewDelegate代理方法
-(void)timeLineAboveView:(UIView *)timeLineAboveView positionModels:(NSArray *)positionModels
{
    NSMutableArray *xPositionArr = [NSMutableArray array];
    for (HYTimeLineAbovePositionModel *positionModel in positionModels) {
        [xPositionArr addObject:[NSNumber numberWithFloat:positionModel.currentPoint.x]];
    }
    self.belowView.xPositionArray = xPositionArr;
    [self.belowView drawBelowView];
}
@end
