//
//  ViewController.m
//  HYStockChartDemo
//
//  Created by jimubox on 15/6/24.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "ViewController.h"
#import "HYStockChartViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)landScapeAction:(id)sender {
    HYStockChartViewController *stockChartVC = [HYStockChartViewController new];
    [self presentViewController:stockChartVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
