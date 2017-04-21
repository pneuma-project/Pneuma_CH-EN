//
//  DeviceViewController.m
//  Sprayer
//
//  Created by FangLin on 17/2/28.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "DeviceViewController.h"
#import "lhScanQCodeViewController.h"
#import "DeviceStatusViewController.h"
#import "HistoricalDrugViewController.h"
#import "SqliteUtils.h"
#import "FLWrapJson.h"
#import "UserDefaultsUtils.h"
@interface DeviceViewController ()
{
    BlueToothManager *blueManager;
    NSData *timeData;
}
@property (weak, nonatomic) IBOutlet UILabel *serialLabel;
@property (weak, nonatomic) IBOutlet UIButton *isOnlineBtn;
@property (weak, nonatomic) IBOutlet UIButton *deviceConnectBtn;
@property (nonatomic,strong)NSTimer *timer;
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"MY DEVICE"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleIsOpenAction) name:BleIsOpen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectAction) name:PeripheralDidConnect object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopNSTimerAction) name:@"startTrain" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopNSTimerAction) name:@"sparyModel" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:BleIsOpen object:nil];
}

-(void)bleIsOpenAction
{
//    DeviceStatusViewController *deviceStatusVC = [[DeviceStatusViewController alloc] init];
//    [self.navigationController pushViewController:deviceStatusVC animated:YES];
    [self.isOnlineBtn setImage:[UIImage imageNamed:@"device-butn-on"] forState:UIControlStateNormal];
    NSString *time = [DisplayUtils getTimeStampWeek];
    NSString *weakDate = [DisplayUtils getTimestampDataWeek];
    NSMutableString *allStr = [[NSMutableString alloc] initWithString:time];
    [allStr insertString:weakDate atIndex:10];
    timeData = [FLWrapJson bcdCodeString:allStr];
    if ([UserDefaultsUtils boolValueWithKey:@"AutoConnect"] == NO) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(writeDataAction) userInfo:nil repeats:YES];
    }
}

-(void)writeDataAction
{
    //写数据到蓝牙
    [BlueWriteData bleConfigWithData:timeData];
}

-(void)stopNSTimerAction
{
    [self.timer invalidate];
}

-(void)disconnectAction
{
    [self.isOnlineBtn setImage:[UIImage imageNamed:@"device-butn-off"] forState:UIControlStateNormal];
    [self.timer invalidate];
}

#pragma mark - 扫描点击事件
-(void)MenuDidClick
{
    NSLog(@"点击扫描");
    lhScanQCodeViewController *scanVC = [[lhScanQCodeViewController alloc] init];
    [self.navigationController pushViewController:scanVC animated:YES];
}
- (IBAction)DeviceConnectionAction:(id)sender {
    NSArray * arr = [[SqliteUtils sharedManager]selectUserInfo];
    if (arr.count == 0) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoLogin" object:nil userInfo:nil];
        return;
    }
    blueManager = [BlueToothManager getInstance];
    [blueManager startScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
