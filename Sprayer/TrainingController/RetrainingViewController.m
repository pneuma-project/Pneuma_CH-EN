//
//  RetrainingViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/3.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "RetrainingViewController.h"
#import "JHChartHeader.h"
@interface RetrainingViewController ()<CustemBBI>
{
    CGFloat  thirdVolumeH;
}
@end

@implementation RetrainingViewController

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
    self.navigationItem.rightBarButtonItem = [CustemNavItem initWithString:@"Save" andTarget:self andinfoStr:@"first"];
}

#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)createView
{
    UIView * upBgView = [[UIView alloc]initWithFrame:CGRectMake(10, 74, screen_width-20, (screen_height-64-tabbarHeight)/2-20)];
    upBgView.layer.cornerRadius = 3.0;
    upBgView.backgroundColor = [UIColor whiteColor];
    
    UILabel * slmLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 50, 15)];
    slmLabel.text = @"SLM";
    slmLabel.font = [UIFont systemFontOfSize:12];
    slmLabel.textColor = RGBColor(221, 222, 223, 1.0);
    /*     创建第一个折线图       */
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(5, slmLabel.current_y_h, upBgView.current_w-25, upBgView.current_h-slmLabel.current_y_h) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart.xLineDataArr = @[@"0",@"0.5",@"1.0",@"1.5",@"2.0",@"2.5",@"3.0"];
    lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    
    lineChart.valueArr = @[@[@"0",@"80",@"90",@"120",@"80",@"20",@"0"],@[@"0",@"40",@"100",@"160",@"100",@"60",@"0"],@[@"0",@"30",@"70",@"140",@"160",@"120",@"0"]];
    lineChart.showYLevelLine = YES;
    lineChart.showYLine = NO;
    lineChart.showValueLeadingLine = NO;
    lineChart.valueFontSize = 0.0;
    
    lineChart.backgroundColor = [UIColor whiteColor];
    /* Line Chart colors */
    lineChart.valueLineColorArr =@[ RGBColor(0, 83, 181, 1.0), RGBColor(238, 146, 1, 1.0),RGBColor(1, 238, 191, 1.0)];
    /* Colors for every line chart*/
    lineChart.pointColorArr = @[[UIColor clearColor],[UIColor clearColor],[UIColor clearColor]];
    /* color for XY axis */
    lineChart.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    lineChart.positionLineColorArr = @[[UIColor blueColor],[UIColor greenColor]];
    /*        Set whether to fill the content, the default is False         */
    lineChart.contentFill = YES;
    /*        Set whether the curve path         */
    lineChart.pathCurve = YES;
    /*        Set fill color array         */
    lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.0],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.0]];
    UILabel * SecLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineChart.current_x_w, lineChart.current_y_h-30, upBgView.current_w-lineChart.current_x_w, 20)];
    SecLabel.text = @"Sec";
    SecLabel.textColor = RGBColor(204, 205, 206, 1.0);
    SecLabel.font = [UIFont systemFontOfSize:10];
    
    [upBgView addSubview:SecLabel];
    [upBgView addSubview:slmLabel];
    [upBgView addSubview:lineChart];
    [self.view addSubview:upBgView];
    [lineChart showAnimation];
    
    UIView * downView = [[UIView alloc]initWithFrame:CGRectMake(upBgView.current_x, upBgView.current_y_h+10, upBgView.current_w,screen_height-tabbarHeight-74-upBgView.current_h-10)];
    downView.backgroundColor = [UIColor clearColor];
    
    NSArray * volumeArr = @[@"The first inspiratory volume",@"The second inspiratory volume",@"The third inspiratory volume"];
    NSArray * volumeInfoArr = @[@"4.2L",@"5.5L",@"5.5L"];
    NSArray * colorArr = @[ RGBColor(0, 83, 181, 1.0), RGBColor(238, 146, 1, 1.0),RGBColor(1, 238, 191, 1.0)];
    for (int i =0; i<3; i++) {
        UIView * colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 5+i*60, 25, 10)];
        colorView.backgroundColor = colorArr[i];
        UILabel * volumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(colorView.current_x_w+10, colorView.current_y, 180, 15)];
        CGPoint volumePoint = volumeLabel.center;
        volumePoint.y = colorView.center.y;
        volumeLabel.center = volumePoint;
        volumeLabel.font = [UIFont systemFontOfSize:12];
        volumeLabel.textAlignment = NSTextAlignmentLeft;
        volumeLabel.text = volumeArr[i];
        UILabel * volumeInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(volumeLabel.current_x, volumeLabel.current_y_h, 180, 40)];
        volumeInfoLabel.font = [UIFont systemFontOfSize:16];
        volumeInfoLabel.textAlignment = NSTextAlignmentLeft;
        volumeInfoLabel.text = [NSString stringWithFormat:@"Total volume: %@",volumeInfoArr[i]];
        thirdVolumeH = volumeInfoLabel.current_y_h;
        [downView addSubview:colorView];
        [downView addSubview:volumeLabel];
        [downView addSubview:volumeInfoLabel];
    }
    
    UIButton *RetrainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    RetrainBtn.frame = CGRectMake(50, thirdVolumeH+(downView.current_h-thirdVolumeH)/2, screen_width-100, 40);
    CGPoint btnCenter = RetrainBtn.center;
    btnCenter.y = thirdVolumeH+(downView.current_h-thirdVolumeH)/2;
    RetrainBtn.center = btnCenter;
    [RetrainBtn setTitle:@"Retraining" forState:UIControlStateNormal];
    [RetrainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RetrainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [RetrainBtn setBackgroundColor:RGBColor(16, 101, 182, 1.0)];
    RetrainBtn.layer.mask = [DisplayUtils cornerRadiusGraph:RetrainBtn withSize:CGSizeMake(RetrainBtn.current_h/2, RetrainBtn.current_h/2)];
    [RetrainBtn addTarget:self action:@selector(retrainClick) forControlEvents:UIControlEventTouchUpInside];
    
    [downView addSubview:RetrainBtn];
    [self.view addSubview:downView];
  
}
-(void)retrainClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
