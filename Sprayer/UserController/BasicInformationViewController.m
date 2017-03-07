//
//  BasicInformationViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/3.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "BasicInformationViewController.h"
#import "lhScanQCodeViewController.h"
#import "MedicalTableViewCell.h"

static NSString *ONE_Cell = @"ONECELL";
static NSString *TWO_Cell = @"TWOCELL";
static NSString *THREE_Cell = @"THREECELL";

@interface BasicInformationViewController ()<CustemBBI>
{
    UIView *headView;
    UIImageView *headImageView;
    
    CGSize medicalSize;
    CGSize allergySize;
}
@end

@implementation BasicInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:@"Basic Information"];
    [self registerCell];
    [self createHeadView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"left"];
    self.navigationItem.rightBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"device-icon-saoyisao"] andTarget:self andinfoStr:@"right"];
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

-(void)registerCell
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ONE_Cell];
    [self.tableView registerNib:[UINib nibWithNibName:@"MedicalTableViewCell" bundle:nil] forCellReuseIdentifier:TWO_Cell];
}

-(void)createHeadView
{
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_width, 100)];
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    headImageView.center = CGPointMake(screen_width/2, 50);
    headImageView.image = [UIImage imageNamed:@"basic-information-img-touxiang"];
    [headView addSubview:headImageView];
    
    self.tableView.tableHeaderView = headView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"left"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([infoStr isEqualToString:@"right"]){
        lhScanQCodeViewController *lhscanVC = [[lhScanQCodeViewController alloc] init];
        [self.navigationController pushViewController:lhscanVC animated:YES];
    }
}

#pragma mark - UITableView Delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screen_width-20, 40)];
    headLabel.backgroundColor = RGBColor(242, 250, 254, 1.0);
    headLabel.textColor = RGBColor(8, 86, 184, 1.0);
    headLabel.font = [UIFont systemFontOfSize:13];
    if (section == 0) {
        headLabel.text = @"Basic Information";
    }else if (section == 1){
        headLabel.text = @"Medical History";
    }else if (section == 2){
        headLabel.text = @"Device Information";
    }else {
        headLabel.text = nil;
    }
    [view addSubview:headLabel];
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }else if (section == 1){
        return 1;
    }else if (section ==2){
        return 1;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArr = @[@"Name:",@"Phone:",@"Sex:",@"Age:",@"Race:",@"Height:",@"Weight:"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ONE_Cell];
    cell.backgroundColor = [UIColor whiteColor];
    if (cell) {
        for (UIView *subView in cell.subviews) {
            [subView removeFromSuperview];
        }
    }
    if (indexPath.section == 0) {
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, screen_width/2, 40)];
        keyLabel.text = titleArr[indexPath.row];
        keyLabel.textColor = RGBColor(50, 51, 52, 1.0);
        [cell addSubview:keyLabel];
        [cell addSubview:[DisplayUtils customCellLine:44]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (indexPath.section == 1){
        MedicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TWO_Cell forIndexPath:indexPath];
        medicalSize = [DisplayUtils stringWithWidth:cell.medicalLabel.text withFont:15];
        allergySize = [DisplayUtils stringWithWidth:cell.allergyLabel.text withFont:15];
        return cell;
    }else if (indexPath.section == 2){
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, screen_width/2, 40)];
        keyLabel.text = @"Device serial number:";
        keyLabel.textColor = RGBColor(50, 51, 52, 1.0);
        keyLabel.font = [UIFont systemFontOfSize:14];
        [cell addSubview:keyLabel];
        return cell;
    }else{
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(50, 5, screen_width-100, 40);
        [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setBackgroundColor:RGBColor(16, 101, 182, 1.0)];
        saveBtn.layer.mask = [DisplayUtils cornerRadiusGraph:saveBtn withSize:CGSizeMake(saveBtn.current_h/2, saveBtn.current_h/2)];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell addSubview:saveBtn];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return medicalSize.height+allergySize.height+102;
    }else{
        return 44;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
