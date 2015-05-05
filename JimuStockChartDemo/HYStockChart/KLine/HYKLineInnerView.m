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

static NSString * const kHYStockChartContentOffsetKey = @"contentOffset";
static NSString * const kHYStockChartZoomScaleKey = @"zoomScale";


@interface HYKLineInnerView ()

@property(nonatomic,strong) NSMutableArray *needDrawStockModels;

@property(nonatomic,assign) NSInteger needDrawStockStartIndex;

@property(nonatomic,assign,readonly) CGFloat startXPosition;

@property(nonatomic,assign) CGFloat oldContentOffsetX;

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
        self.needDrawStockStartIndex = 0;
        self.oldContentOffsetX = 0;
    }
    return self;
}

#pragma mark - 绘图相关方法
#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect {
    if (!self.stockModels) {
        return;
    }
    //将stockModel转换成坐标模型
    //先提取需要展示的stockModel
    [self private_extractNeedDrawModels];
    NSArray *kLineModels = [self private_convertToKLineModelWithStockModels:self.needDrawStockModels];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    HYKLine *kLine = [[HYKLine alloc] initWithContext:context];
    kLine.solidLineWidth = self.kLineWidth;
    for (HYKLineModel *kLineModel in kLineModels) {
        kLine.kLineModel = kLineModel;
        [kLine draw];
    }
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
    CGFloat startXPosition = (leftArrCount+1)*lineGap + leftArrCount*lineWidth;
//    self.scrollView.contentOffset = CGPointMake(startXPosition, 0);
    return startXPosition;
}

#pragma mark needDrawStockStartIndex的get方法
-(NSInteger)needDrawStockStartIndex
{
    CGFloat lineGap = self.kLineGap;
    CGFloat lineWidth = self.kLineWidth;
    CGFloat scrollViewOffsetX = self.scrollView.contentOffset.x < 0 ? 0 : self.scrollView.contentOffset.x;
    NSInteger leftArrCount = (scrollViewOffsetX - lineGap)/(lineWidth+lineGap);
    _needDrawStockStartIndex = leftArrCount;
    return _needDrawStockStartIndex;
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
    
    NSMutableArray *kLineModels = [NSMutableArray array];

#warning 这里暂时没有处理实体线和上下影线的宽度引起的问题
    [stockModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HYStockModel *stockModel = (HYStockModel *)obj;
        CGFloat xPosition = self.startXPosition + idx*(self.kLineWidth+self.kLineGap);
        CGPoint openPoint = CGPointMake(xPosition, ABS(maxY - (stockModel.open-minAssert)/unitValue));
        CGPoint closePoint = CGPointMake(xPosition, ABS(maxY - (stockModel.close-minAssert)/unitValue));
        CGPoint highPoint = CGPointMake(xPosition, ABS(maxY - (stockModel.high-minAssert)/unitValue));
        CGPoint lowPoint = CGPointMake(xPosition, ABS(maxY - (stockModel.low-minAssert)/unitValue));
        HYKLineModel *kLineModel = [HYKLineModel modelWithOpen:openPoint close:closePoint high:highPoint low:lowPoint];
        [kLineModels addObject:kLineModel];
    }];
    return kLineModels;
}


#pragma mark - 系统方法
#pragma mark 已经添加到父view的方法
-(void)didMoveToSuperview
{
    _scrollView = (UIScrollView *)self.superview;
    //用KVO监听scrollView的状态改变
    [_scrollView addObserver:self forKeyPath:kHYStockChartContentOffsetKey options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView addObserver:self forKeyPath:kHYStockChartZoomScaleKey options:NSKeyValueObservingOptionNew context:nil];
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
    }else if ([keyPath isEqualToString:kHYStockChartZoomScaleKey]){
        //根据缩放的因子设置K线的宽度
        [self drawInnerView];
    }
}

-(void)dealloc
{
    [self removeObserver:_scrollView forKeyPath:kHYStockChartContentOffsetKey];
    [self removeObserver:_scrollView forKeyPath:kHYStockChartZoomScaleKey];
}

@end
