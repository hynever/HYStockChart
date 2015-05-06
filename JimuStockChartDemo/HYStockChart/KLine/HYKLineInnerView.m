//
//  HYKLineView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYKLineInnerView.h"
#import "HYConstant.h"
#import "HYStockModel.h"
#import "HYKLineModel.h"
#import "HYKLine.h"
#import "HYKeyValueObserver.h"
#import "Masonry.h"

static NSString * const kHYStockChartContentOffsetKey = @"contentOffset";

static CGFloat const kHYStockChartScaleBound = 0.03;
static CGFloat const kHYStockChartScaleFactor = 0.03;

@interface HYKLineInnerView ()

@property(nonatomic,strong) NSMutableArray *needDrawStockModels;

@property(nonatomic,strong) NSMutableArray *needDrawKLineModels;

@property(nonatomic,assign) NSUInteger needDrawStockStartIndex;

@property(nonatomic,assign,readonly) CGFloat startXPosition;

@property(nonatomic,assign) CGFloat oldContentOffsetX;

@property(nonatomic,assign) CGFloat oldScale;

@end

@implementation HYKLineInnerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //默认的宽度
        self.kLineWidth = 20;
        self.kLineGap = HYStockChartKLineGap;
        self.needDrawStockModels = [NSMutableArray array];
        self.needDrawKLineModels = [NSMutableArray array];
        _needDrawStockStartIndex = 0;
        self.oldContentOffsetX = 0;
        self.oldScale = 0;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 绘图相关方法
#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect {
    if (!self.stockModels) {
        return;
    }
    //先提取需要展示的stockModel
    [self private_extractNeedDrawModels];
    //将stockModel转换成坐标模型
    NSArray *kLineModels = [self private_convertToKLineModelWithStockModels:self.needDrawStockModels];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, self.bounds);
    HYKLine *kLine = [[HYKLine alloc] initWithContext:context];
    kLine.solidLineWidth = self.kLineWidth;
    NSInteger idx = 0;
    for (HYKLineModel *kLineModel in kLineModels) {
        kLine.kLineModel = kLineModel;
        kLine.stockModel = self.needDrawStockModels[idx];
        [kLine draw];
        idx++;
    }
    [super drawRect:rect];
}

#pragma mark 重新设置相关变量，然后绘图
-(void)drawInnerView
{
    if (!self.stockModels) {
        return;
    }
    //间接调用drawRect方法
    [self setNeedsDisplay];
}

#pragma mark - set&get方法
#pragma mark kLineWidth的set方法
-(void)setKLineWidth:(CGFloat)kLineWidth
{
    if (kLineWidth > HYStockChartKLineMaxWidth) {
        kLineWidth = HYStockChartKLineMaxWidth;
    }else if (kLineWidth < HYStockChartKLineMinWidth){
        kLineWidth = HYStockChartKLineMinWidth;
    }
    _kLineWidth = kLineWidth;
}

#pragma mark startXPosition的get方法
-(CGFloat)startXPosition
{
    CGFloat lineGap = self.kLineGap;
    CGFloat lineWidth = self.kLineWidth;
    NSInteger leftArrCount = self.needDrawStockStartIndex;
    CGFloat startXPosition = (leftArrCount+1)*lineGap + leftArrCount*lineWidth+lineWidth/2;
//    self.scrollView.contentOffset = CGPointMake(startXPosition, 0);
    return startXPosition;
}

#pragma mark needDrawStockStartIndex的get方法
-(NSUInteger)needDrawStockStartIndex
{
    CGFloat lineGap = self.kLineGap;
    CGFloat lineWidth = self.kLineWidth;
    CGFloat scrollViewOffsetX = self.scrollView.contentOffset.x < 0 ? 0 : self.scrollView.contentOffset.x;
    NSUInteger leftArrCount = ABS(scrollViewOffsetX - lineGap)/(lineWidth+lineGap);
    _needDrawStockStartIndex = leftArrCount;
    return _needDrawStockStartIndex;
}

#pragma mark stockModels的set方法
-(void)setStockModels:(NSArray *)stockModels
{
    _stockModels = stockModels;
    [self private_updateSelfWidth];
}


