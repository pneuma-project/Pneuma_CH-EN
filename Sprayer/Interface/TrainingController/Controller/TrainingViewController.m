//
//  TrainingViewController.m
//  Sprayer
//
//  Created by FangLin on 17/2/27.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "TrainingViewController.h"
#import "FL_ScaleCircle.h"
#import "FLChartView.h"
#import "TrainingStartViewController.h"
#import "RetrainingViewController.h"
#import "SqliteUtils.h"
#import "AddPatientInfoModel.h"
#import "UserDefaultsUtils.h"
#import "Pneuma-Swift.h"

@interface TrainingViewController ()
{
    UIView *view;
    UIImageView *bgImageView;
    UILabel *totalLabel;
    
    UIView *footView;
    UIView *chatBgView;
    int allTrainNum;
    float allTrain;
    
    NSArray *dataArr;
    
    BOOL isTrain;
    
    UIButton *startBtn;
    UIButton *lungTestBtn;
}

@property (nonatomic,strong)FL_ScaleCircle *circleView;
@property (nonatomic,strong)FLChartView *chartView;

@property(nonatomic,strong)NSMutableArray * yNumArr;

@end

@implementation TrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:NSLocalizedString(@"Inspiratory Training", nil)];
    self.yNumArr = [NSMutableArray array];
    [self setInterface];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestTrainData];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"transparent"]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = RGBColor(0, 83, 181, 1.0);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
}

-(void)setInterface {
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height/2)];
    [self.view addSubview:view];
    
    //背景图片
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height/2)];
    bgImageView.image = [UIImage imageNamed:@"my-profile-bg"];
    [view addSubview:bgImageView];
    
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, view.current_y_h, screen_width, screen_height/2)];
    footView.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self.view addSubview:footView];
    
    chatBgView = [[UIView alloc] initWithFrame:CGRectMake(10, -50, screen_width-20, screen_height/2-50-tabbarHeight)];
    chatBgView.backgroundColor = RGBColor(254, 255, 255, 1.0);
    chatBgView.layer.mask = [DisplayUtils cornerRadiusGraph:chatBgView withSize:CGSizeMake(5, 5)];
    [footView addSubview:chatBgView];
    
    //图标题
    UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 5, 5)];
    pointImageView.center = CGPointMake(10, 25);
    pointImageView.backgroundColor = RGBColor(0, 83, 181, 1.0);
    pointImageView.layer.mask = [DisplayUtils cornerRadiusGraph:pointImageView withSize:CGSizeMake(pointImageView.current_w/2, pointImageView.current_h/2)];
    [chatBgView addSubview:pointImageView];
    
    NSString *titleStr = NSLocalizedString(@"The last best inspiration", nil);
    CGSize size = [DisplayUtils stringWithWidth:titleStr withFont:17];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(pointImageView.current_x_w+10, 5, size.width, 40)];
    titleLabel.text = titleStr;
    titleLabel.textColor = RGBColor(8, 86, 184, 1.0);
    [chatBgView addSubview:titleLabel];
    
    //单位
    totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.current_x_w, 15, chatBgView.current_w-titleLabel.current_x_w-10, 35)];
    totalLabel.textAlignment = NSTextAlignmentRight;
    totalLabel.textColor = RGBColor(8, 86, 184, 1.0);
    totalLabel.font = [UIFont systemFontOfSize:18];
