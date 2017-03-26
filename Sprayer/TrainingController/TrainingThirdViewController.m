//
//  TrainingFirstViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/2.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "TrainingThirdViewController.h"
#import "FLChartView.h"
#import "RetrainingViewController.h"
#import "UserDefaultsUtils.h"
@interface TrainingThirdViewController ()<CustemBBI>
{
    UIView *circleView;
}
@property (nonatomic,strong)FLChartView *chartView;
@end

@implementation TrainingThirdViewController

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
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"first"];
}

#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建UI
-(void)createView
{
    UILabel *thirdResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, screen_width, 60)];
    thirdResultLabel.text = @"Third Inspiratory Cycle Results";
    thirdResultLabel.textColor = RGBColor(8, 86, 184, 1.0);
    thirdResultLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:thirdResultLabel];
    
    circleView = [[UIView alloc] initWithFrame:CGRectMake(15, thirdResultLabel.current_y_h+10, screen_width-30, (screen_height-thirdResultLabel.current_y_h-tabbarHeight)/2)];
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
    NSArray * mutArr = [[UserDefaultsUtils valueWithKey:@"trainDataArr"][2] componentsSeparatedByString:@","];;
    self.chartView = [[FLChartView alloc]initWithFrame:CGRectMake(0, 30, circleView.current_w, circleView.current_h-30)];
    self.chartView.backgroundColor = [UIColor clearColor];
    self.chartView.titleOfYStr = @"SLM";
    self.chartView.titleOfXStr = @"Sec";
    self.chartView.leftDataArr = mutArr;
    //求出数组的最大值
    int max = 0;
    for (NSString * str in mutArr) {
        if (max<[str intValue]) {
            max = [str intValue];
        }
    }
    if (max>100) {
        max = max/100+1;
        max*=100;
    }else if (max>10)
    {
        max = max/10+1;
        max*=10;
    }else
    {
        max = 10;
    }
    //得出y轴的坐标轴
    NSMutableArray * yNumArr = [NSMutableArray array];
    for (int i =10; i>=0;i--) {
        [yNumArr addObject:[NSString stringWithFormat:@"%d",i*(max/10)]];
    }
    
    self.chartView.dataArrOfY = yNumArr;//拿到Y轴坐标
    self.chartView.dataArrOfX = @[@"0",@"0.1",@"0.2",@"0.3",@"0.4",@"0.5",@"0.6",@"0.7",@"0.8",@"0.9",@"1.0",@"1.1",@"1.2",@"1.3",@"1.4",@"1.5",@"1.6",@"1.7",@"1.8",@"1.9",@"2.0",@"2.1",@"2.2",@"2.3",@"2.4",@"2.5",@"2.6",@"2.7",@"2.8",@"3.0"];//拿到X轴坐标

    [circleView addSubview:self.chartView];
    
    //单位
    UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.current_x_w, 15, circleView.current_w-titleLabel.current_x_w-10, 35)];
    totalLabel.textAlignment = NSTextAlignmentRight;
    totalLabel.textColor = RGBColor(8, 86, 184, 1.0);
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"Total:5.5L"];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:13]
                          range:NSMakeRange(0, 6)];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:20]
                          range:NSMakeRange(6, 4)];
    totalLabel.attributedText = AttributedStr;
    [circleView addSubview:totalLabel];
    
    //训练完成按钮
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(50, 0, screen_width-100, 40);
    completeBtn.center = CGPointMake(screen_width/2, circleView.current_y_h+(self.view.current_h-circleView.current_y_h-tabbarHeight)/2);
    [completeBtn setTitle:@"Complete the Training" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [completeBtn setBackgroundColor:RGBColor(16, 101, 182, 1.0)];
    completeBtn.layer.mask = [DisplayUtils cornerRadiusGraph:completeBtn withSize:CGSizeMake(completeBtn.current_h/2, completeBtn.current_h/2)];
    [completeBtn addTarget:self action:@selector(thirdBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeBtn];
}

#pragma mark - 点击事件
-(void)thirdBtnAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"After training,please select the best inspiratory cycle curve for display during spray dose application." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RetrainingViewController *retrainVC = [[RetrainingViewController alloc] init];
        [self.navigationController pushViewController:retrainVC animated:YES];
    }];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
