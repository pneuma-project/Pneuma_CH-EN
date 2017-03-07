//
//  TrainingFirstViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/2.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "TrainingFirstViewController.h"
#import "FLChartView.h"
#import "TrainingSecondViewController.h"

@interface TrainingFirstViewController ()
{
    UIView *circleView;
}
@property (nonatomic,strong)FLChartView *chartView;
@end

@implementation TrainingFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:[DisplayUtils getTimestampData]];
    [self createView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}

#pragma mark - 创建UI
-(void)createView
{
    UILabel *firstResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, screen_width, 60)];
    firstResultLabel.text = @"First Inspiratory Cycle Results";
    firstResultLabel.textColor = RGBColor(8, 86, 184, 1.0);
    firstResultLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:firstResultLabel];
    
    circleView = [[UIView alloc] initWithFrame:CGRectMake(15, firstResultLabel.current_y_h+10, screen_width-30, (screen_height-firstResultLabel.current_y_h-tabbarHeight)/2)];
    circleView.backgroundColor = [UIColor whiteColor];
    circleView.layer.mask = [DisplayUtils cornerRadiusGraph:circleView withSize:CGSizeMake(5, 5)];
    [self.view addSubview:circleView];
    
    //图标题
    UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 5, 5)];
    pointImageView.center = CGPointMake(10, 25);
    pointImageView.backgroundColor = RGBColor(0, 83, 181, 1.0);
    pointImageView.layer.mask = [DisplayUtils cornerRadiusGraph:pointImageView withSize:CGSizeMake(pointImageView.current_w/2, pointImageView.current_h/2)];
    [circleView addSubview:pointImageView];
    
    NSString *titleStr = @"Inspiratory Cycle";
    CGSize size = [DisplayUtils stringWithWidth:titleStr withFont:17];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointImageView.current_x_w+10, 5, size.width, 40)];
    titleLabel.text = titleStr;
    titleLabel.textColor = RGBColor(8, 86, 184, 1.0);
    [circleView addSubview:titleLabel];
    
    //曲线图
    NSArray *tempDataArrOfY = @[@"20",@"40",@"60",@"80",@"60",@"20"];
    self.chartView = [[FLChartView alloc]initWithFrame:CGRectMake(0, 30, circleView.current_w, circleView.current_h-30)];
    self.chartView.backgroundColor = [UIColor clearColor];
    self.chartView.titleOfYStr = @"SLM";
    self.chartView.titleOfXStr = @"Sec";
    self.chartView.leftDataArr = tempDataArrOfY;
    self.chartView.dataArrOfY = @[@"180",@"160",@"140",@"120",@"100",@"80",@"60",@"40",@"20",@"0"];//拿到Y轴坐标
    self.chartView.dataArrOfX = @[@"0.5",@"1",@"1.5",@"2",@"2.5",@"3"];//拿到X轴坐标
    [circleView addSubview:self.chartView];
    
    //单位
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.current_x_w, 15, circleView.current_w-titleLabel.current_x_w-10, 35)];
    totalLabel.textAlignment = NSTextAlignmentRight;
    totalLabel.textColor = RGBColor(8, 86, 184, 1.0);
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"Total:4.2L"];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:13]
                          range:NSMakeRange(0, 6)];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:20]
                          range:NSMakeRange(6, 4)];
    totalLabel.attributedText = AttributedStr;
    [circleView addSubview:totalLabel];
    
    //第二次训练按钮
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secondBtn.frame = CGRectMake(50, 0, screen_width-100, 40);
    secondBtn.center = CGPointMake(screen_width/2, circleView.current_y_h+(self.view.current_h-circleView.current_y_h-tabbarHeight)/2);
    [secondBtn setTitle:@"The Second Training" forState:UIControlStateNormal];
    [secondBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    secondBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [secondBtn setBackgroundColor:RGBColor(16, 101, 182, 1.0)];
    secondBtn.layer.mask = [DisplayUtils cornerRadiusGraph:secondBtn withSize:CGSizeMake(secondBtn.current_h/2, secondBtn.current_h/2)];
    [secondBtn addTarget:self action:@selector(secondBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secondBtn];
}

#pragma mark - 点击事件
-(void)secondBtnAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you ready?" message:@"Now you're ready to start your second inspiration." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TrainingSecondViewController *secondVC = [[TrainingSecondViewController alloc] init];
        [self.navigationController pushViewController:secondVC animated:YES];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
