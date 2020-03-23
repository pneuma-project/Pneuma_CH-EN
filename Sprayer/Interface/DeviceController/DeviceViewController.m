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
#import "PatientInfoViewController.h"
#import "FLDrawDataTool.h"
#import "Pneuma-Swift.h"

@interface DeviceViewController ()
{
    BlueToothManager *blueManager;
    NSData *timeData;
}
@property (weak, nonatomic) IBOutlet UILabel *serialLabel;
@property (weak, nonatomic) IBOutlet UIButton *isOnlineBtn;
@property (weak, nonatomic) IBOutlet UIButton *deviceConnectBtn;
@property (nonatomic,strong)NSTimer *timer;    //发送上电信息定时器
@property (nonatomic,strong)NSTimer *medicineInfoTimer;   //发送药品信息定时器

@property(nonatomic,strong)BlueDeviceListView *blueView;  //蓝牙设备列表视图

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviceImgBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviceBtnBottom;

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:NSLocalizedString(@"MY DEVICE", nil)];
    [self setLayoutConstraint];
//    self.medicineInfoTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(writeInquireMedicineInfo) userInfo:nil repeats:YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(writePowerInfoDataAction) userInfo:nil repeats:YES];
    
//    _blueView = [[BlueDeviceListView alloc] init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDeviceAction:) name:@"scanDevice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleConnectSucceedAction) name:ConnectSucceed object:nil]; //设备连接成功扫描到特征值
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectAction) name:PeripheralDidConnect object:nil];//设备断开连接
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayMedicineInfoAction:) name:@"displayMedicineInfo" object:nil]; //展示药品信息

    if ([UserDefaultsUtils boolValueWithKey:@"isConnect"] == YES) {
//        if ([UserDefaultsUtils boolValueWithKey:IsDisplayMedInfo] == NO){
//            [self.timer setFireDate:[NSDate distantFuture]];
//            [self.medicineInfoTimer setFireDate:[NSDate distantPast]];
//        }else {
            [self.timer setFireDate:[NSDate distantPast]];
//            [self.medicineInfoTimer setFireDate:[NSDate distantFuture]];
//        }
    }else {
        [self.timer setFireDate:[NSDate distantFuture]];
//        [self.medicineInfoTimer setFireDate:[NSDate distantFuture]];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /** 检测本地是否保存有用户 */
//    [self noUserAlert];
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopNSTimerAction) name:@"startTrain" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"self = %@",self.timer);
    [self.timer setFireDate:[NSDate distantFuture]];
//    [self.medicineInfoTimer setFireDate:[NSDate distantFuture]];
}

-(void)setLayoutConstraint {
    _topViewTop.constant = kSafeAreaTopHeight;
    _deviceImgBottom.constant = kTabbarHeight;
    _deviceBtnBottom.constant = 36.0+kTabbarHeight;
}

#pragma mark - 没有用户时的弹窗
- (void)noUserAlert
{
    NSArray *userArray = [[SqliteUtils sharedManager] selectUserInfo];
    if (userArray.count == 0) {
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:@"Prompt" message:@"This APP has no users. Please go ahead and add users" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alerVC removeFromParentViewController];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            PatientInfoViewController *VC = [[PatientInfoViewController alloc]init];
            [self.navigationController pushViewController:VC animated:YES];
        }];
        [alerVC addAction:action1];
        [alerVC addAction:action2];
        [self presentViewController:alerVC animated:YES completion:nil];
    }
}

#pragma mark - 接收到通知的方法
//搜索设备列表
-(void)searchDeviceAction:(NSNotification *)notification
{
    NSDictionary *infoDict = notification.object;
    NSArray *deviceList = infoDict[@"DeviceList"];
    self.blueView.dataList = deviceList;
}

//蓝牙连接成功
-(void)bleConnectSucceedAction
{
    [self.isOnlineBtn setImage:[UIImage imageNamed:@"device-butn-on"] forState:UIControlStateNormal];
//    [self.medicineInfoTimer setFireDate:[NSDate distantPast]];
    [self.timer setFireDate:[NSDate distantPast]];
//    [UserDefaultsUtils saveBoolValue:NO withKey:IsDisplayMedInfo];
}

//开始训练，停止定时器
-(void)stopNSTimerAction
{
    [self.timer setFireDate:[NSDate distantFuture]];
//    [self.medicineInfoTimer setFireDate:[NSDate distantFuture]];
}

//蓝牙失去连接
-(void)disconnectAction
{
//    [UserDefaultsUtils saveBoolValue:NO withKey:IsDisplayMedInfo];
    [self.isOnlineBtn setImage:[UIImage imageNamed:@"device-butn-off"] forState:UIControlStateNormal];
    [self.timer setFireDate:[NSDate distantFuture]];
//    [self.medicineInfoTimer setFireDate:[NSDate distantFuture]];
}

//展示药品名称
-(void)displayMedicineInfoAction:(NSNotification *)notification
{
    [UserDefaultsUtils saveBoolValue:YES withKey:IsDisplayMedInfo];
    [self.medicineInfoTimer setFireDate:[NSDate distantFuture]];
    [self.timer setFireDate:[NSDate distantPast]];
//    NSDictionary *infoDict = notification.object;
//    NSString *medicineInfo = infoDict[@"medicineInfo"];
//    [UserDefaultsUtils saveValue:medicineInfo forKey:@"MedicineInfo"];
//    UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:nil message:medicineInfo preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.timer setFireDate:[NSDate distantPast]];
//    }];
//    [alerVC addAction:action1];
//    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:medicineInfo];
//    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
//    [ps setAlignment:NSTextAlignmentLeft];
//    [alertControllerMessageStr addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, medicineInfo.length)];
//    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, medicineInfo.length)];
//    [alerVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
//    [self presentViewController:alerVC animated:YES completion:nil];
}

#pragma mark - 写入数据
//上电信息
-(void)writePowerInfoDataAction
{
    //写数据到蓝牙
//    NSString *time = [DisplayUtils getTimeStampWeek];
//    NSString *weakDate = [DisplayUtils getTimestampDataWeek];
//    NSMutableString *allStr = [[NSMutableString alloc] initWithString:time];
//    [allStr insertString:weakDate atIndex:10];
//    timeData = [FLWrapJson bcdCodeString:allStr];
    long long time = [DisplayUtils getNowTimestamp];
    timeData = [FLDrawDataTool longToNSData:time];
    [BlueWriteData bleConfigWithData:timeData];
}
//查询药品信息
-(void)writeInquireMedicineInfo
{
    long long time = [DisplayUtils getNowTimestamp];
    timeData = [FLDrawDataTool longToNSData:time];
    [BlueWriteData inquireCurrentDrugInfo:timeData];
}

#pragma mark - 扫描点击事件
-(void)MenuDidClick
{
    NSLog(@"点击扫描");
    lhScanQCodeViewController *scanVC = [[lhScanQCodeViewController alloc] init];
    [self.navigationController pushViewController:scanVC animated:YES];
}
- (IBAction)DeviceConnectionAction:(id)sender {
//    NSArray * arr = [[SqliteUtils sharedManager]selectUserInfo];
//    if (arr.count == 0) {
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoLogin" object:nil userInfo:nil];
//        return;
//    }
    blueManager = [BlueToothManager getInstance];
    [blueManager startScan];
//    [_blueView animationshowWithIsCenter:false];
}


@end
