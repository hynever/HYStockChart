//
//  HYKLineView.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYKLineAboveView.h"
#import "HYStockChartConstant.h"
#import "HYKLineModel.h"
#import "HYKLine.h"
#import "HYKeyValueObserver.h"
#import "Masonry.h"
#import "HYStockChartGloablVariable.h"

@interface HYKLineAboveView ()

@property(nonatomic,strong) NSMutableArray *needDrawKLineModels;

@property(nonatomic,strong) NSMutableArray *needDrawKLinePositionModels;

@property(nonatomic,assign) NSUInteger needDrawStartIndex;

@property(nonatomic,assign,readonly) CGFloat startXPosition;

@property(nonatomic,assign) CGFloat oldContentOffsetX;

@property(nonatomic,assign) CGFloat oldScale;


@end

@implementation HYKLineAboveView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.needDrawKLinePositionModels = [NSMutableArray array];
        self.needDrawKLineModels = [NSMutableArray array];
        _needDrawStartIndex = 0;
        self.oldContentOffsetX = 0;
        self.oldScale = 0;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 绘图相关方法
#pragma mark drawRect方法
- (void)drawRect:(CGRect)rect {
    if (!self.kLineModels) {
        return;
    }
    //先提取需要展示的stockModel
    [self private_extractNeedDrawModels];
    //将stockModel转换成坐标模型
    NSArray *kLinePositioinModels = [self private_convertToKLinePositionModelWithKLineModels:self.needDrawKLineModels];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    HYKLine *kLine = [[HYKLine alloc] initWithContext:context];
    kLine.maxY = HYStockChartAboveViewMaxY;
    NSInteger idx = 0;
    for (HYKLinePositionModel *kLinePositionModel in kLinePositioinModels) {
        kLine.kLinePositionModel = kLinePositionModel;
        kLine.kLineModel = self.needDrawKLineModels[idx];
        if (idx%4 == 0) {
            kLine.isNeedDrawDate = YES;
        }
        [kLine draw];
        idx++;
    }
    [super drawRect:rect];
}

#pragma mark 重新设置相关变量，然后绘图
-(void)drawAboveView
{
    if (!self.kLineModels) {
        return;
    }
    //间接调用drawRect方法
    [self setNeedsDisplay];
}

#pragma mark - set&get方法
#pragma mark startXPosition的get方法
-(CGFloat)startXPosition
{
    CGFloat lineGap = [HYStockChartGloablVariable kLineGap];
    CGFloat lineWidth = [HYStockChartGloablVariable kLineWidth];
    NSInteger leftArrCount = self.needDrawStartIndex;
    CGFloat startXPosition = (leftArrCount+1)*lineGap + leftArrCount*lineWidth+lineWidth/2;
    return startXPosition;
}

#pragma mark needDrawStartIndex的get方法
-(NSUInteger)needDrawStartIndex
{
    CGFloat lineGap = [HYStockChartGloablVariable kLineGap];
    CGFloat lineWidth = [HYStockChartGloablVariable kLineWidth];
    CGFloat scrollViewOffsetX = self.scrollView.contentOffset.x < 0 ? 0 : self.scrollView.contentOffset.x;
    NSUInteger leftArrCount = ABS(scrollViewOffsetX - lineGap)/(lineWidth+lineGap);
    _needDrawStartIndex = leftArrCount;
    return _needDrawStartIndex;
}

#pragma mark stockModels的set方法
-(void)setKLineModels:(NSArray *)kLineModels
{
    _kLineModels = kLineModels;
    [self updateAboveViewWidth];
}

#pragma mark - 公有方法
#pragma mark 更新自身view的宽度
-(void)updateAboveViewWidth
{
    //根据stockModels个数和间隙以及K线的宽度算出self的宽度,设置contentSize
    CGFloat kLineViewWidth = self.kLineModels.count * [HYStockChartGloablVariable kLineWidth] + (self.kLineModels.count + 1) * [HYStockChartGloablVariable kLineGap]+10;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kLineViewWidth));
    }];
    [self layoutIfNeeded];
    //更新scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(kLineViewWidth, self.scrollView.contentSize.height);
}


#pragma mark 根据原始的x的位置获得精确的X的位置
-(CGFloat)getRightXPositionWithOriginXPosition:(CGFloat)originXPosition
{
    CGFloat xPositionInAboveView = originXPosition + self.scrollView.contentOffset.x - 10;
    NSInteger startIndex = (NSInteger)((xPositionInAboveView-self.startXPosition) / ([HYStockChartGloablVariable kLineGap]+[HYStockChartGloablVariable kLineWidth]));
    NSInteger arrCount = self.needDrawKLinePositionModels.count;
    for (NSInteger index = startIndex > 0 ? startIndex-1 : 0; index < arrCount; ++index) {
        HYKLinePositionModel *kLineModel = self.needDrawKLinePositionModels[index];
        CGFloat minX = kLineModel.highPoint.x - ([HYStockChartGloablVariable kLineGap]+[HYStockChartGloablVariable kLineWidth])/2;
        CGFloat maxX = kLineModel.highPoint.x + ([HYStockChartGloablVariable kLineGap]+[HYStockChartGloablVariable kLineWidth])/2;
        if (xPositionInAboveView > minX && xPositionInAboveView < maxX) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(kLineAboveViewLongPressKLineModel:)]) {
                [self.delegate kLineAboveViewLongPressKLineModel:self.needDrawKLinePositionModels[index]];
            }
            return kLineModel.highPoint.x - self.scrollView.contentOffset.x+[HYStockChartGloablVariable kLineWidth]/2-[HYStockChartGloablVariable kLineGap];
        }
    }
    return 0;
}


