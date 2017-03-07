//
//  PatientInfoViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/6.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "PatientInfoViewController.h"

@interface PatientInfoViewController ()

@end

@implementation PatientInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:@"Patient Information"];
}

-(void)setNavTitle:(NSString *)title
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    label.text=title;
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:19];
    self.navigationItem.titleView=label;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
