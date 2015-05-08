//
//  HYKLineView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYKLineView.h"
#import "Masonry.h"
#import "HYStockChartConstant.h"
#import "HYKLineAboveView.h"
#import "HYKLineModel.h"
#import "HYKLineBelowView.h"
#import "HYStockChartGloablVariable.h"

@interface HYKLineView ()<UIScrollViewDelegate,HYKLineAboveViewDelegate>

@property(nonatomic,strong) UIView *priceView;

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) HYKLineAboveView *kLineAboveView;

@property(nonatomic,strong) HYKLineBelowView *kLineBelowView;

@end

@implementation HYKLineView

#pragma mark initWithFrame方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.priceView.backgroundColor = [UIColor redColor];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.aboveViewRatio = 0.7;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(event_deviceOrientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark - get&set方法
#pragma mark YView的get方法
-(UIView *)priceView
{
    _priceView = [UIView new];
    [self addSubview:_priceView];
    [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(@(HYStockChartKLinePriceViewWidth));
    }];
    return _priceView;
}

#pragma mark UIScrollView的get方法
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.maximumZoomScale = 1.0f;
        _scrollView.alwaysBounceHorizontal = YES;
        //缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(event_pinchMethod:)];
        [_scrollView addGestureRecognizer:pinchGesture];
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(event_longPressMethod:)];
        [_scrollView addGestureRecognizer:longPressGesture];
        [self addSubview:_scrollView];
        WS(weakSelf);
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf.priceView.mas_right);
            make.right.equalTo(weakSelf.mas_right);
            make.bottom.equalTo(weakSelf.priceView.mas_bottom);
        }];
    }
    return _scrollView;
}

#pragma mark kLineAboveView的get方法
-(HYKLineAboveView *)kLineAboveView
{
    if (!_kLineAboveView) {
        _kLineAboveView = [HYKLineAboveView new];
        _kLineAboveView.delegate = self;
        [self.scrollView addSubview:_kLineAboveView];
        [_kLineAboveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView.mas_height).multipliedBy(self.aboveViewRatio);
            make.width.equalTo(@0);
        }];
    }
    return _kLineAboveView;
}

#pragma mark kLineBelowView的get方法
-(HYKLineBelowView *)kLineBelowView
{
    if (!_kLineBelowView) {
        _kLineBelowView = [HYKLineBelowView new];
        [self.scrollView addSubview:_kLineBelowView];
        [_kLineBelowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.kLineAboveView);
            make.top.equalTo(self.kLineAboveView.mas_bottom);
            make.width.equalTo(self.kLineAboveView.mas_width);
            make.height.equalTo(self.scrollView.mas_height).multipliedBy((1-self.aboveViewRatio));
        }];
    }
    return _kLineBelowView;
}

#pragma mark kLineModels的设置方法
-(void)setKLineModels:(NSArray *)kLineModels
{
    if (!kLineModels) {
        return;
    }
    //根据时间进行排序
    NSArray *sortedKLineModels = [kLineModels sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        HYKLineModel *preKLineModel = (HYKLineModel *)obj1;
        HYKLineModel *subKLineModel = (HYKLineModel *)obj2;
        return [preKLineModel.date compare:subKLineModel.date];
    }];
    _kLineModels = sortedKLineModels;
    //画图
    [self private_drawKLineAboveView];
}

#pragma mark - 事件处理方法
#pragma mark 缩放执行的方法
-(void)event_pinchMethod:(UIPinchGestureRecognizer *)pinch
{
    static CGFloat oldScale = 1.0f;
    CGFloat difValue = pinch.scale - oldScale;
    if (ABS(difValue) > HYStockChartScaleBound) {
        CGFloat oldKLineWidth = [HYStockChartGloablVariable kLineWidth];
        [HYStockChartGloablVariable setkLineWith:oldKLineWidth*(difValue>0?(1+HYStockChartScaleFactor):(1-HYStockChartScaleFactor))];
        oldScale = pinch.scale;
        //更新AboveView的宽度
        [self.kLineAboveView updateAboveViewWidth];
        [self.kLineAboveView drawAboveView];
    }
}

#pragma mark 长按手势执行方法
-(void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress
{
    static UIView *verticalView = nil;
    static CGFloat oldPositionX = 0;
    if (UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        CGPoint location = [longPress locationInView:self.scrollView];
        if (ABS(oldPositionX - location.x) < ([HYStockChartGloablVariable kLineWidth]+[HYStockChartGloablVariable kLineGap])/2) {
            return;
        }
        //让scrollView的scrollEnabled不可用
        self.scrollView.scrollEnabled = NO;
        oldPositionX = location.x;
        //初始化竖线
        if (!verticalView) {
            verticalView = [UIView new];
            verticalView.clipsToBounds = YES;
            [self.scrollView addSubview:verticalView];
            verticalView.backgroundColor = [UIColor blackColor];
            [verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.width.equalTo(@1);
                make.height.equalTo(self.scrollView.mas_height);
                make.left.equalTo(@0);
            }];
        }
        //更改竖线的位置
        CGFloat rightXPosition = [self.kLineAboveView getRightXPositionWithOriginXPosition:location.x];
        [verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(rightXPosition));
        }];
        [verticalView layoutIfNeeded];
        verticalView.hidden = NO;
    }
    if (UIGestureRecognizerStateEnded == longPress.state) {
        //取消竖线
        if (verticalView) {
            verticalView.hidden = YES;
        }
        oldPositionX = 0;
        //让scrollView的scrollEnabled可用
        self.scrollView.scrollEnabled = YES;
    }
}

#pragma mark 屏幕旋转执行的方法
-(void)event_deviceOrientationDidChanged:(NSNotification *)noti
{
    if (_kLineBelowView && _kLineAboveView && self.kLineModels) {
        [self private_drawKLineAboveView];
    }
}


#pragma mark - 私有方法
#pragma mark 画KLineAboveView
-(void)private_drawKLineAboveView
{
    NSAssert(self.kLineAboveView != nil, @"画kLineAboveView之前，kLineAboveView不能为空");
    self.kLineAboveView.kLineModels = self.kLineModels;
    [self.kLineAboveView updateAboveViewWidth];
    [self.kLineAboveView drawAboveView];
}

#pragma mark 画KLineBelowView
-(void)private_drawKLineBelowView
{
    NSAssert(self.kLineBelowView != nil, @"画kLineBelowView之前，kLineBelowView不能为空");
    //因为belowView的宽度和aboveView的宽度是一致的，所以只需要更新约束就可以了
    [self.kLineBelowView layoutIfNeeded];
    [self.kLineBelowView drawBelowView];
}

#pragma mark - HYKLAboveView的代理方法
#pragma mark 长按时选中的HYKLinePositionModel模型
-(void)kLineAboveViewLongPressKLineModel:(HYKLinePositionModel *)kLineModel
{
    
}

#pragma mark HYKLAboveView的当前最大股价和最小股价
-(void)kLineAboveViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice
{
    //更新价格坐标轴
    
}

-(void)kLineAboveViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels
{
    self.kLineBelowView.needDrawKLineModels = needDrawKLineModels;
}

-(void)kLineAboveViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels
{
    self.kLineBelowView.needDrawKLinePositionModels = needDrawKLinePositionModels;
}

-(void)kLineAboveViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors
{
    self.kLineBelowView.kLineColors = kLineColors;
    [self private_drawKLineBelowView];
}

@end
