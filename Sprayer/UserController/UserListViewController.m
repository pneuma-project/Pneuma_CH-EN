//
//  UserListViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/6.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "UserListViewController.h"
#import "HistoryViewController.h"

@interface UserListViewController ()<CustemBBI>

@end

@implementation UserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:@"User List"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"left"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
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

#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"left"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableView delegate
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
    static NSString *CellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId];
    }
    NSArray *imageArr = @[@"user-list-img-anny",@"user-list-img-michelle",@"user-list-img-john"];
    NSArray *nameArr = @[@"Anny",@"Michelle",@"John"];
    cell.imageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
    cell.textLabel.text = nameArr[indexPath.row];
    [cell addSubview:[DisplayUtils customCellLine:80]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HistoryViewController *historyVC = [[HistoryViewController alloc] init];
    [self.navigationController pushViewController:historyVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
