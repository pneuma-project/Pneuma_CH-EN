//
//  HistoricalDrugViewController.m
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/9.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "HistoricalDrugViewController.h"

@interface HistoricalDrugViewController ()<CustemBBI,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * myTableView;

@end

@implementation HistoricalDrugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:@"Historical Drug/Cartridge Information"];
    [self createSerachView];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"left"];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

-(void)setNavTitle:(NSString *)title
{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    label.text=title;
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:16];
    self.navigationItem.titleView=label;
}
-(void)createSerachView
{
    UIView * headBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, screen_width, 60)];
    headBgView.backgroundColor = RGBColor(42, 109, 188, 1.0);
    UIView * serachBgView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, screen_width-30, 40)];
    serachBgView.layer.cornerRadius = 5.0;
    serachBgView.backgroundColor = RGBColor(76, 135, 204, 1.0);
    
    UIImageView * serachImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15,10,20,20)];
    serachImgView.contentMode = UIViewContentModeScaleAspectFit;
    serachImgView.image = [UIImage imageNamed:@"iconfont-sousuo-2"];
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(serachImgView.current_x_w+15,0,serachBgView.current_w-serachImgView.current_w-15,40)];
    UIColor *color = [UIColor whiteColor];
    textField.textColor = color;
    textField.placeholder = @"search";
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    
    [serachBgView addSubview:serachImgView];
    [serachBgView addSubview:textField];
    [headBgView addSubview:serachBgView];
    [self.view addSubview:headBgView];
    
    self.myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, headBgView.current_y_h, screen_width, screen_height-headBgView.current_y_h) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
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
