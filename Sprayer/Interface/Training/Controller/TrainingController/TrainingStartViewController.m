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
#import "UserDefaultsUtils.h"
#import "FLWrapJson.h"
#import "FLDrawDataTool.h"

@interface TrainingStartViewController ()<CustemBBI>
{
    NSData *timeData;
}

@property (nonatomic,strong)FLChartView *chartView;

@property (nonatomic,strong)NSTimer *timer;
@end

@implementation TrainingStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:NSLocalizedString(@"Inspiratory Training", nil)];
    [self createView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"first"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopNSTimerAction) name:@"stopTrain" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectAction) name:PeripheralDidConnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleConnectSucceedAction) name:ConnectSucceed object:nil]; //设备连接成功扫描到特征值
}

-(void)dealloc{
    if (self.timer != nil) {
        [self.timer setFireDate:[NSDate distantFuture]];
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)stopNSTimerAction
{
    if (self.timer != nil) {
           [self.timer setFireDate:[NSDate distantFuture]];
           [self.timer invalidate];
           self.timer = nil;
    }
}

-(void)disconnectAction
{
    if (self.timer != nil) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

//蓝牙连接成功
-(void)bleConnectSucceedAction
{
    if (self.timer != nil) {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建UI
-(void)createView
{
    //详细说明
    UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, kSafeAreaTopHeight + 15, screen_width-40, 30)];
    desLabel.text = NSLocalizedString(@"Training Description", nil);
    desLabel.textColor = RGBColor(8, 86, 184, 1.0);
    desLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:desLabel];
    
    NSString *detailStr = NSLocalizedString(@"Training Description Detail", nil);
    CGSize detailSize = [DisplayUtils stringWithWidth:detailStr withFont:12];
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, desLabel.current_y_h, screen_width-40, detailSize.height+60)];
    detailLabel.text = detailStr;
    detailLabel.textColor = RGBColor(8, 86, 184, 1.0);
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:detailLabel];
    
    //第一次训练按钮
    UIButton *firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    firstBtn.frame = CGRectMake(50, 0, screen_width-100, 40);
    firstBtn.center = CGPointMake(screen_width/2, detailLabel.current_y_h+(self.view.current_h-detailLabel.current_y_h-tabbarHeight)/2);
    [firstBtn setTitle:NSLocalizedString(@"The First Training", nil) forState:UIControlStateNormal];
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
    if ([UserDefaultsUtils boolValueWithKey:@"isConnect"] == YES) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Are you ready", nil) message:NSLocalizedString(@"Now you're ready to get your first inspiration", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Wait a minute", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"YES", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"startTrain" object:nil userInfo:nil];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(writeDataAction) userInfo:nil repeats:YES];
            TrainingFirstViewController *firstVC = [[TrainingFirstViewController alloc] init];
            [self.navigationController pushViewController:firstVC animated:YES];
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Reminder", nil) message:NSLocalizedString(@"The device is not connected", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)writeDataAction
{
    long long time = [DisplayUtils getNowTimestamp];
    timeData = [FLDrawDataTool longToNSData:time];
    [BlueWriteData startTrainData:timeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
