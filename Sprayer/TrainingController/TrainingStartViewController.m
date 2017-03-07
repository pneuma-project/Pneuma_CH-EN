//
//  TrainingStartViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/2.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "TrainingStartViewController.h"
#import "FLChartView.h"
#import "TrainingFirstViewController.h"

@interface TrainingStartViewController ()<CustemBBI>
{
    UIView *headView;
}

@property (nonatomic,strong)FLChartView *chartView;
@end

@implementation TrainingStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:@"Inspiratory Training"];
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
    headView = [[UIView alloc] initWithFrame:CGRectMake(15, 80, screen_width-30, (screen_height-64-tabbarHeight-100)/2)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.layer.mask = [DisplayUtils cornerRadiusGraph:headView withSize:CGSizeMake(5, 5)];
    [self.view addSubview:headView];
    
    //图标题
    UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 5, 5)];
    pointImageView.center = CGPointMake(10, 15);
    pointImageView.backgroundColor = RGBColor(0, 83, 181, 1.0);
    pointImageView.layer.mask = [DisplayUtils cornerRadiusGraph:pointImageView withSize:CGSizeMake(pointImageView.current_w/2, pointImageView.current_h/2)];
    [headView addSubview:pointImageView];
    
    NSString *titleStr = @"Inspiratory Cycle";
    CGSize size = [DisplayUtils stringWithWidth:titleStr withFont:15];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointImageView.current_x_w+10, 0, size.width, 30)];
    titleLabel.text = titleStr;
    titleLabel.textColor = RGBColor(8, 86, 184, 1.0);
    titleLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:titleLabel];
    
    //曲线图
    self.chartView = [[FLChartView alloc]initWithFrame:CGRectMake(0, 20, headView.current_w, headView.current_h-20)];
    self.chartView.backgroundColor = [UIColor clearColor];
    self.chartView.titleOfYStr = @"SLM";
    self.chartView.titleOfXStr = @"Sec";
    self.chartView.dataArrOfY = @[@"180",@"160",@"140",@"120",@"100",@"80",@"60",@"40",@"20",@"0"];//拿到Y轴坐标
    self.chartView.dataArrOfX = @[@"0.5",@"1",@"1.5",@"2",@"2.5",@"3"];//拿到X轴坐标
    [headView addSubview:self.chartView];
    
    //详细说明
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(headView.current_x, headView.current_y_h+10, headView.current_w, 30)];
    desLabel.text = @"Training Description:";
    desLabel.textColor = RGBColor(8, 86, 184, 1.0);
    desLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:desLabel];
    
    NSString *detailStr = @"1.The training process provides instruction and training on proper use of the inhaler device.\n\n2.To activate the device for use PRESS the ON button until the RED LED light turns on.\n\n3.Inhale slowly and continue to inhale completely.\n\n4.The inspiratory cycle is displayed in real time as the patient in-hales and stored on the iPhone.\n\n5.After the patient records three inspiratory curves the best in-spiratory result is chosen and displayed during spray/dose application.";
    CGSize detailSize = [DisplayUtils stringWithWidth:detailStr withFont:10];
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(headView.current_x, desLabel.current_y_h, headView.current_w, detailSize.height+60)];
    detailLabel.text = detailStr;
    detailLabel.textColor = RGBColor(155, 160, 160, 1.0);
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:detailLabel];
    
    //第一次训练按钮
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    firstBtn.frame = CGRectMake(50, 0, screen_width-100, 40);
    firstBtn.center = CGPointMake(screen_width/2, detailLabel.current_y_h+(self.view.current_h-detailLabel.current_y_h-tabbarHeight)/2);
    [firstBtn setTitle:@"The First Training" forState:UIControlStateNormal];
    [firstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    firstBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [firstBtn setBackgroundColor:RGBColor(16, 101, 182, 1.0)];
    firstBtn.layer.mask = [DisplayUtils cornerRadiusGraph:firstBtn withSize:CGSizeMake(firstBtn.current_h/2, firstBtn.current_h/2)];
    [firstBtn addTarget:self action:@selector(firstBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstBtn];
}

#pragma mark - 点击事件
-(void)firstBtnAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you ready?" message:@"Now you're ready to get your first inspiration." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TrainingFirstViewController *firstVC = [[TrainingFirstViewController alloc] init];
        [self.navigationController pushViewController:firstVC animated:YES];
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