//    NSInteger strlength = [NSString stringWithFormat:@"%.1fL",allTrain].length;
//    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%.1fL",NSLocalizedString(@"Total", nil),allTrain]];
//    [AttributedStr addAttribute:NSFontAttributeName
//                          value:[UIFont systemFontOfSize:13]
//                          range:NSMakeRange(0, 2)];
//    [AttributedStr addAttribute:NSFontAttributeName
//                          value:[UIFont systemFontOfSize:20]
//                          range:NSMakeRange(2, strlength)];
//    totalLabel.attributedText = AttributedStr;
    totalLabel.text = [NSString stringWithFormat:@"%@%.1fL",NSLocalizedString(@"Total", nil),allTrain];
    [chatBgView addSubview:totalLabel];
    
    //吸雾训练按钮
    startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(20, 0, (screen_width/2)-40, 40);
    startBtn.center = CGPointMake(screen_width/4, chatBgView.current_y_h+(footView.current_h-chatBgView.current_y_h-kTabbarHeight)/2);
    if (isTrain == NO) {
        [startBtn setTitle:NSLocalizedString(@"Start Training", nil) forState:UIControlStateNormal];
    }else{
        [startBtn setTitle:NSLocalizedString(@"Restart Training", nil) forState:UIControlStateNormal];
    }
    startBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [startBtn setBackgroundColor:RGBColor(16, 101, 182, 1.0)];
    startBtn.layer.mask = [DisplayUtils cornerRadiusGraph:startBtn withSize:CGSizeMake(startBtn.current_h/2, startBtn.current_h/2)];
    [startBtn addTarget:self action:@selector(startBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:startBtn];
    
    //肺功能测试按钮
    lungTestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lungTestBtn.frame = CGRectMake(startBtn.current_x_w+40, 0, (screen_width/2)-40, 40);
    lungTestBtn.center = CGPointMake((screen_width/4)*3, chatBgView.current_y_h+(footView.current_h-chatBgView.current_y_h-kTabbarHeight)/2);
    [lungTestBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    lungTestBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [lungTestBtn setTitle:NSLocalizedString(@"Pulmonary Function Test", nil) forState:UIControlStateNormal];
    [lungTestBtn setBackgroundColor:RGBColor(16, 101, 182, 1.0)];
    lungTestBtn.layer.mask = [DisplayUtils cornerRadiusGraph:lungTestBtn withSize:CGSizeMake(lungTestBtn.current_h/2, lungTestBtn.current_h/2)];
    [lungTestBtn addTarget:self action:@selector(lungTestBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:lungTestBtn];
}


- (void)requestTrainData
{
    [DeviceRequestObject.shared requestGetNewTrainData];
//    __weak typeof(self) weakSelf = self;
    [DeviceRequestObject.shared setRequestGetNewTrainDataSuc:^(SprayerDataModel * _Nonnull model) {
        [self.yNumArr removeAllObjects];
        if ([model.suckFogData isEqualToString:@""]) {
            isTrain = NO;
            [startBtn setTitle:NSLocalizedString(@"Start Training", nil) forState:UIControlStateNormal];
        }else{
            isTrain = YES;
            [startBtn setTitle:NSLocalizedString(@"Restart Training", nil) forState:UIControlStateNormal];
        }
        NSArray *mutArr = [model.suckFogData componentsSeparatedByString:@","];
        allTrain = model.dataSum;
        dataArr = mutArr;
        //得出y轴的坐标轴
        for (int i =8; i>=0;i--) {
            [self.yNumArr addObject:[NSString stringWithFormat:@"%d",i*20]];
        }
        //total值
        totalLabel.text = [NSString stringWithFormat:@"%@%.1fL",NSLocalizedString(@"Total", nil),allTrain];
        
        for (UIView *subview in bgImageView.subviews) {
            [subview removeFromSuperview];
        }
        for (UIView *subview in chatBgView.subviews) {
            if ([subview isKindOfClass:[FLChartView class]]) {
                [subview removeFromSuperview];
            }
        }
        [self createHeadView];
        [self createFootView];
    }];
}

-(void)createHeadView
{
    self.circleView = [[FL_ScaleCircle alloc] initWithFrame:CGRectMake(0, 0, screen_width/2-10, screen_width/2-10)];
    self.circleView.center = CGPointMake(screen_width/2, bgImageView.current_h/2);
    self.circleView.number = [NSString stringWithFormat:@"%.1fL",allTrain];
    self.circleView.lineWith = 7.0;
    [bgImageView addSubview:self.circleView];
}

-(void)createFootView
{
    self.chartView = [[FLChartView alloc]initWithFrame:CGRectMake(0, 30, chatBgView.current_w, chatBgView.current_h-30)];
    self.chartView.backgroundColor = [UIColor clearColor];
    self.chartView.titleOfYStr = @"SLM";
    self.chartView.titleOfXStr = @"Sec";
    self.chartView.leftDataArr = dataArr;
    self.chartView.dataArrOfY = _yNumArr;//拿到Y轴坐标
    self.chartView.dataArrOfX = @[@"0",@"0.1",@"0.2",@"0.3",@"0.4",@"0.5",@"0.6",@"0.7",@"0.8",@"0.9",@"1.0",@"1.1",@"1.2",@"1.3",@"1.4",@"1.5",@"1.6",@"1.7",@"1.8",@"1.9",@"2.0",@"2.1",@"2.2",@"2.3",@"2.4",@"2.5",@"2.6",@"2.7",@"2.8",@"2.9",@"3.0",@"3.1",@"3.2",@"3.3",@"3.4",@"3.5",@"3.6",@"3.7",@"3.8",@"3.9",@"4.0",@"4.1",@"4.2",@"4.3",@"4.4",@"4.5",@"4.6",@"4.7",@"4.8",@"4.9",@"5.0"];//拿到X轴坐标
    [chatBgView addSubview:self.chartView];
}

#pragma mark - 点击事件
-(void)startBtnAction
{
    TrainingStartViewController *trainingStartVC = [[TrainingStartViewController alloc] init];
    [self.navigationController pushViewController:trainingStartVC animated:YES];
}

-(void)lungTestBtnAction
{
    SLungTestTipController *slungTipVC = [[SLungTestTipController alloc] init];
    [self.navigationController pushViewController:slungTipVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
