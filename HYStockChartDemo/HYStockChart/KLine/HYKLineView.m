//
//  HYKLineView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYKLineView.h"
#import "HYStockChartConstant.h"
#import "HYKLineAboveView.h"
#import "HYKLineModel.h"
#import "HYKLineBelowView.h"
#import "HYStockChartGloablVariable.h"
#import "HYKLineMAView.h"
#import "HYStockChartYView.h"
#import "UIColor+HYStockChart.h"
#import "HYKLineLongPressProfileView.h"
#import "Masonry.h"
#import "UIFont+HYStockChart.h"

@interface HYKLineView ()<UIScrollViewDelegate,HYKLineAboveViewDelegate,HYKLineBelowViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) HYKLineAboveView *kLineAboveView;

@property(nonatomic,strong) HYKLineBelowView *kLineBelowView;

@property(nonatomic,strong) HYKLineMAView *maView;

@property(nonatomic,strong) HYStockChartYView *priceView;

@property(nonatomic,strong) HYStockChartYView *volumeView;

@property(nonatomic,strong) HYKLineLongPressProfileView *longPressProfileView;

@property(nonatomic,assign) CGFloat oldRightOffset;

@property(nonatomic,strong) UIView *verticalView;

@property(nonatomic,strong) UILabel *volumeLabel;   //在左下角展示成交量的label

@end

@implementation HYKLineView

#pragma mark initWithFrame方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.aboveViewRatio = 0.7;
        self.oldRightOffset = -1.0f;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(event_deviceOrientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark - get&set方法
#pragma mark YView的get方法
-(HYStockChartYView *)priceView
{
    if (!_priceView) {
        _priceView = [HYStockChartYView new];
        [self insertSubview:_priceView aboveSubview:self.scrollView];
        [_priceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(self).multipliedBy(self.aboveViewRatio);
            make.width.equalTo(@(HYStockChartKLinePriceViewWidth));
        }];
    }
    return _priceView;
}

-(HYStockChartYView *)volumeView
{
    if (!_volumeView) {
        _volumeView = [HYStockChartYView new];
        _volumeView.minLabelText = @"万手";
        [self insertSubview:_volumeView aboveSubview:self.scrollView];
        [_volumeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.right.equalTo(self.priceView);
            make.width.equalTo(self.priceView);
            make.height.equalTo(self).multipliedBy(1-self.aboveViewRatio);
        }];
    }
    return _volumeView;
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
        _scrollView.delegate = self;
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
            make.right.equalTo(weakSelf);
            make.left.equalTo(weakSelf.mas_left);
            make.bottom.equalTo(weakSelf.mas_bottom);
        }];
        //现在直接更新约束，省的后面要需要scrollView的宽度
        [self layoutIfNeeded];
    }
    return _scrollView;
}

#pragma mark kLineAboveView的get方法
-(HYKLineAboveView *)kLineAboveView
{
    if (!_kLineAboveView && self) {
        _kLineAboveView = [HYKLineAboveView new];
        _kLineAboveView.delegate = self;
        [self.scrollView addSubview:_kLineAboveView];
        [_kLineAboveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView.mas_height).multipliedBy(self.aboveViewRatio);
            make.width.equalTo(@0);
        }];
    }
    self.priceView.backgroundColor = [UIColor clearColor];
    self.volumeView.backgroundColor = [UIColor clearColor];
    return _kLineAboveView;
}

#pragma mark kLineBelowView的get方法
-(HYKLineBelowView *)kLineBelowView
{
    if (!_kLineBelowView) {
        _kLineBelowView = [HYKLineBelowView new];
        _kLineBelowView.delegate = self;
        [self.scrollView addSubview:_kLineBelowView];
        [_kLineBelowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.kLineAboveView);
            make.top.equalTo(self.kLineAboveView.mas_bottom);
            make.width.equalTo(self.kLineAboveView.mas_width);
            make.height.equalTo(self.scrollView.mas_height).multipliedBy((1-self.aboveViewRatio));
        }];
        [self layoutIfNeeded];
    }
    return _kLineBelowView;
}

