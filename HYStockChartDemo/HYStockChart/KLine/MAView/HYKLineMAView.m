//
//  HYKLineMAView.m
//  jimustock
//
//  Created by jimubox on 15/5/19.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYKLineMAView.h"
#import "UIColor+HYStockChart.h"
#import "UIFont+HYStockChart.h"

/************************展示各种MA的View************************/
@interface HYKLineMAView()

@property (weak, nonatomic) IBOutlet UILabel *ma5Label;

@property (weak, nonatomic) IBOutlet UILabel *ma10Label;

@property (weak, nonatomic) IBOutlet UILabel *ma20Label;

@property (weak, nonatomic) IBOutlet UILabel *ma30Label;

@end

@implementation HYKLineMAView

#pragma mark 创建HYKLineMAView的工厂方法
+(instancetype)kLineMAView
{
    HYKLineMAView *maView = (HYKLineMAView *)[[[NSBundle mainBundle] loadNibNamed:@"HYKLineMAView" owner:nil options:nil] lastObject];
    return maView;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.ma5Label.textColor = [UIColor ma5Color];
    self.ma10Label.textColor = [UIColor ma10Color];
    self.ma20Label.textColor = [UIColor ma20Color];
    self.ma30Label.textColor = [UIColor ma30Color];
    self.ma5Label.font = [UIFont f310Font];
    self.ma10Label.font = [UIFont f310Font];
    self.ma20Label.font = [UIFont f310Font];
    self.ma30Label.font = [UIFont f310Font];
}

#pragma mark - set方法
#pragma mark setMaModel的方法
-(void)setMaModel:(HYKLineMAModel *)maModel
{
    _maModel = maModel;
    if (maModel) {
        self.ma5Label.text = [NSString stringWithFormat:@"MA5：%.2f",maModel.ma5Value];
        self.ma10Label.text = [NSString stringWithFormat:@"MA10：%.2f",maModel.ma10Value];
        self.ma20Label.text = [NSString stringWithFormat:@"MA20：%.2f",maModel.ma20Value];
        self.ma30Label.text = [NSString stringWithFormat:@"MA30：%.2f",maModel.ma30Value];
    }
}

@end

/************************MAView的模型************************/
@implementation HYKLineMAModel
+(instancetype)maModelWithMA5:(CGFloat)MA5 MA10:(CGFloat)MA10 MA20:(CGFloat)MA20 MA30:(CGFloat)MA30
{
    HYKLineMAModel *model = [[HYKLineMAModel alloc] init];
    model.ma5Value = MA5;
    model.ma10Value = MA10;
    model.ma20Value = MA20;
    model.ma30Value = MA30;
    return model;
}
@end