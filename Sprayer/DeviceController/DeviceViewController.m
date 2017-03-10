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
@interface DeviceViewController ()
@property (weak, nonatomic) IBOutlet UILabel *serialLabel;
@property (weak, nonatomic) IBOutlet UIButton *isOnlineBtn;
@property (weak, nonatomic) IBOutlet UIButton *deviceConnectBtn;

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
}

#pragma mark - 扫描点击事件
-(void)MenuDidClick
{
    NSLog(@"点击扫描");
    lhScanQCodeViewController *scanVC = [[lhScanQCodeViewController alloc] init];
    [self.navigationController pushViewController:scanVC animated:YES];
}
- (IBAction)DeviceConnectionAction:(id)sender {
    DeviceStatusViewController *deviceStatusVC = [[DeviceStatusViewController alloc] init];
    [self.navigationController pushViewController:deviceStatusVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
