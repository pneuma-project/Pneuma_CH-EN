//
//  EditDetailPatientInfoViewController.m
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/8.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "EditDetailPatientInfoViewController.h"

@interface EditDetailPatientInfoViewController ()<CustemBBI>
{
    UIButton * rightBtn;
}
@end

@implementation EditDetailPatientInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:_nameStr];
    [self createView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"left"];
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self setNavRightItem]];
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
-(UIButton *)setNavRightItem
{
    rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"Save" forState:UIControlStateNormal];
    rightBtn.frame=CGRectMake(0, 0, 60, 40);
    [rightBtn addTarget:self action:@selector(rightBarAction) forControlEvents:UIControlEventTouchUpInside];
    return rightBtn;
}

-(void)createView
{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, screen_width, 50)];
    bgView.backgroundColor = RGBColor(254, 255, 255, 1.0);
    
    UITextField * textFiled = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, bgView.current_w-15, 50)];
    textFiled.placeholder = [NSString stringWithFormat:@"Please enter your %@",_nameStr];
    textFiled.backgroundColor = RGBColor(254, 255, 255, 1.0);
    [bgView addSubview:textFiled];
    [self.view addSubview:bgView];
}



#pragma mark---导航栏右边的点击事件
-(void)rightBarAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"left"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([infoStr isEqualToString:@"right"]){
        
    }
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