#pragma mark MAView的get方法
-(HYKLineMAView *)maView
{
    if (!_maView) {
        _maView = [HYKLineMAView kLineMAView];
        _maView.backgroundColor = [UIColor clearColor];
        [self addSubview:_maView];
        [_maView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
            make.height.equalTo(@10);
        }];
    }
    return _maView;
}

#pragma mark longPressProfileView的get方法
-(HYKLineLongPressProfileView *)longPressProfileView
{
    if (!_longPressProfileView) {
        _longPressProfileView = [HYKLineLongPressProfileView kLineLongPressProfileView];
        [self addSubview:_longPressProfileView];
        [_longPressProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top);
            make.left.right.equalTo(self);
            make.height.equalTo(@(HYStockChartProfileViewHeight));
        }];
    }
    return _longPressProfileView;
}

#pragma mark volumeLabel的get方法
-(UILabel *)volumeLabel
{
    if (!_volumeLabel) {
        _volumeLabel = [UILabel new];
        _volumeLabel.textColor = [UIColor assistTextColor];
        _volumeLabel.font = [UIFont f39Font];
        [self addSubview:_volumeLabel];
        [_volumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self.kLineBelowView).offset(10);
        }];
    }
    return _volumeLabel;
}

#pragma mark - set方法
#pragma mark kLineModels的设置方法
-(void)setKLineModels:(NSArray *)kLineModels
{
    if (!kLineModels) {
        return;
    }
    //根据时间进行排序，倒序
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd-yyyy";
    NSArray *sortedKLineModels = [kLineModels sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        HYKLineModel *preKLineModel = (HYKLineModel *)obj1;
        HYKLineModel *subKLineModel = (HYKLineModel *)obj2;
        NSDate *preDate = [formatter dateFromString:preKLineModel.date];
        NSDate *subDate = [formatter dateFromString:subKLineModel.date];
        return [preDate compare:subDate];
    }];
    
    _kLineModels = sortedKLineModels;
    
    //找出所有自然月的第一个交易日
    [self private_findFirstTradeDateWithModels:sortedKLineModels];
    
    //画图
    [self private_drawKLineAboveView];
    //设置contentOffset
    CGFloat contentOffsetX = self.oldRightOffset < 0 ? self.kLineAboveView.frame.size.width-self.scrollView.frame.size.width : self.kLineAboveView.frame.size.width - self.oldRightOffset;
    [self.scrollView setContentOffset:CGPointMake(contentOffsetX, 0)];
    HYKLineModel *lastModel = [sortedKLineModels lastObject];
    self.maView.maModel = [HYKLineMAModel maModelWithMA5:lastModel.MA5 MA10:lastModel.MA10 MA20:lastModel.MA20 MA30:lastModel.MA30];
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
        if (!self.verticalView) {
            self.verticalView = [UIView new];
            self.verticalView.clipsToBounds = YES;
            [self.scrollView addSubview:self.verticalView];
            self.verticalView.backgroundColor = [UIColor longPressLineColor];
            [self.verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.width.equalTo(@(HYStockChartLongPressVerticalViewWidth));
                make.height.equalTo(self.scrollView.mas_height);
                make.left.equalTo(@(-10));
            }];
        }
        //更改竖线的位置
        CGFloat rightXPosition = [self.kLineAboveView getRightXPositionWithOriginXPosition:location.x];
        [self.verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(rightXPosition));
        }];
        [self.verticalView layoutIfNeeded];
        self.verticalView.hidden = NO;
    }
    if (UIGestureRecognizerStateEnded == longPress.state) {
        //取消竖线
        if (self.verticalView) {
            self.verticalView.hidden = YES;
        }
        oldPositionX = 0;
        //让scrollView的scrollEnabled可用
        self.scrollView.scrollEnabled = YES;
        self.longPressProfileView.hidden = YES;
        self.volumeLabel.hidden = YES;
        HYKLineModel *lastModel = [self.kLineModels lastObject];
        self.maView.maModel = [HYKLineMAModel maModelWithMA5:lastModel.MA5 MA10:lastModel.MA10 MA20:lastModel.MA20 MA30:lastModel.MA30];
    }
}

