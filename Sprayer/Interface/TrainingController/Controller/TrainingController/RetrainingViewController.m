//
//  RetrainingViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/3.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "RetrainingViewController.h"
#import "JHChartHeader.h"
#import "UserDefaultsUtils.h"
#import "SqliteUtils.h"
#import "AddPatientInfoModel.h"
#import "FLWrapJson.h"
#import "FLDrawDataTool.h"
#import "Pneuma-Swift.h"
#import "MagicalRecord.h"

@interface RetrainingViewController ()<CustemBBI>
{
    CGFloat  thirdVolumeH;
    int sum1;
    int sum2;
    int sum3;
    NSInteger index;
    NSData *timeData;
}

@end

@implementation RetrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    index = 100;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:[DisplayUtils getTimestampData:NSLocalizedString(@"TrainingNavHeadTimeFormat", nil)]];
    [self createView];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [UserDefaultsUtils saveValue:@[] forKey:@"trainDataArr"];
    [UserDefaultsUtils saveValue:@[] forKey:@"OneTrainDataArr"];
    [UserDefaultsUtils saveValue:@[] forKey:@"TwoTrainDataArr"];
    [UserDefaultsUtils saveValue:@[] forKey:@"ThreeTrainDataArr"];
    
    [UserDefaultsUtils saveValue:@[] forKey:@"trainTimeArr"];
    [UserDefaultsUtils saveValue:@"" forKey:@"OneTrainTimeArr"];
    [UserDefaultsUtils saveValue:@"" forKey:@"TwoTrainTimeArr"];
    [UserDefaultsUtils saveValue:@"" forKey:@"ThreeTrainTimeArr"];
    
    [UserDefaultsUtils saveValue:@[] forKey:@"medicineIdArr"];
    [UserDefaultsUtils saveValue:@"" forKey:@"OneMedicineIdArr"];
    [UserDefaultsUtils saveValue:@"" forKey:@"TwoMedicineIdArr"];
    [UserDefaultsUtils saveValue:@"" forKey:@"ThreeMedicineIdArr"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.rightBarButtonItem = [CustemNavItem initWithString:NSLocalizedString(@"Save", nil) andTarget:self andinfoStr:@"first"];
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"two"];
}

