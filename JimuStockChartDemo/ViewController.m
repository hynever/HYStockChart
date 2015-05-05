//
//  ViewController.m
//  JimuStockChartDemo
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "ViewController.h"
#import "HYStockChart.h"
#import "Masonry.h"
#import "CHCSVParser.h"
#import "HYStockModel.h"
#import "MJExtension.h"
#import "HYKLineView.h"


@interface ViewController ()

@property(nonatomic,strong) HYStockChartView *stockView;

@property(nonatomic,strong) HYKLineView *kLineView;

@property(nonatomic,strong) UIButton *updateDataBtn;

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.kLineView.backgroundColor = [UIColor clearColor];
    [self.updateDataBtn setTitle:@"更新数据" forState:UIControlStateNormal];
    self.updateDataBtn.backgroundColor = [UIColor greenColor];
}

#pragma mark set&get方法
#pragma mark HYKLineView的get方法
-(HYKLineView *)kLineView
{
    if (!_kLineView) {
        _kLineView = [HYKLineView new];
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
            make.top.equalTo(self.kLineView.mas_bottom).offset(10);
            make.left.equalTo(self.kLineView.mas_left).offset(50);
            make.height.equalTo(@40);
            make.width.equalTo(@80);
        }];
        [_updateDataBtn addTarget:self action:@selector(updateData) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateDataBtn;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSMutableArray *models = [NSMutableArray array];
//    for (NSInteger index = 0; index < 100; index++) {
//        HYStockModel *model = [HYStockModel new];
//        [models addObject:model];
//    }
//    self.kLineView.stockModels = models;
}


-(void)updateData
{
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"stock.csv" withExtension:nil];
    NSArray *arr = [NSArray arrayWithContentsOfCSVURL:URL options:CHCSVParserOptionsUsesFirstLineAsKeys];
    NSArray *modelArr = [HYStockModel objectArrayWithKeyValuesArray:arr];
    self.stockView.stockData = modelArr;
    self.kLineView.stockModels = modelArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
