//
//  JimuStockChartDemoTests.m
//  JimuStockChartDemoTests
//
//  Created by jimubox on 15/5/4.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HYKLineView.h"
#import "HYKLineModel.h"


@interface JimuStockChartDemoTests : XCTestCase

@end

@implementation JimuStockChartDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSMutableArray *models = [NSMutableArray array];
    for (NSInteger index = 0; index < 100; index++) {
        HYKLineModel *model = [HYKLineModel new];
        [models addObject:model];
    }
    HYKLineView *kLineView = [[HYKLineView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    kLineView.kLineModels = models;
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