#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"first"]) {
        
        NSMutableArray * trainData = [NSMutableArray array];
        NSString *trainTime;
        NSString *medicineId;
        double trainSum = 0;
        if (index == 100) {
            trainData = [UserDefaultsUtils valueWithKey:@"OneTrainDataArr"];
            trainTime = [UserDefaultsUtils valueWithKey:@"OneTrainTimeArr"];
            medicineId = [UserDefaultsUtils valueWithKey:@"OneMedicineIdArr"];
        }else if (index == 101){
            trainData = [UserDefaultsUtils valueWithKey:@"TwoTrainDataArr"];
            trainTime = [UserDefaultsUtils valueWithKey:@"TwoTrainTimeArr"];
            medicineId = [UserDefaultsUtils valueWithKey:@"TwoMedicineIdArr"];
        }else if (index == 102){
            trainData =[UserDefaultsUtils valueWithKey:@"ThreeTrainDataArr"];
            trainTime = [UserDefaultsUtils valueWithKey:@"ThreeTrainTimeArr"];
            medicineId = [UserDefaultsUtils valueWithKey:@"ThreeMedicineIdArr"];
        }
        for (NSString * str in trainData) {
            trainSum += [str doubleValue];
        }
        NSString *trainDataStr = [trainData componentsJoinedByString:@","];
        NSString *dataSumValue = [NSString stringWithFormat:@"%.3lf",trainSum/600.0];
        [LCProgressHUD showLoadingText:NSLocalizedString(@"Uploading", nil)];
        [DeviceRequestObject.shared requestSaveTrainDataWithMedicineId:medicineId trainData:trainDataStr dataSum:[dataSumValue doubleValue] addDate:trainTime sucBlock:^(NSString * _Nonnull code) {
            if ([code isEqualToString:@"200"]) {
                [LCProgressHUD hide];
                [LCProgressHUD showSuccessText:NSLocalizedString(@"Upload success", nil)];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else {
                [LCProgressHUD hide];
                [LCProgressHUD showSuccessText:NSLocalizedString(@"Upload failed", nil)];
            }
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopTrain" object:nil userInfo:nil];
        [self writeDataAction];
    }else if ([infoStr isEqualToString:@"two"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopTrain" object:nil userInfo:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)writeDataAction
{
    long long time = [DisplayUtils getNowTimestamp];
    timeData = [FLDrawDataTool longToNSData:time];
    [BlueWriteData stopTrainData:timeData];
}

-(void)createView
{
    UIView * upBgView = [[UIView alloc]initWithFrame:CGRectMake(10, kSafeAreaTopHeight+10, screen_width-20, (screen_height-64-kTabbarHeight)/2-20)];
    upBgView.layer.cornerRadius = 3.0;
    upBgView.backgroundColor = [UIColor whiteColor];
    
    UILabel * slmLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 50, 15)];
    slmLabel.text = @"SLM";
    slmLabel.font = [UIFont systemFontOfSize:12];
    slmLabel.textColor = RGBColor(221, 222, 223, 1.0);
    /*     创建第一个折线图       */
    JHLineChart *lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(5, slmLabel.current_y_h, upBgView.current_w-25, upBgView.current_h-slmLabel.current_y_h) andLineChartType:JHChartLineValueNotForEveryX];
     lineChart.xLineDataArr = @[@"0",@"0.1",@"0.2",@"0.3",@"0.4",@"0.5",@"0.6",@"0.7",@"0.8",@"0.9",@"1.0",@"1.1",@"1.2",@"1.3",@"1.4",@"1.5",@"1.6",@"1.7",@"1.8",@"1.9",@"2.0",@"2.1",@"2.2",@"2.3",@"2.4",@"2.5",@"2.6",@"2.7",@"2.8",@"2.9",@"3.0",@"3.1",@"3.2",@"3.3",@"3.4",@"3.5",@"3.6",@"3.7",@"3.8",@"3.9",@"4.0",@"4.1",@"4.2",@"4.3",@"4.4",@"4.5",@"4.6",@"4.7",@"4.8",@"4.9",@"5.0"];//拿到X轴坐标
    lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;

    NSArray * mutArr = @[]; sum1 = 0;
    NSArray * mutArr1 = @[]; sum2 = 0;
    NSArray * mutArr2 = @[]; sum3 = 0;
   
    mutArr = [UserDefaultsUtils valueWithKey:@"OneTrainDataArr"];
    mutArr1 = [UserDefaultsUtils valueWithKey:@"TwoTrainDataArr"];
    mutArr2 = [UserDefaultsUtils valueWithKey:@"ThreeTrainDataArr"];
    
    
    for (NSString * str in mutArr) {
        sum1 += [str intValue];
    }
    for (NSString * str in mutArr1) {
        sum2+= [str intValue];
    }
    for (NSString * str in mutArr2) {
        sum3 += [str intValue];
    }
    if (mutArr.count != 0 && mutArr1.count != 0 && mutArr2.count != 0) {
        lineChart.valueArr = @[mutArr,mutArr1,mutArr2];
    }
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
    
    UIView * downView = [[UIView alloc]initWithFrame:CGRectMake(upBgView.current_x, upBgView.current_y_h+10, upBgView.current_w,screen_height-kTabbarHeight-74-upBgView.current_h-10)];
    
    downView.backgroundColor = [UIColor clearColor];
   
    
    NSArray * volumeArr = @[@"第一次训练",@"第二次训练",@"第三次训练"];
    NSArray * volumeInfoArr = @[[NSString stringWithFormat:@"%.1fL",sum1/600.0],[NSString stringWithFormat:@"%.1fL",sum2/600.0],[NSString stringWithFormat:@"%.1fL",sum3/600.0]];
    NSArray * colorArr = @[ RGBColor(0, 83, 181, 1.0), RGBColor(238, 146, 1, 1.0),RGBColor(1, 238, 191, 1.0)];
    for (int i =0; i<3; i++) {
        
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 5+i*60, 250, 50)];
        bgView.tag = 200+i;
        if (i==0) {
            bgView.backgroundColor = RGBColor(210, 238, 238, 1.0);
        }
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(saveBestData:)];
        tap.numberOfTapsRequired = 1;
        [bgView addGestureRecognizer:tap];
       
        UIView * colorView = [[UIView alloc]initWithFrame:CGRectMake(0, 5+i*60, 25, 10)];
        colorView.tag = 100+i;
        colorView.backgroundColor = colorArr[i];
        UILabel * volumeLabel = [[UILabel alloc]initWithFrame:CGRectMake(colorView.current_x_w+10, colorView.current_y, 180, 15)];
        CGPoint volumePoint = volumeLabel.center;
        volumePoint.y = colorView.center.y;
        volumeLabel.center = volumePoint;
        volumeLabel.font = [UIFont systemFontOfSize:12];
        volumeLabel.textAlignment = NSTextAlignmentLeft;
        volumeLabel.text = NSLocalizedString(volumeArr[i], nil);
        
        UILabel * volumeInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(volumeLabel.current_x, volumeLabel.current_y_h, 180, 40)];
        volumeInfoLabel.font = [UIFont systemFontOfSize:16];
        volumeInfoLabel.textAlignment = NSTextAlignmentLeft;
        volumeInfoLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Total volume", nil),volumeInfoArr[i]];
        thirdVolumeH = volumeInfoLabel.current_y_h;
        [downView addSubview:bgView];
        [downView addSubview:colorView];
        [downView addSubview:volumeLabel];
        [downView addSubview:volumeInfoLabel];
    }
    
    UIButton *RetrainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    RetrainBtn.frame = CGRectMake(50, thirdVolumeH+(downView.current_h-thirdVolumeH)/2, screen_width-100, 40);
    CGPoint btnCenter = RetrainBtn.center;
    btnCenter.y = thirdVolumeH+(downView.current_h-thirdVolumeH)/2;
    RetrainBtn.center = btnCenter;
    [RetrainBtn setTitle:NSLocalizedString(@"Retraining", nil) forState:UIControlStateNormal];
    [RetrainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RetrainBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [RetrainBtn setBackgroundColor:RGBColor(16, 101, 182, 1.0)];
    RetrainBtn.layer.mask = [DisplayUtils cornerRadiusGraph:RetrainBtn withSize:CGSizeMake(RetrainBtn.current_h/2, RetrainBtn.current_h/2)];
    [RetrainBtn addTarget:self action:@selector(retrainClick) forControlEvents:UIControlEventTouchUpInside];
    
    [downView addSubview:RetrainBtn];
    [self.view addSubview:downView];
  
}

-(void)saveBestData:(UITapGestureRecognizer *)tap
{
    for (int i = 200; i<203; i++) {
        UIView * view = [self.view viewWithTag:i];
        view.backgroundColor = [UIColor clearColor];
    }
    UIView * view = [self.view viewWithTag:tap.view.tag];
    view.backgroundColor = RGBColor(210, 238, 238, 1.0);
    index = tap.view.tag - 100;
}

-(void)retrainClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopTrain" object:nil userInfo:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
