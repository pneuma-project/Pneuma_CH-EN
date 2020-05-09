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
#import "BlueToothDataModel.h"
#import "SqliteUtils.h"
#import "HistoryDetailViewController.h"
#import "Pneuma-Swift.h"
static NSString *Cell_ONE = @"cellOne";
static NSString *Cell_TWO = @"cellTwo";

@interface HistoryViewController ()<CustemBBI>

@property (nonatomic,strong)NSMutableArray *dataArr;

//@property (nonatomic,strong) NSArray * dateArr;//获取每一条历史数据的日期的数组

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
    [self setNavTitle:NSLocalizedString(@"History", nil)];
    [self registerCell];
//    [self requestData];
    [self requestData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

#pragma mark --- 拿到每一天的所有数据
-(void)requestData {
    [DeviceRequestObject.shared requestGetHistorySuckFogData];
    [DeviceRequestObject.shared setRequestGetHistorySuckFogDataSuc:^(NSArray<SprayerDataModel *> * _Nonnull dataList) {
        for (SprayerDataModel *model in dataList) {
            [self.dataArr addObject:model];
        }
        [self.tableView reloadData];
    }];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 0.1)];
    view.backgroundColor = RGBColor(242, 250, 254, 1.0);
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, screen_width-20, 40)];
    headLabel.backgroundColor = RGBColor(242, 250, 254, 1.0);
    headLabel.textColor = RGBColor(8, 86, 184, 1.0);
    headLabel.font = [UIFont systemFontOfSize:13];
    headLabel.hidden = YES;
    if (section == 0) {
        headLabel.text = @"2020";
    }
    [view addSubview:headLabel];
     
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count+1;
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
            //祭FL挖的坑，踩坑人2：你祭了他的坑不能填平一点吗。。。
            NSInteger index = indexPath.row - 1;
            SprayerDataModel *model = self.dataArr[index];
            NSString *timeStr = [DisplayUtils getTimeStampToString:NSLocalizedString(@"TrainingNavHeadTimeFormat", nil) AndTime:[NSString stringWithFormat:@"%lld",model.addDate/1000]];
            cell.timeLabel.text = timeStr;
            cell.spraysLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)model.suckFogNum,(long)model.goodSuckFogNum];
            cell.inspiratoryLabel.text = [NSString stringWithFormat:@"%.3f",model.dataSum];
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
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row !=0) {
        SprayerDataModel *model = self.dataArr[indexPath.row-1];
        HistoryDetailViewController * vc = [[HistoryDetailViewController alloc]init];
        vc.selectDate = [NSString stringWithFormat:@"%lld",model.addDate/1000];
        vc.titles = [DisplayUtils getTimeStampToString:NSLocalizedString(@"TrainingNavHeadTimeFormat", nil) AndTime:[NSString stringWithFormat:@"%lld",model.addDate/1000]];
        [self.navigationController pushViewController:vc animated:YES];
    }
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return NO;
    }else
    {
      return YES;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
