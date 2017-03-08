//
//  EditPatientInfoViewController.m
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/8.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "EditPatientInfoViewController.h"
#import "MedicalTableViewCell.h"
#import "EditDetailPatientInfoViewController.h"
#import "EditDetailPatSexInfoViewController.h"
#import "ValuePickerView.h"
static NSString *ONE_Cell = @"ONECELL";
static NSString *TWO_Cell = @"TWOCELL";


@interface EditPatientInfoViewController ()<CustemBBI,sexDelegate>
{
    UIView * headView;
    UIImageView * headImageView;
    
    CGSize medicalSize;
    CGSize allergySize;
    
}
@property (nonatomic, strong) ValuePickerView *pickerView;
@end


@implementation EditPatientInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:@"Edit Patient Information"];
//    [self registerCell];
    [self createHeadView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"left"];
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
    
    self.pickerView = [[ValuePickerView alloc]init];

    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_width, 100)];
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    headImageView.center = CGPointMake(screen_width/2, 50);
    headImageView.image = [UIImage imageNamed:_patientModel.headImage];
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
        
    }
}
#pragma mark --- sexDelegate
-(void)showTheSex:(NSString *)sexStr
{
    UILabel * label = (UILabel *)[self.view viewWithTag:102];
    label.text = sexStr;
    
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
        headLabel.text = @"Device Information";
    }else {
        headLabel.text = nil;
    }
    [view addSubview:headLabel];
    return view;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 8;
    }else if (section == 1){
        return 1;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArr = @[@"Name:",@"Relationship:",@"Sex:",@"Age:",@"Race:",@"Height:",@"Weight:",@"Phone:"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ONE_Cell];
    cell.backgroundColor = [UIColor whiteColor];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ONE_Cell];
    }else
    {
        for (UIView *subView in cell.subviews) {
            [subView removeFromSuperview];
        }
    }
    if (indexPath.section == 0) {
        
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, screen_width/2, 40)];
        keyLabel.text = titleArr[indexPath.row];
        keyLabel.textColor = RGBColor(50, 51, 52, 1.0);
        UILabel * valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(keyLabel.current_x_w, 2, screen_width/2-40, 40)];
        valueLabel.textAlignment = NSTextAlignmentRight;
        valueLabel.textColor = RGBColor(122, 123, 124, 1.0);
        valueLabel.tag = 100+indexPath.row;
        
        if (indexPath.row == 0) {
            valueLabel.text = _patientModel.name;
        }
        [cell addSubview:valueLabel];
        [cell addSubview:keyLabel];
        [cell addSubview:[DisplayUtils customCellLine:44]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else if (indexPath.section == 1){
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, screen_width/2, 40)];
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
        [saveBtn setBackgroundColor:RGBColor(0, 83, 180, 1.0)];
        saveBtn.layer.mask = [DisplayUtils cornerRadiusGraph:saveBtn withSize:CGSizeMake(saveBtn.current_h/2, saveBtn.current_h/2)];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell addSubview:saveBtn];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *titleArr = @[@"Name",@"Relationship",@"Sex",@"Age",@"Race",@"Height",@"Weight",@"Phone"];
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            EditDetailPatSexInfoViewController * sexVC = [[EditDetailPatSexInfoViewController alloc]init];
            sexVC.sexDelegate = self;
            UILabel * label = (UILabel *)[self.view viewWithTag:102];
           
            if (label.text.length!=0) {
               sexVC.sexStr = label.text;
            }
            [self.navigationController pushViewController:sexVC animated:YES];
        }else if(indexPath.row == 3||indexPath.row == 4||indexPath.row == 5||indexPath.row ==6)
        {
            [self createPickerView:indexPath.row :titleArr[indexPath.row]];
            
        }else
        {
            EditDetailPatientInfoViewController * editDetailVC = [[EditDetailPatientInfoViewController alloc]init];
            editDetailVC.nameStr = titleArr[indexPath.row];
            [self.navigationController pushViewController:editDetailVC animated:YES];
        }
    }else
    {
        return;
    }
}


-(void)createPickerView:(NSInteger)index :(NSString *)keyStr
{
    NSArray * arr = nil;
    if (index == 3) {
        NSMutableArray * mutArr = [NSMutableArray array];
        for (int i=0; i<121; i++) {
            [mutArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        arr = mutArr;
    }else if (index == 4)
    {
        arr = @[@"White or Caucasian",@"Asian",@"American Lndian or Alaska Native",@"Hispanic or Latino",@"Black or African American",@"Hawaiian or Other Pacific Islander"];
    }else if (index == 5)
    {
        NSMutableArray * mutArr = [NSMutableArray array];
        for (int i=100; i<250; i++) {
           [mutArr addObject:[NSString stringWithFormat:@"%dcm",i]];
        }
        arr = mutArr;
    }else
    {
        NSMutableArray * mutArr = [NSMutableArray array];
        for (int i=25; i<200; i++) {
            [mutArr addObject:[NSString stringWithFormat:@"%dkg",i]];
        }
        arr = mutArr;
        
    }
    
    self.pickerView.dataSource = arr;
    self.pickerView.pickerTitle = keyStr;
    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
    
        UILabel * textlabel = (UILabel *)[weakSelf.view viewWithTag:100+index];
        
        textlabel.text = value;
    };
    [self.pickerView show];
    
    
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