#pragma mark 屏幕旋转执行的方法
-(void)event_deviceOrientationDidChanged:(NSNotification *)noti
{
    if (_kLineBelowView && _kLineAboveView && self.kLineModels) {
        [self private_drawKLineAboveView];
    }
}

#pragma mark - 公有方法
#pragma mark 指定颜色清除KLineView
-(void)clearRectWithColor:(UIColor *)bgColor
{
    
}

#pragma mark 重绘
-(void)reDraw
{
    [self.kLineAboveView drawAboveView];
}

#pragma mark - 私有方法
#pragma mark 画KLineAboveView
-(void)private_drawKLineAboveView
{
    NSAssert(self.kLineAboveView != nil, @"画kLineAboveView之前，kLineAboveView不能为空");
    self.kLineAboveView.kLineModels = self.kLineModels;
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

#pragma mark 找出某个月的第一个交易日
-(void)private_findFirstTradeDateWithModels:(NSArray *)sortedKLineModels;
{
    __block HYKLineModel *comparingModel = [sortedKLineModels firstObject];
    comparingModel.isFirstTradeDate = YES;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM/dd/yyyy";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [sortedKLineModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HYKLineModel *kLineModel = (HYKLineModel *)obj;
        NSDate *compaingDate = [formatter dateFromString:comparingModel.date];
        NSDate *objDate = [formatter dateFromString:kLineModel.date];
        NSDateComponents *compingComponent = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:compaingDate];
        NSDateComponents *objComponent = [calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:objDate];
        if (compingComponent.month != objComponent.month || compingComponent.year != objComponent.year) {
            kLineModel.isFirstTradeDate = YES;
            comparingModel = kLineModel;
        }
    }];
}

#pragma mark - HYKLAboveView的代理方法
#pragma mark 长按时选中的HYKLinePositionModel模型
-(void)kLineAboveViewLongPressKLinePositionModel:(HYKLinePositionModel *)kLinePositionModel kLineModel:(HYKLineModel *)kLineModel
{
    //更新选择的kLineModel信息
    self.longPressProfileView.kLineModel = kLineModel;
    self.longPressProfileView.hidden = NO;
    self.volumeLabel.text = [NSString stringWithFormat:@"成交量：%.f",kLineModel.volume];
    self.volumeLabel.hidden = NO;
    self.maView.maModel = [HYKLineMAModel maModelWithMA5:kLineModel.MA5 MA10:kLineModel.MA10 MA20:kLineModel.MA20 MA30:kLineModel.MA30];
}
#pragma mark HYKLAboveView的当前最大股价和最小股价
-(void)kLineAboveViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice
{
    //更新价格坐标轴
    self.priceView.maxValue = maxPrice;
    self.priceView.minValue = minPrice;
    self.priceView.middleValue = (maxPrice-minPrice)/2+minPrice;
}
-(void)kLineAboveViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels
{
//    static NSInteger minCount = CGFLOAT_MAX;
//    static NSInteger maxCount = 0;
    self.kLineBelowView.needDrawKLineModels = needDrawKLineModels;
//    if (needDrawKLineModels.count < minCount) {
//        minCount = needDrawKLineModels.count;
//        NSLog(@"min:%ld,",minCount);
//    }
//    if (needDrawKLineModels.count > maxCount) {
//        maxCount = needDrawKLineModels.count;
//        NSLog(@"max:%ld\n",maxCount);
//    }
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


#pragma mark - HYKLineBelowView的代理方法
-(void)kLineBelowViewCurrentMaxVolume:(CGFloat)maxVolume minVolume:(CGFloat)minVolume
{
    self.volumeView.maxValue = maxVolume/10000.0f;
}

#pragma mark - UIScrollView的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static BOOL isNeedPostNotification = YES;
    if (scrollView.contentOffset.x < scrollView.frame.size.width*2) {
        if (isNeedPostNotification) {
            self.oldRightOffset = scrollView.contentSize.width - scrollView.contentOffset.x;
            isNeedPostNotification = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:HYStockChartKLineNeedLoadMoreDataNotification object:nil];
        }
    }else{
        isNeedPostNotification = YES;
    }
}

#pragma mark - 释放资源方法
#pragma mark dealloc方法
-(void)dealloc
{
    [_kLineAboveView removeAllObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
