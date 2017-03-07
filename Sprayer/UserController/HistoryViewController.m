//
//  HistoryViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/6.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "HistoryValueTableViewCell.h"
#import "HistoryModel.h"

static NSString *Cell_ONE = @"cellOne";
static NSString *Cell_TWO = @"cellTwo";

@interface HistoryViewController ()<CustemBBI>

@property (nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation HistoryViewController

-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    [self setNavTitle:@"History"];
    [self registerCell];
    [self requestData];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:nil] forCellReuseIdentifier:Cell_ONE];
    [self.tableView registerNib:[UINib nibWithNibName:@"HistoryValueTableViewCell" bundle:nil] forCellReuseIdentifier:Cell_TWO];
}

-(void)requestData
{
    NSArray *timeArr1 = @[@"Jan 12",@"Jan 11",@"Jan 10",@"Jan 09",@"Jan 08",@"Jan 06",@"Jan 04",@"Jan 01"];
    NSArray *spraysArr1 = @[@"3/3",@"4/2",@"2/2",@"4/1",@"4/4",@"6/5",@"7/3",@"5/2"];
    NSArray *inspiratoryArr1 = @[@"20",@"25",@"37",@"20.5",@"22.3",@"17",@"18.9",@"20"];
    NSArray *timeArr2 = @[@"Dec 31",@"Dec 30",@"Dec 28",@"Dec 25",@"Dec 20",@"Dec 19",@"Dec 18",@"Dec 17"];
    NSArray *spraysArr2 = @[@"3/1",@"5/2",@"2/1",@"3/2",@"6/3",@"4/2",@"5/3",@"6/4"];
    NSArray *inspiratoryArr2 = @[@"19",@"20.65",@"22.3",@"17",@"37",@"15.4",@"20",@"17"];
    for (NSInteger i = 0; i < 2; i++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if (i == 0) {
            for (NSInteger j = 0; j < timeArr1.count; j++) {
                HistoryModel *model = [[HistoryModel alloc] init];
                model.time = timeArr1[j];
                model.spray = spraysArr1[j];
                model.inspiratory = inspiratoryArr1[j];
                [array addObject:model];
            }
            [dic setObject:array forKey:@"one"];
        }else if (i == 1){
            for (NSInteger j = 0; j < timeArr2.count; j++) {
                HistoryModel *model = [[HistoryModel alloc] init];
                model.time = timeArr2[j];
                model.spray = spraysArr2[j];
                model.inspiratory = inspiratoryArr2[j];
                [array addObject:model];
            }
            [dic setObject:array forKey:@"two"];
        }
        [self.dataArr addObject:dic];
    }
    
}

#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"left"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableView delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screen_width-20, 40)];
    headLabel.backgroundColor = RGBColor(242, 250, 254, 1.0);
    headLabel.textColor = RGBColor(8, 86, 184, 1.0);
    headLabel.font = [UIFont systemFontOfSize:13];
    if (section == 0) {
        headLabel.text = @"January 2017";
    }else if (section == 1){
        headLabel.text = @"December 2016";
    }
    [view addSubview:headLabel];
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataArr) {
        if (section == 0) {
            return [[self.dataArr[0] objectForKey:@"one"] count];
        }else if (section == 1){
            return [[self.dataArr[1] objectForKey:@"two"] count];
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_ONE forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        HistoryValueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell_TWO forIndexPath:indexPath];
        if (self.dataArr) {
            NSArray *array;
            if (indexPath.section == 0) {
                array = [self.dataArr[indexPath.section] objectForKey:@"one"];
            }else if (indexPath.section == 1){
                array = [self.dataArr[indexPath.section] objectForKey:@"two"];
            }
            HistoryModel *model = array[indexPath.row];
            cell.timeLabel.text = model.time;
            cell.spraysLabel.text = model.spray;
            cell.inspiratoryLabel.text = model.inspiratory;
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }else{
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
