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
#pragma mark --- 拿到当天的所有数据
-(NSArray *)selectFromData
{
    //查询数据库(获取所有用户数据)
    NSArray * arr = [[SqliteUtils sharedManager]selectHistoryBTInfo];
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
    if (dataArr.count == 0) {
        return @[];
    }
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
    
    NSMutableArray * allNumSprayArr = [NSMutableArray array];
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%.llu",recordTime];
        for (BlueToothDataModel * model in dataArr) {
            if([[model.timestamp substringToIndex:5] isEqualToString:[time substringToIndex:5]])
            {
                [allNumSprayArr addObject:model.allBlueToothData];
            }
            //判断有几次达标
            if (_model.btData.length == 0) {
                [sprayArr addObject:@"1/1"];
            }else
            {
                //算出最佳训练模式数据的总量
                float sum = 0;
                NSArray * numArr = [_model.btData componentsSeparatedByString:@","];
                for (NSString * num in numArr) {
                    sum+=[num floatValue];
                }
                sum/=600;
                //-----------得到有几次喷雾达标------//
                NSArray * numArr1 = [model.blueToothData componentsSeparatedByString:@","];
                float sum1 = 0.0;
                for (NSString * num in numArr1) {
                    sum1+=[num floatValue];
                }
                if (sum1>=sum*0.8) {
                    [sprayArr addObject:@"1/1"];
                }else
                {
                    [sprayArr addObject:@"0/1"];
                }
                
            }
            //----------算出喷雾的平均量---------//
            float sum = 0;
            for (NSString * str in allNumSprayArr) {
                NSArray * arr = [str componentsSeparatedByString:@","];
                for (NSString * num in arr) {
                    sum += [num floatValue];
                }
                [inspiratoryArr addObject:[NSString stringWithFormat:@"%.2f",sum/allNumSprayArr.count]];
            }

            
        }
    
    
    return @[userTimeArr,sprayArr,inspiratoryArr];
    
}

-(void)requestData
{
    NSArray * dataArr = [self selectFromData];
    NSLog(@"%@",dataArr);
    if (dataArr.count == 0) {
        return;
    }
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
    if (timeArr1.count == 0) {
        return;
    }
    //将数据按天数分类
    NSMutableArray * timeArr2 = [NSMutableArray array];
    NSMutableArray * spraysArr2 = [NSMutableArray array];
    NSMutableArray * inspiratoryArr2 = [NSMutableArray array];
    int index = 0;
    int index1 = 0;
    int index2 = 0;
    float index3 = 0;
    float index4 = 0;
    
    NSString * dateStr = timeArr1[0];
    [timeArr2 addObject:dateStr];
    for (int i = 0; i<timeArr1.count; i++) {
        
        if (i==timeArr1.count -1) {
            
            NSArray * arr = [dataArr[1][i] componentsSeparatedByString:@"/"];
            index1 += [arr[0] floatValue];
            index2 += [arr[1] floatValue];
            
            index4 ++;
            
            for (NSString * num in dataArr[2]) {
                index3 += [num floatValue];
            }
            index3 /= [dataArr[2] count];
            
            
            [spraysArr2 addObject:[NSString stringWithFormat:@"%d/%d",index1,index2]];
            [inspiratoryArr2 addObject:[NSString stringWithFormat:@"%f",index3]];
            continue;
        }

        if ([dateStr isEqualToString:timeArr1[i]]) {
            
            NSArray * arr = [dataArr[1][i] componentsSeparatedByString:@"/"];
            index1 += [arr[0] intValue];
            index2 += [arr[1] intValue];
                
            index4 ++;
            index3 =(index3 + [dataArr[2][i] floatValue])/index4;
        }else
        {
            
            dateStr = timeArr1[i];
            [timeArr2 addObject:dateStr];
            [spraysArr2 addObject:[NSString stringWithFormat:@"%d/%d",index1,index2]];
            [inspiratoryArr2 addObject:[NSString stringWithFormat:@"%f",index3]];
            index  = i;
            index1 = 0;
            index2 = 0;
            index4 = 0;
            index3 = 0;

        }
        
    }
   
            for (NSInteger j = 0; j < timeArr2.count; j++) {
                HistoryModel *model = [[HistoryModel alloc] init];
                model.time = timeArr2[j];
                model.spray = spraysArr2[j];
                model.inspiratory = inspiratoryArr2[j];
                [self.dataArr addObject:model];
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
         
            //祭FL挖的坑
            NSInteger index = indexPath.row - 1;

            HistoryModel *model = self.dataArr[index];
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
