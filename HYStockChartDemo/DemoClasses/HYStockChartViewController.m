//
//  HYStockChartViewController.m
//  HYStockChartDemo
//
//  Created by jimubox on 15/6/24.
//  Copyright (c) 2015年 jimubox. All rights reserved.
//

#import "HYStockChartViewController.h"
#import "HYStockChart.h"
#import "UIColor+HYStockChart.h"
#import "Masonry.h"
#import "JMSKLineGroupModel.h"
#import "JMSTimeLineModel.h"
#import "MJExtension.h"
#import "JMSGroupTimeLineModel.h"
#import "JMSKLineModel.h"

@interface HYStockChartViewController ()<HYStockChartViewDataSource>

@property(nonatomic,strong) HYStockChartView *stockChartView;

@property(nonatomic,assign) BOOL isFullScreen;

@property(nonatomic,strong) UIButton *cancelBtn;

@property(nonatomic,strong) JMSGroupTimeLineModel *groupTimeLineModel;

@property(nonatomic,strong) NSArray *fiveDaysModels;    //5日线的模型数组

@property(nonatomic,strong) JMSKLineGroupModel *dayKLineGroupModel;//日K线groupModel

@property(nonatomic,strong) JMSKLineGroupModel *weekKLineGroupModle;   //周K线的groupModel

@property(nonatomic,strong) JMSKLineGroupModel *monthKLineGroupModle;   //月K线的groupModel

@property(nonatomic,assign) NSInteger dayKlineTotalMonthAgo;

@property(nonatomic,strong) UIButton *refreshBtn;

@property(nonatomic,strong) UIActivityIndicatorView *indicatorView;

@end

@implementation HYStockChartViewController

#pragma mark - 控制器初始化方法
#pragma mark viewWillAppear方法
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(event_kLineNeedLoadMoreData:) name:HYStockChartKLineNeedLoadMoreDataNotification object:nil];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

#pragma mark viewWillDisappear方法
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HYStockChartKLineNeedLoadMoreDataNotification object:nil];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

#pragma mark viewDidLoa的方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.stockChartView.backgroundColor = [UIColor backgroundColor];
    [self setStockChartProfile];
    //设置屏幕横向
    self.isFullScreen = YES;
    self.dayKlineTotalMonthAgo = 0;
}

#pragma mark stockChartView的get方法
-(HYStockChartView *)stockChartView
{
    if (!_stockChartView) {
        _stockChartView = [HYStockChartView new];
        _stockChartView.itemModels = @[
                                       [HYStockChartViewItemModel itemModelWithTitle:@"时分" type:HYStockChartCenterViewTypeTimeLine],
                                       [HYStockChartViewItemModel itemModelWithTitle:@"5日" type:HYStockChartCenterViewTypeBrokenLine],
                                       [HYStockChartViewItemModel itemModelWithTitle:@"日K" type:HYStockChartCenterViewTypeKLine],
                                       [HYStockChartViewItemModel itemModelWithTitle:@"周K" type:HYStockChartCenterViewTypeKLine],
                                       [HYStockChartViewItemModel itemModelWithTitle:@"月K" type:HYStockChartCenterViewTypeKLine],
                                       ];
        _stockChartView.dataSource = self;
        [self.view addSubview:_stockChartView];
        [self.view bringSubviewToFront:self.cancelBtn];
        [self.view bringSubviewToFront:self.refreshBtn];
        [self.view bringSubviewToFront:self.indicatorView];
        [_stockChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _stockChartView;
}

#pragma mark cancelBtn的get方法
-(UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        [self.view addSubview:_cancelBtn];
        [_cancelBtn setImage:[UIImage imageNamed:@"K_line_close"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(event_dismissMySelf) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.width.equalTo(@21);
        }];
    }
    return _cancelBtn;
}

#pragma mark refreshBtn的get方法
-(UIButton *)refreshBtn
{
    if (!_refreshBtn) {
        _refreshBtn = [UIButton new];
        [self.view addSubview:_refreshBtn];
        [_refreshBtn setImage:[UIImage imageNamed:@"Reload_black"] forState:UIControlStateNormal];
        [_refreshBtn addTarget:self action:@selector(event_refreshData) forControlEvents:UIControlEventTouchUpInside];
        [_refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-20);
            make.bottom.equalTo(self.view).offset(-10);
            make.size.mas_equalTo(CGSizeMake(20, 16));
        }];
    }
    return _refreshBtn;
}