#pragma mark - 私有方法
#pragma mark 提取需要绘制的数组
-(NSArray *)private_extractNeedDrawModels
{
    CGFloat lineGap = [HYStockChartGloablVariable kLineGap];
    CGFloat lineWidth = [HYStockChartGloablVariable kLineWidth];
    
    //数组个数
    CGFloat scrollViewWidth = self.scrollView.frame.size.width;
    CGFloat needDrawKLineCount = (scrollViewWidth - lineGap)/(lineGap+lineWidth);
    
    //起始位置
    NSInteger needDrawKLineStartIndex = self.needDrawStartIndex;
    
    [self.needDrawKLineModels removeAllObjects];
    if ((needDrawKLineStartIndex + needDrawKLineCount) < self.kLineModels.count) {
        [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount)]];
    }else{
        [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, self.kLineModels.count-needDrawKLineStartIndex)]];
    }
    return self.needDrawKLineModels;
}

#pragma mark 将stockModel模型转换成KLine模型
-(NSArray *)private_convertToKLinePositionModelWithKLineModels:(NSArray *)kLineModels
{
    //算得最小单位
    HYKLineModel *firstModel = (HYKLineModel *)[kLineModels firstObject];
    CGFloat minAssert = firstModel.low;
    CGFloat maxAssert = firstModel.high;
    for (HYKLineModel *kLineModel in kLineModels) {
        if (kLineModel.high > maxAssert) {
            maxAssert = kLineModel.high;
        }
        if (kLineModel.low < minAssert) {
            minAssert = kLineModel.low;
        }
    }
    CGFloat minY = HYStockChartAboveViewMinY;
    CGFloat maxY = HYStockChartAboveViewMaxY;
    CGFloat unitValue = (maxAssert - minAssert)/(maxY - minY);

    [self.needDrawKLinePositionModels removeAllObjects];
    
    NSInteger kLineModelsCount = kLineModels.count;
    for (NSInteger idx = 0; idx < kLineModelsCount; ++idx) {
        HYKLineModel *kLineModel = kLineModels[idx];
        CGFloat xPosition = self.startXPosition + idx*([HYStockChartGloablVariable kLineWidth]+[HYStockChartGloablVariable kLineGap]);
        CGPoint openPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.open-minAssert)/unitValue));
        
        CGFloat closePointY = ABS(maxY - (kLineModel.close-minAssert)/unitValue);
        if (ABS(closePointY - openPoint.y) < HYStockChartKLineMinWidth) {
            if (openPoint.y > closePointY) {
                openPoint.y = closePointY+HYStockChartKLineMinWidth;
            }else if (openPoint.y < closePointY){
                closePointY = openPoint.y + HYStockChartKLineMinWidth;
            }else{
                if (idx > 0) {
                    HYKLineModel *preKLineModel = kLineModels[idx-1];
                    if (kLineModel.open > preKLineModel.close) {
                        openPoint.y = closePointY + HYStockChartKLineMinWidth;
                    }else{
                        closePointY = openPoint.y + HYStockChartKLineMinWidth;
                    }
                }else if(idx+1 < kLineModelsCount){
                    HYKLineModel *subStockModel = kLineModels[idx+1];
                    if (kLineModel.close < subStockModel.open) {
                        openPoint.y = closePointY + HYStockChartKLineMinWidth;
                    }else{
                        closePointY = openPoint.y + HYStockChartKLineMinWidth;
                    }
                }
            }
        }
        CGPoint closePoint = CGPointMake(xPosition, closePointY);
        CGPoint highPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.high-minAssert)/unitValue));
        CGPoint lowPoint = CGPointMake(xPosition, ABS(maxY - (kLineModel.low-minAssert)/unitValue));
        HYKLinePositionModel *kLinePositionModel = [HYKLinePositionModel modelWithOpen:openPoint close:closePoint high:highPoint low:lowPoint];
        [self.needDrawKLinePositionModels addObject:kLinePositionModel];
    }
    //执行代理方法
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(kLineAboveViewCurrentMaxPrice:minPrice:)]) {
            [self.delegate kLineAboveViewCurrentMaxPrice:maxAssert minPrice:minAssert];
        }
        if ([self.delegate respondsToSelector:@selector(kLineAboveViewNeedDrawKLinePositionModels:)]) {
            [self.delegate kLineAboveViewNeedDrawKLinePositionModels:self.needDrawKLinePositionModels];
        }
    }
    return self.needDrawKLinePositionModels;
}

#pragma mark 添加所有事件监听的方法
-(void)private_addAllEventListenr
{
    //用KVO监听scrollView的状态改变
    [_scrollView addObserver:self forKeyPath:HYStockChartContentOffsetKey options:NSKeyValueObservingOptionNew context:nil];
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
    if ([keyPath isEqualToString:HYStockChartContentOffsetKey]) {
        CGFloat difValue = ABS(self.scrollView.contentOffset.x - self.oldContentOffsetX);
        if (difValue >= ([HYStockChartGloablVariable kLineGap]+[HYStockChartGloablVariable kLineWidth])) {
            self.oldContentOffsetX = self.scrollView.contentOffset.x;
            [self drawAboveView];
        }
    }
}

#pragma mark - 垃圾回收方法
#pragma mark dealloc方法
-(void)dealloc
{
    [_scrollView removeObserver:self forKeyPath:HYStockChartContentOffsetKey];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
