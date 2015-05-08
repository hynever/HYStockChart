//
//  ViewController.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "CHCSVParser.h"
#import "HYKLineModel.h"
#import "MJExtension.h"
#import "HYKLineView.h"
#import "HYStockChart.h"
#import "HYTimeLineModel.h"
#import "HYTimeLine.h"
#import "HYTimeLineView.h"


@interface ViewController ()

@property(nonatomic,strong) HYStockChartView *stockView;

@property(nonatomic,strong) HYKLineView *kLineView;

@property(nonatomic,strong) UIButton *updateDataBtn;

@property(nonatomic,strong) HYTimeLineView *timeLineView;

@property(nonatomic,weak) UIView *baseView;

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
//    self.kLineView.backgroundColor = [UIColor whiteColor];
    [self.timeLineView setBackgroundColor:[UIColor whiteColor]];
    [self.updateDataBtn setTitle:@"更新数据" forState:UIControlStateNormal];
    self.updateDataBtn.backgroundColor = [UIColor greenColor];
}

#pragma mark set&get方法
#pragma mark HYKLineView的get方法
-(HYKLineView *)kLineView
{
    if (!_kLineView) {
        _kLineView = [HYKLineView new];
        self.baseView = _kLineView;
        [self.view addSubview:_kLineView];
        WS(weakSelf);
        [_kLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view.mas_top).offset(100);
            make.left.equalTo(weakSelf.view.mas_left).offset(10);
            make.right.equalTo(weakSelf.view.mas_right).offset(-10);
            make.height.equalTo(@200);
        }];
    }
    return _kLineView;
}

-(UIButton *)updateDataBtn
{
    if (!_updateDataBtn) {
        _updateDataBtn = [UIButton new];
        [self.view addSubview:_updateDataBtn];
        [_updateDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.baseView.mas_bottom).offset(30);
            make.left.equalTo(self.baseView.mas_left).offset(50);
            make.height.equalTo(@40);
            make.width.equalTo(@80);
        }];
        [_updateDataBtn addTarget:self action:@selector(updateData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateDataBtn;
}

-(HYTimeLineView *)timeLineView
{
    if (!_timeLineView) {
        _timeLineView = [HYTimeLineView new];
        self.baseView = _timeLineView;
        [self.view addSubview:_timeLineView];
        [_timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(100);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.height.equalTo(@200);
        }];
    }
    return _timeLineView;
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}


-(void)updateData
{
//    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"stock.csv" withExtension:nil];
//    NSArray *arr = [NSArray arrayWithContentsOfCSVURL:URL options:CHCSVParserOptionsUsesFirstLineAsKeys];
//    NSArray *modelArr = [HYKLineModel objectArrayWithKeyValuesArray:arr];
//    self.kLineView.kLineModels = modelArr;
    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"KLine" ofType:@"plist"];
//    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
//    NSArray *kLineModelArr = [HYKLineModel objectArrayWithKeyValuesArray:dict[@"GlobalQuotes"]];
//    self.kLineView.kLineModels = kLineModelArr;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TimeLine" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
    NSArray *timeLineModels = [HYTimeLineModel objectArrayWithKeyValuesArray:arr];
    self.timeLineView.timeLineModels = timeLineModels;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