#pragma mark - 私有方法
#pragma mark 提取需要绘制的数组
-(NSArray *)private_extractNeedDrawModels
{
    CGFloat lineGap = self.kLineGap;
    CGFloat lineWidth = self.kLineWidth;
    
    //数组个数
    CGFloat scrollViewWidth = self.scrollView.frame.size.width;
    CGFloat needDrawKLineCount = (scrollViewWidth - lineGap)/(lineGap+lineWidth);
    
    //起始位置
    NSInteger needDrawKLineStartIndex = self.needDrawStockStartIndex;
    
    [self.needDrawStockModels removeAllObjects];
    if ((needDrawKLineStartIndex + needDrawKLineCount) < self.stockModels.count) {
        [self.needDrawStockModels addObjectsFromArray:[self.stockModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount)]];
    }else{
        [self.needDrawStockModels addObjectsFromArray:[self.stockModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, self.stockModels.count-needDrawKLineStartIndex)]];
    }
    return self.needDrawStockModels;
}

#pragma mark 将stockModel模型转换成KLine模型
-(NSArray *)private_convertToKLineModelWithStockModels:(NSArray *)stockModels
{
    //算得最小单位
    HYStockModel *firstModel = (HYStockModel *)[stockModels firstObject];
    CGFloat minAssert = firstModel.low;
    CGFloat maxAssert = firstModel.high;
    for (HYStockModel *stockModel in stockModels) {
        if (stockModel.high > maxAssert) {
            maxAssert = stockModel.high;
        }
        if (stockModel.low < minAssert) {
            minAssert = stockModel.low;
        }
    }
    CGFloat minY = 0;
    CGFloat maxY = self.frame.size.height;
    CGFloat unitValue = (maxAssert - minAssert)/(maxY - minY);

    [self.needDrawKLineModels removeAllObjects];
    
    NSInteger stockModelsCount = stockModels.count;
    for (NSInteger idx = 0; idx < stockModelsCount; ++idx) {
        HYStockModel *stockModel = stockModels[idx];
        CGFloat xPosition = self.startXPosition + idx*(self.kLineWidth+self.kLineGap);
        CGPoint openPoint = CGPointMake(xPosition, ABS(maxY - (stockModel.open-minAssert)/unitValue));
        
        CGFloat closePointY = ABS(maxY - (stockModel.close-minAssert)/unitValue);
        if (ABS(closePointY - openPoint.y) < HYStockChartKLineMinWidth) {
            if (openPoint.y > closePointY) {
                openPoint.y = closePointY+HYStockChartKLineMinWidth;
            }else if (openPoint.y < closePointY){
                closePointY = openPoint.y + HYStockChartKLineMinWidth;
            }else{
                if (idx > 0) {
                    HYStockModel *preStockModel = stockModels[idx-1];
                    if (stockModel.open > preStockModel.close) {
                        openPoint.y = closePointY + HYStockChartKLineMinWidth;
                    }else{
                        closePointY = openPoint.y + HYStockChartKLineMinWidth;
                    }
                }else if(idx+1 < stockModelsCount){
                    HYStockModel *subStockModel = stockModels[idx+1];
                    if (stockModel.close < subStockModel.open) {
                        openPoint.y = closePointY + HYStockChartKLineMinWidth;
                    }else{
                        closePointY = openPoint.y + HYStockChartKLineMinWidth;
                    }
                }
            }
        }
        CGPoint closePoint = CGPointMake(xPosition, closePointY);
        CGPoint highPoint = CGPointMake(xPosition, ABS(maxY - (stockModel.high-minAssert)/unitValue));
        CGPoint lowPoint = CGPointMake(xPosition, ABS(maxY - (stockModel.low-minAssert)/unitValue));
        HYKLineModel *kLineModel = [HYKLineModel modelWithOpen:openPoint close:closePoint high:highPoint low:lowPoint];
        [self.needDrawKLineModels addObject:kLineModel];
    }
    return self.needDrawKLineModels;
}

