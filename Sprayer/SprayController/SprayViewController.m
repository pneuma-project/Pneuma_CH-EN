//
//  SprayViewController.m
//  Sprayer
//
//  Created by FangLin on 17/2/27.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "SprayViewController.h"
#import "JHChartHeader.h"
#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
@interface SprayViewController ()

@end

@implementation SprayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:[DisplayUtils getTimestampData]];
    [self showFirstQuardrant];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = RGBColor(240, 248, 252, 1.0);
}
-(void)setNavTitle:(NSString *)title
{
    UIView * titileBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 44)];
    UIImageView *  leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 10, 15)];
    leftImgView.image = [UIImage imageNamed:@"icon-back"];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(leftImgView.current_x_w, 0, 60, titileBgView.current_h)];
    label.text=NSLocalizedString(title, nil);
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:19];
    UIImageView * rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(label.current_x_w, 15, 10, 15)];
    rightImgView.image = [UIImage imageNamed:@"spray-icon--选择日期"];
    [titileBgView addSubview:leftImgView];
    [titileBgView addSubview:label];
    [titileBgView addSubview:rightImgView];
    self.navigationItem.titleView = titileBgView;
    
}

- (void)showFirstQuardrant{
    UIView * upBgView = [[UIView alloc]initWithFrame:CGRectMake(10, 74, screen_width-20, (screen_height-64-tabbarHeight)/2-20)];
    upBgView.layer.cornerRadius = 3.0;
    upBgView.backgroundColor = [UIColor whiteColor];
    
    NSString * str = @"Reference Total Volume:";
    CGSize strSize = [DisplayUtils stringWithWidth:str withFont:12];
    UILabel * referenceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,strSize.width, strSize.height)];
    referenceLabel.font = [UIFont systemFontOfSize:12];
    referenceLabel.textColor = RGBColor(0, 64, 181, 1.0);
    referenceLabel.text = str;
    
    UILabel * referenceInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(referenceLabel.current_x_w+5, 10, 50,strSize.height)];
    referenceInfoLabel.textColor = RGBColor(0, 64, 181, 1.0);
    referenceInfoLabel.font = [UIFont systemFontOfSize:15];
    referenceInfoLabel.text = @"4.2L";
    
    NSString * str1 = @"Current Total Volume:";
    strSize = [DisplayUtils stringWithWidth:str1 withFont:12];
    UILabel * currentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, referenceLabel.current_y_h, strSize.width, strSize.height)];
    currentLabel.font = [UIFont systemFontOfSize:12];
    currentLabel.textColor = RGBColor(0, 64, 181, 1.0);
    currentLabel.text = str1;
    UILabel * currentInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(currentLabel.current_x_w+5, referenceInfoLabel.current_y_h, 50, strSize.height)];
    currentInfoLabel.text = @"4.2L";
    currentInfoLabel.textColor = RGBColor(0, 64, 181, 1.0);
    currentInfoLabel.font = [UIFont systemFontOfSize:15];
    
    UILabel * trainLabel = [[UILabel alloc]initWithFrame:CGRectMake(upBgView.current_w-55, 10, 55, strSize.height)];
    trainLabel.text = @"Training";
    trainLabel.textColor = RGBColor(238, 146, 1, 1.0);
    trainLabel.font = [UIFont systemFontOfSize:12];
    UIView * trainView = [[UIView alloc]initWithFrame:CGRectMake(trainLabel.current_x-15, 15, 10, 3)];
    CGPoint trainPoint = trainView.center;
    trainPoint.y = trainLabel.center.y;
    trainView.center = trainPoint;
    trainView.backgroundColor = RGBColor(238, 146, 1, 1.0);
    UILabel * sprayLabel = [[UILabel alloc]initWithFrame:CGRectMake(trainLabel.current_x, trainLabel.current_y_h, 55, strSize.height)];
    sprayLabel.text = @"Spray";
    sprayLabel.textColor = RGBColor(0, 83, 181, 1.0);
    sprayLabel.font = [UIFont systemFontOfSize:12];
    UIView * sprayView = [[UIView alloc]initWithFrame:CGRectMake(sprayLabel.current_x-15, 15, 10, 3)];
    CGPoint sprayPoint = sprayView.center;
    sprayPoint.y = sprayLabel.center.y;
    sprayView.center = sprayPoint;
    sprayView.backgroundColor = RGBColor(0, 83, 181, 1.0);
    
    
    UILabel * slmLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, currentLabel.current_y_h+15, 50, 15)];
    slmLabel.text = @"SLM";
    slmLabel.font = [UIFont systemFontOfSize:12];
    slmLabel.textColor = RGBColor(221, 222, 223, 1.0);
    /*     创建第一个折线图       */
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(5, slmLabel.current_y_h, upBgView.current_w-25, upBgView.current_h-slmLabel.current_y_h) andLineChartType:JHChartLineValueNotForEveryX];
    lineChart.xLineDataArr = @[@"0",@"0.5",@"1.0",@"1.5",@"2.0",@"2.5",@"3.0"];
    lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    
    lineChart.valueArr = @[@[@"0",@"80",@"90",@"120",@"80",@"20",@"0"],@[@"0",@"40",@"100",@"160",@"100",@"60",@"0"]];
    lineChart.showYLevelLine = YES;
    lineChart.showYLine = NO;
    lineChart.showValueLeadingLine = NO;
    lineChart.valueFontSize = 0.0;

    lineChart.backgroundColor = [UIColor whiteColor];
    /* Line Chart colors */
    lineChart.valueLineColorArr =@[ RGBColor(0, 83, 181, 1.0), RGBColor(238, 146, 1, 1.0)];
    /* Colors for every line chart*/
    lineChart.pointColorArr = @[[UIColor blueColor],[UIColor orangeColor]];
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
    [upBgView addSubview:referenceLabel];
    [upBgView addSubview:referenceInfoLabel];
    [upBgView addSubview:currentLabel];
    [upBgView addSubview:currentInfoLabel];
    [upBgView addSubview:slmLabel];
    [upBgView addSubview:trainView];
    [upBgView addSubview:trainLabel];
    [upBgView addSubview:sprayView];
    [upBgView addSubview:sprayLabel];
    [upBgView addSubview:lineChart];
    [self.view addSubview:upBgView];
    [lineChart showAnimation];
    
    /*创建第二个柱状图 */
    UIView * downBgView = [[UIView alloc]initWithFrame:CGRectMake(10, upBgView.current_y_h+10, screen_width-20,(screen_height-64-tabbarHeight)/2-20)];
    downBgView.backgroundColor = [UIColor whiteColor];
    UIView * pointView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 8, 8)];
    pointView.backgroundColor = RGBColor(0, 83, 181, 1.0);
    pointView.layer.cornerRadius = 4.0;
    pointView.layer.masksToBounds = 4.0;
    UILabel *inspirationLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointView.current_x_w+5, 10, screen_width-pointView.current_x_w, 15)];
    inspirationLabel.text = @"Inspiration Volume Distribution";
    inspirationLabel.textColor = RGBColor(0, 83, 181, 1.0);
    CGPoint insPoint = pointView.center;
    insPoint.y = inspirationLabel.center.y;
    pointView.center = insPoint;
    
    UILabel * totalInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(downBgView.current_w-60, inspirationLabel.current_y+15, 60, 30)];
    totalInfoLabel.text = @"22.3L";
    totalInfoLabel.textAlignment = NSTextAlignmentLeft;
    totalInfoLabel.textColor = RGBColor(0, 83, 181, 1.0);
    totalInfoLabel.font = [UIFont systemFontOfSize:16];
    UILabel * totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(totalInfoLabel.current_x-40, inspirationLabel.current_y_h+8,40,15)];
    totalLabel.text = @"Total:";
    totalLabel.textAlignment = NSTextAlignmentRight;
    totalLabel.font = [UIFont systemFontOfSize:12];
    totalLabel.textColor = RGBColor(0, 83, 181, 1.0);
    UILabel * unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointView.current_x, totalLabel.current_y_h+5, 35, 15)];
    unitLabel.text = @"Unit:L";
    unitLabel.font = [UIFont systemFontOfSize:12];
    unitLabel.textColor = RGBColor(203, 204, 205, 1.0);
    
    UILabel * yLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(unitLabel.current_x_w, unitLabel.current_y_h+10, 1, downBgView.current_h-unitLabel.current_y_h-40)];
    yLineLabel.backgroundColor = RGBColor(204, 205, 206, 1.0);
    
    for (int i =0; i<7; i++) {
        UILabel * yNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(yLineLabel.current_x-25,unitLabel.current_y_h+i*(yLineLabel.current_h/6), 20, 15)];
        yNumLabel.textColor = RGBColor(204, 205, 206, 1.0);
        yNumLabel.textAlignment = NSTextAlignmentRight;
        yNumLabel.text = [NSString stringWithFormat:@"%d",30-i*5];
        yNumLabel.font = [UIFont systemFontOfSize:12];
        [downBgView addSubview:yNumLabel];
 
    }
    UILabel * xLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(yLineLabel.current_x_w, yLineLabel.current_y_h, downBgView.current_w-yLineLabel.current_x_w-30, 1)];
    xLineLabel.backgroundColor = RGBColor(204, 205, 206, 1.0);
    UILabel * downDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(yLineLabel.current_x_w+xLineLabel.current_w/2-35, xLineLabel.current_y_h, 70, 30)];
    downDateLabel.text = [DisplayUtils getTimestampData];
    downDateLabel.textColor = RGBColor(0, 83, 181, 1.0);
    downDateLabel.font = [UIFont systemFontOfSize:10];
    
    int viewH = 0;
    NSArray * numberArr = @[@"4",@"15",@"17",@"9"];
    for (int i=0; i<numberArr.count; i++) {
        viewH+=[numberArr[i] floatValue]/5 * yLineLabel.current_y/6;
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(downDateLabel.current_x+15, xLineLabel.current_y-viewH, downDateLabel.current_w-30,[numberArr[i] floatValue]/5 * yLineLabel.current_y/6)];
        
        if (i%2==0) {
            view.backgroundColor = RGBColor(0, 83, 181, 1.0);
        }else
        {
            view.backgroundColor = RGBColor(238, 146, 1, 1.0);
        }
        [downBgView addSubview:view];
    }
    
    UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(xLineLabel.current_x_w, xLineLabel.current_y_h-10, downBgView.current_w-xLineLabel.current_x_w, 20)];
    dateLabel.text = @"Date";
    dateLabel.textColor = RGBColor(204, 205, 206, 1.0);
    dateLabel.font = [UIFont systemFontOfSize:12];
    
    [downBgView addSubview:dateLabel];
    [downBgView addSubview:downDateLabel];
    [downBgView addSubview:xLineLabel];
    [downBgView addSubview:yLineLabel];
    [downBgView addSubview:unitLabel];
    [downBgView addSubview:totalLabel];
    [downBgView addSubview:totalInfoLabel];
    [downBgView addSubview:pointView];
    [downBgView addSubview:inspirationLabel];
    [self.view addSubview:downBgView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
