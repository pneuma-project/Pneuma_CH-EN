//
//  RetrainingViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/3.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "RetrainingViewController.h"

@interface RetrainingViewController ()<CustemBBI>

@end

@implementation RetrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:[DisplayUtils getTimestampData]];
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
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
