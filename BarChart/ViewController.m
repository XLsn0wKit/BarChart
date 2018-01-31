//
//  ViewController.m
//  BarChart
//
//  Created by ginlong on 2018/1/25.
//  Copyright © 2018年 ginlong. All rights reserved.
//
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kSameColor [UIColor redColor]

#import "ViewController.h"
#import <Charts/Charts-Swift.h>

@interface ViewController () <ChartViewDelegate>

@property (nonatomic, strong) BarChartView *barChartView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Stacked Bar Chart";
    
    _barChartView = [[BarChartView alloc] initWithFrame:(CGRectMake(0, 100, kScreenWidth, kScreenHeight-200))];
    [self.view addSubview:_barChartView];
    _barChartView.delegate = self;
    _barChartView.chartDescription.enabled = NO;
//    _barChartView.maxVisibleCount = 40;
//    _barChartView.pinchZoomEnabled = NO;
//    _barChartView.drawGridBackgroundEnabled = NO;
//    _barChartView.drawBarShadowEnabled = NO;
//    _barChartView.drawValueAboveBarEnabled = NO;
//    _barChartView.highlightFullBarEnabled = NO;
    
    /// 
    NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
    leftAxisFormatter.maximumFractionDigits = 1;
    
    ChartYAxis *yAxis = _barChartView.leftAxis;
    yAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
    yAxis.axisMinimum = -200; // this replaces startAtZero = YES
    yAxis.axisLineColor = UIColor.clearColor;
    _barChartView.rightAxis.enabled = NO;
    yAxis.gridColor = UIColor.clearColor;
    
    ChartXAxis *xAxis = _barChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.axisLineColor = UIColor.clearColor;
    xAxis.gridColor = UIColor.clearColor;
//    [xAxis setLabelCount:12];
    xAxis.labelCount = 12;
    
    ///底下说明文字
    ChartLegend *l = _barChartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.form = ChartLegendFormSquare;
    l.formSize = 8.0;
    l.formToTextSpace = 1.0;
    l.xEntrySpace = 6.0;
    [self setDataCount:13 range:100];
}

- (void)setDataCount:(int)count range:(double)range {
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        double mult = (range + 1);
        double val0 = (double) (arc4random_uniform(mult) + mult / 3);
        double val1 = (double) (arc4random_uniform(mult) + mult / 3);
        double val2 = (double) (arc4random_uniform(mult) + mult / 3);
        double val3 = -(double) (arc4random_uniform(mult) + mult / 3);
        double val4 = -(double) (arc4random_uniform(mult) + mult / 3);
        double val5 = -(double) (arc4random_uniform(mult) + mult / 3);
        
       NSArray *yValues = @[@(val0), @(val1), @(val2), @(val3), @(val4), @(val5)];
        
        [yVals addObject:[[BarChartDataEntry alloc] initWithX:i yValues:yValues]];
    }
    
    BarChartDataSet *set1 = nil;
    if (_barChartView.data.dataSetCount > 0) {
        set1 = (BarChartDataSet *)_barChartView.data.dataSets[0];
        set1.values = yVals;
        [_barChartView.data notifyDataChanged];
        [_barChartView notifyDataSetChanged];
    } else {
        set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@""];
        
        set1.drawIconsEnabled = NO;
        
        set1.colors = @[kSameColor, ///保持一致
                        [UIColor yellowColor],
                        [UIColor blueColor],
                        [UIColor blackColor],
                        [UIColor orangeColor],
                        kSameColor  ///保持一致
                        ];
        set1.stackLabels = @[@"自发用电", @"电网卖电", @"电池充电", @"电网买电", @"电池放电"];
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.maximumFractionDigits = 1;
        formatter.negativePrefix = @"";//如果是负数的时候的前缀 用这个空字符串代替默认的"-"号

        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        
        [data setValueFont:[UIFont boldSystemFontOfSize:4]];
        [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:formatter]];
        [data setValueTextColor:UIColor.grayColor];
        [data setBarWidth:0.5];///设置宽度
        
        _barChartView.fitBars = YES;
        _barChartView.data = data;
    }
}

#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight {
    NSLog(@"chartValueSelected, stack-index %ld", (long)highlight.stackIndex);
        [_barChartView centerViewToAnimatedWithXValue:entry.x
                                               yValue:entry.y
                                                 axis:[_barChartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView {
    NSLog(@"chart Value Nothing Selected");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    /// Dispose of any resources that can be recreated.
}

@end
