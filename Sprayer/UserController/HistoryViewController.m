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

-(NSArray *)selectFromData
{
    //查询数据库(获取所有用户数据)
    NSArray * arr = [SqliteUtils selectHistoryBTInfo];
    NSMutableArray * userTimeArr = [NSMutableArray array];
    NSMutableArray * sprayArr = [NSMutableArray array];
    NSMutableArray * inspiratoryArr = [NSMutableArray array];
    NSMutableArray * dataArr = [NSMutableArray array];
    //筛选出该用户的所有历史数据
    for (BlueToothDataModel * model in arr) {
        if (model.userId == _model.userId) {
            [dataArr addObject:model];
        }
    }
    //对用户数据按日期降序排列
    for (int  i =0; i<[dataArr count]-1; i++) {
        
        for (int j = i+1; j<[dataArr count]; j++) {
           
            BlueToothDataModel * model1 = dataArr[i];
            BlueToothDataModel * model2 = dataArr[j];
           
            if ([model1.timestamp intValue]<[model2.timestamp intValue]) {
                
                //交换
                
                [dataArr exchangeObjectAtIndex:i withObjectAtIndex:j];
                
            }
            
        }
        
    }
    //将排序好的日期分列添加入数组
    for (BlueToothDataModel * model in dataArr) {
        [userTimeArr addObject:model.timestamp];
    }
    
    //拿到每一天有多少次数据和每次数据的总和
    for (NSString * time in userTimeArr) {
            NSMutableArray * allNumSprayArr = [NSMutableArray array];
        for (BlueToothDataModel * model in dataArr) {
            if([model.timestamp isEqualToString:time])
            {
                [allNumSprayArr addObject:model.allBlueToothData];
            }
        }
        //判断有几次达标
        if (_model.btData.length == 0) {
            [sprayArr addObject:[NSString stringWithFormat:@"%ld/%ld",allNumSprayArr.count,allNumSprayArr.count]];
        }else
        {
            //算出最佳训练模式数据的总量
            int sum = 0;
            NSArray * numArr = [_model.btData componentsSeparatedByString:@","];
            for (NSString * num in numArr) {
                sum+=[num intValue];
            }
            //-----------得到有几次喷雾达标------//
            int index = 0;
            for (NSString * btData in allNumSprayArr) {
                if ([btData intValue]>=sum) {
                    index++;
                }
            }
            [sprayArr addObject:[NSString stringWithFormat:@"%ld/%d",allNumSprayArr.count,index]];
        }
        //----------算出喷雾的平均量---------//
        int sum = 0;
        for (NSString * num in allNumSprayArr) {
            sum += [num intValue];
        }
        [inspiratoryArr addObject:[NSString stringWithFormat:@"%ld",sum/allNumSprayArr.count]];
    }
   
    
    return @[userTimeArr,sprayArr,inspiratoryArr];
    
}

-(void)requestData
{
    NSArray * dataArr = [self selectFromData];
    NSLog(@"%@",dataArr);
    NSMutableArray *timeArr1 = [NSMutableArray array];
    //将时间戳转为应为缩写
    for (NSString * timeStr in dataArr[0]) {
        
        NSTimeInterval time=[timeStr doubleValue];
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"MMM dd"];
        
        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
        [timeArr1 addObject:currentDateStr];
}
    
    
    NSArray *spraysArr1 = dataArr[1];
    NSArray *inspiratoryArr1 = dataArr[2];
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
        headLabel.text = @"2017";
    }else if (section == 1){
        headLabel.text = @"December 2016";
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
    if (self.dataArr) {
        if (section == 0) {
            return [[self.dataArr[0] objectForKey:@"one"] count]+1;
        }else if (section == 1){
            return [[self.dataArr[1] objectForKey:@"two"] count]+1;
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
            //祭FL挖的坑
            NSInteger index = indexPath.row - 1;

            HistoryModel *model = array[index];
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
