//
//  UserViewController.m
//  Sprayer
//
//  Created by FangLin on 17/2/27.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "UserViewController.h"
#import "BasicInformationViewController.h"
#import "UserListViewController.h"
#import "PatientInfoViewController.h"
#import "SqliteUtils.h"
#import "AddPatientInfoModel.h"
@interface UserViewController ()
{
    UIView *view;
    UIImageView *bgImageView;
    UILabel *nameLabel;
    UIImageView *headerView;
    
    NSArray *imageArr;
    NSArray *titleArr;
}
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavTitle:@"My Profile"];
    [self createHeadView];
    
    imageArr = @[@"my-profile-icon-basic-information",@"my-profile-icon-patient-information",@"my-profile-icon-history"];
    titleArr = @[@"Basic Information",@"Patient Information",@"History"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"transparent"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"transparent"]];
    NSArray * arr = [SqliteUtils selectUserInfo];
    if (arr.count!=0) {
        for (AddPatientInfoModel * model in arr) {
            
            if (model.isSelect == 1) {
                 nameLabel.text=model.name;
                return;
            }
            
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = RGBColor(0, 83, 181, 1.0);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
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

-(void)createHeadView
{
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 150)];

    //背景
    bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 150)];
    bgImageView.image = [UIImage imageNamed:@"my-profile-bg"];
    [view addSubview:bgImageView];
    
    //头像
    headerView=[[UIImageView alloc]init];
    headerView.bounds=CGRectMake(0, 0, 80, 80);
    headerView.center=CGPointMake(screen_width/2, 60);
    headerView.layer.cornerRadius=30.0f;
    headerView.clipsToBounds=YES;
    headerView.image=[UIImage imageNamed:@"device-user-2"];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(infoSet)];
    headerView.userInteractionEnabled=YES;
    [headerView addGestureRecognizer:tap];
    //名字
    nameLabel=[[UILabel alloc]init];
    nameLabel.bounds=CGRectMake(screen_width/2-100, 150, 300, 20);
    nameLabel.center=CGPointMake(view.center.x, 120);
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.text=@"Anny";
    UITapGestureRecognizer *nametap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(infoSet)];
    nameLabel.userInteractionEnabled=YES;
    [nameLabel addGestureRecognizer:nametap];
    [view addSubview:headerView];
    [view addSubview:nameLabel];
    
    self.tableView.tableHeaderView = view;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

-(void)infoSet
{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=-64) {
        CGRect frame = bgImageView.frame;
        frame.size.height = 150-scrollView.contentOffset.y;
        frame.origin.y = scrollView.contentOffset.y;
        bgImageView.frame = frame;
    }
}

#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
    cell.textLabel.text = titleArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        BasicInformationViewController *inforVC = [[BasicInformationViewController alloc] init];
        [self.navigationController pushViewController:inforVC animated:YES];
    }else if (indexPath.row == 1){
        PatientInfoViewController *patientInfoVC = [[PatientInfoViewController alloc] init];
        [self.navigationController pushViewController:patientInfoVC animated:YES];
    }else if (indexPath.row == 2){
        UserListViewController *userListVC = [[UserListViewController alloc] init];
        [self.navigationController pushViewController:userListVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