#pragma mark 更新自身view的宽度
-(void)private_updateSelfWidth
{
    //根据stockModels个数和间隙以及K线的宽度算出self的宽度,设置contentSize
    CGFloat kLineViewWidth = self.stockModels.count * self.kLineWidth + (self.stockModels.count + 1) * self.kLineGap+10;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kLineViewWidth));
    }];
    [self layoutIfNeeded];
    //更新scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(kLineViewWidth, self.scrollView.contentSize.height);
}

#pragma mark 添加所有事件监听的方法
-(void)private_addAllEventListenr
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(event_deviceOrientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    //用KVO监听scrollView的状态改变
    [_scrollView addObserver:self forKeyPath:kHYStockChartContentOffsetKey options:NSKeyValueObservingOptionNew context:nil];
    //缩放手势
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(event_pinchMethod:)];
    [self addGestureRecognizer:pinchGesture];
    //长按手势
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(event_longPressMethod:)];
    [self addGestureRecognizer:longPressGesture];
}


#pragma mark - 系统方法
#pragma mark 已经添加到父view的方法
-(void)didMoveToSuperview
{
    _scrollView = (UIScrollView *)self.superview;
    [self private_addAllEventListenr];
    [super didMoveToSuperview];
}

#pragma mark KVO监听实现的方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kHYStockChartContentOffsetKey]) {
        CGFloat difValue = ABS(self.scrollView.contentOffset.x - self.oldContentOffsetX);
        if (difValue >= (self.kLineGap+self.kLineWidth)) {
            self.oldContentOffsetX = self.scrollView.contentOffset.x;
            [self drawInnerView];
        }
    }
}

#pragma mart - 事件处理方法
#pragma mark 缩放执行的方法
-(void)event_pinchMethod:(UIPinchGestureRecognizer *)pinch
{
    static CGFloat oldScale = 1.0f;
    CGFloat difValue = pinch.scale - oldScale;
    if (ABS(difValue) > kHYStockChartScaleBound) {
        self.kLineWidth = self.kLineWidth*(difValue>0?(1+kHYStockChartScaleFactor):(1-kHYStockChartScaleFactor));
        oldScale = pinch.scale;
        //更新InnerView的宽度
        [self private_updateSelfWidth];
        [self drawInnerView];
    }
}

#pragma mark 长按手势执行方法
-(void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress
{
    static UIView *verticalView = nil;
    static CGFloat oldPositionX = 0;
    if (UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        CGPoint location = [longPress locationInView:self];
        if (ABS(oldPositionX - location.x) < (self.kLineGap+self.kLineWidth)/2) {
            return;
        }
        //让scrollView的scrollEnabled不可用
        self.scrollView.scrollEnabled = NO;
        oldPositionX = location.x;
        //更改竖线的位置
        if (!verticalView) {
            verticalView = [UIView new];
            [self addSubview:verticalView];
            verticalView.backgroundColor = [UIColor blackColor];
            [verticalView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.width.equalTo(@1);
                make.height.equalTo(self.mas_height);
                make.left.equalTo(@0);
            }];
        }
        
        NSInteger startIndex = (NSInteger)((location.x-self.startXPosition) / (self.kLineGap+self.kLineWidth));
        NSInteger arrCount = self.needDrawKLineModels.count;
        for (NSInteger index = startIndex > 0 ? startIndex-1 : 0; index < arrCount; ++index) {
            HYKLineModel *kLineModel = self.needDrawKLineModels[index];
            CGFloat minX = kLineModel.highPoint.x - (self.kLineWidth+self.kLineGap)/2;
            CGFloat maxX = kLineModel.highPoint.x + (self.kLineWidth+self.kLineGap)/2;
            if (location.x > minX && location.x < maxX) {
                [verticalView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@(kLineModel.highPoint.x));
                }];
                [verticalView layoutIfNeeded];
                verticalView.hidden = NO;
                return;
            }
        }
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
    [self private_updateSelfWidth];
    [self drawInnerView];
}

#pragma mark - 垃圾回收方法
#pragma mark dealloc方法
-(void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:kHYStockChartContentOffsetKey];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