#pragma mark indicatorView的get方法
-(UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:_indicatorView];
        [self.view bringSubviewToFront:_indicatorView];
        [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
    }
    return _indicatorView;
}

#pragma mark - set方法
#pragma mark 设置是否需要全屏的方法
-(void)setIsFullScreen:(BOOL)isFullScreen
{
    _isFullScreen = isFullScreen;
    if (isFullScreen) {
        [UIView animateWithDuration:0.5f animations:^{
            [[UIDevice currentDevice] setValue:
             [NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
        }];
    }else{
        [UIView animateWithDuration:0.5f animations:^{
            [[UIDevice currentDevice] setValue:
             [NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
        }];
    }
}

-(void)setStockChartProfile
{
    HYStockChartProfileModel *profileModel = [HYStockChartProfileModel new];
    profileModel.Symbol = @"COMP.IND_GIDS";
    profileModel.Name = @"纳斯达克";
    profileModel.ChineseName = @"纳斯达克";
    profileModel.Volume = 20000000;
    profileModel.CurrentPrice = 5160.09;
    profileModel.applies = -003;
    HYStockType stockType = HYStockTypeUSA;
    profileModel.stockType = stockType;
    self.stockChartView.stockChartProfileModel = profileModel;
}

#pragma mark - 事件处理方法
#pragma mark 分时线数据请求方法
-(void)event_timeLineRequestMethod
{
    //加载假分时线数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TimeLine" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *datas = [dict objectForKey:@"Bars"];
    CGFloat PreClose = [[dict objectForKey:@"PreClose"] floatValue];
    if (!self.groupTimeLineModel) {
        self.groupTimeLineModel = [JMSGroupTimeLineModel new];
    }
    self.groupTimeLineModel.timeLineModels = [JMSTimeLineModel objectArrayWithKeyValuesArray:datas];
    self.groupTimeLineModel.lastDayEndPrice = PreClose;
    [self.stockChartView reloadData];
}

#pragma mark 5日线数据的请求方法
-(void)event_fiveDaysTimeLineRequestMethod
{
    //加载假5日线数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FiveDaysLine" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *datas = [dict objectForKey:@"Bars"];
    self.fiveDaysModels = [JMSTimeLineModel objectArrayWithKeyValuesArray:datas];
    [self.stockChartView reloadData];
}

#pragma mark 日K线数据的请求方法
-(void)event_daylyKLineRequestMethodWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    //加载假日K线数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DaylyKLine" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    self.dayKLineGroupModel = [JMSKLineGroupModel objectWithKeyValues:dict];
    [self.stockChartView reloadData];
}

#pragma mark 周K线数据的请求方法
-(void)event_weeklyKLineRequestMethodWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    //加载假周K线数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"WeeklyKLine" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    self.weekKLineGroupModle = [JMSKLineGroupModel objectWithKeyValues:dict];
    [self.stockChartView reloadData];
}

#pragma mark 月K线数据的请求方法
-(void)event_monthlyKLineRequestMethodWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    //加载假月K线数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"MonthlyKLine" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    self.monthKLineGroupModle = [JMSKLineGroupModel objectWithKeyValues:dict];
    [self.stockChartView reloadData];
}

#pragma mark K线图需要加载更多数据处理方法
-(void)event_kLineNeedLoadMoreData:(NSNotification *)noti
{
    //K线图一直往右边滑动，在需要加载更多数据的时候，会调用这个方法，默认是还有两个屏幕的数据就会调用这个方法
}

-(void)event_refreshData
{
    //刷新数据
    [self.indicatorView startAnimating];
    switch (self.stockChartView.currentIndex) {
        case 0:
            //时分线
            [self event_timeLineRequestMethod];
            break;
        case 1:
            //5日线
            [self event_fiveDaysTimeLineRequestMethod];
            break;
        case 2:
            //日K线
        {
            self.dayKLineGroupModel.GlobalQuotes = nil;
            [self event_daylyKLineRequestMethodWithStartDate:nil endDate:nil];
        }
            break;
        case 3:
            //周K
            [self.indicatorView stopAnimating];
            break;
        case 4:
            //月K
            [self.indicatorView stopAnimating];
            break;
        default:
            break;
    }
}


#pragma mark dissmiss自己的方法
-(void)event_dismissMySelf
{
    self.isFullScreen = NO;
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - HYStockChartView的代理方法
#pragma mark 某个对应的Index需要展示的数据
-(id)stockDatasWithIndex:(NSInteger)index
{
    [self.indicatorView startAnimating];
    switch (index) {
        case 0:
            //时分
            if (self.groupTimeLineModel.timeLineModels.count > 0) {
                //先将jms转换成hy
                NSArray *jmsTimeLineDict = [JMSTimeLineModel keyValuesArrayWithObjectArray:self.groupTimeLineModel.timeLineModels];
                NSArray *hyTimeLineModels = [HYTimeLineModel objectArrayWithKeyValuesArray:jmsTimeLineDict];
                HYTimeLineGroupModel *hyTimeGroupModel = [HYTimeLineGroupModel new];
                hyTimeGroupModel.lastDayEndPrice = self.groupTimeLineModel.lastDayEndPrice;
                hyTimeGroupModel.timeModels = hyTimeLineModels;
                [self.indicatorView stopAnimating];
                return hyTimeGroupModel;
            }else{
                [self event_timeLineRequestMethod];
            }
            break;
            
        case 1:
            //5日线
            if (self.fiveDaysModels.count > 0) {
                NSArray *jmsTimeLineDict = [JMSTimeLineModel keyValuesArrayWithObjectArray:self.fiveDaysModels];
                NSArray *hyTimeLineModels = [HYTimeLineModel objectArrayWithKeyValuesArray:jmsTimeLineDict];
                HYTimeLineGroupModel *hyTimeGroupModel = [HYTimeLineGroupModel new];
                hyTimeGroupModel.lastDayEndPrice = 0;
                hyTimeGroupModel.timeModels = hyTimeLineModels;
                [self.indicatorView stopAnimating];
                return hyTimeGroupModel;
            }else{
                [self event_fiveDaysTimeLineRequestMethod];
            }
            break;
        case 2:
            //日K线
            if (self.dayKLineGroupModel.GlobalQuotes > 0) {
                //先将JMS转换成HY
                NSArray *jmsKLineDict = [JMSKLineModel keyValuesArrayWithObjectArray:self.dayKLineGroupModel.GlobalQuotes];
                NSArray *hyKLineModels = [HYKLineModel objectArrayWithKeyValuesArray:jmsKLineDict];
                [self.indicatorView stopAnimating];
                return hyKLineModels;
            }else{
                [self event_daylyKLineRequestMethodWithStartDate:nil endDate:nil];
            }
            break;
        case 3:
            //周K线
            if (self.weekKLineGroupModle.GlobalQuotes > 0) {
                //先将JMS转换成HY
                NSArray *jmsKLineDict = [JMSKLineModel keyValuesArrayWithObjectArray:self.weekKLineGroupModle.GlobalQuotes];
                NSArray *hyKLineModels = [HYKLineModel objectArrayWithKeyValuesArray:jmsKLineDict];
                [self.indicatorView stopAnimating];
                return hyKLineModels;
            }else{
                [self event_weeklyKLineRequestMethodWithStartDate:nil endDate:nil];
            }
            break;
        case 4:
            //月K
            if (self.monthKLineGroupModle.GlobalQuotes > 0) {
                //先将JMS转换成HY
                NSArray *jmsKLineDict = [JMSKLineModel keyValuesArrayWithObjectArray:self.monthKLineGroupModle.GlobalQuotes];
                NSArray *hyKLineModels = [HYKLineModel objectArrayWithKeyValuesArray:jmsKLineDict];
                [self.indicatorView stopAnimating];
                return hyKLineModels;
            }else{
                [self event_monthlyKLineRequestMethodWithStartDate:nil endDate:nil];
            }
            break;
        default:
            break;
    }
    return nil;
}


#pragma mark - 屏幕旋转相关方法
#pragma mark 是否支持自动旋转
-(BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark 支持的方向
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationMaskPortrait;
}


@end
