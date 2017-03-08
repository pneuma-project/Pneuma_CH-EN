//
//  PatientInfoViewController.m
//  Sprayer
//
//  Created by FangLin on 17/3/6.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "PatientInfoViewController.h"
#import "PatientInfoModel.h"
#import "PatientInfoTableViewCell.h"

static NSString *const cellId = @"cell";

@interface PatientInfoViewController ()<CustemBBI>
{
    BOOL isEdit;
    UIButton *rightBtn;
    UIButton *addBtn;
}
@property (nonatomic,strong)NSMutableArray *dataArr;//数据
@end

@implementation PatientInfoViewController

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
    [self setNavTitle:@"Patient Information"];
    [self requestData];
    [self registerCell];
    [self createView];
    isEdit = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.leftBarButtonItem = [CustemNavItem initWithImage:[UIImage imageNamed:@"icon-back"] andTarget:self andinfoStr:@"left"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self setNavRightItem]];
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

-(UIButton *)setNavRightItem
{
    rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"Edit" forState:UIControlStateNormal];
    rightBtn.frame=CGRectMake(0, 0, 60, 40);
    [rightBtn addTarget:self action:@selector(rightBarAction) forControlEvents:UIControlEventTouchUpInside];
    return rightBtn;
}

-(void)createView
{
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(50, 350+(screen_height-350-64)/2, screen_width-100, 40);
    [addBtn setTitle:@"Add Members" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addBtn setBackgroundColor:RGBColor(0, 83, 181, 1.0)];
    addBtn.layer.mask = [DisplayUtils cornerRadiusGraph:addBtn withSize:CGSizeMake(addBtn.current_h/2, addBtn.current_h/2)];
    [self.view addSubview:addBtn];
}

-(void)registerCell
{
    [self.tableView registerNib:[UINib nibWithNibName:@"PatientInfoTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
}

#pragma mark - CustemBBI代理方法
-(void)BBIdidClickWithName:(NSString *)infoStr
{
    if ([infoStr isEqualToString:@"left"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)rightBarAction
{
    BOOL status = rightBtn.selected;
    status = !status;
    if (status) {
        [rightBtn setTitle:@"Cancel" forState:UIControlStateNormal];
        isEdit = YES;
        addBtn.hidden = YES;
    }else{
        [rightBtn setTitle:@"Edit" forState:UIControlStateNormal];
        isEdit = NO;
        addBtn.hidden = NO;
    }
    rightBtn.selected = status;
}

#pragma mark - 数据相关
-(void)requestData
{
    NSArray *imageArr = @[@"user-list-img-anny",@"user-list-img-michelle",@"user-list-img-john"];
    NSArray *nameArr = @[@"Anny",@"Michelle",@"John"];
    for (NSInteger i = 0; i < imageArr.count; i++) {
        PatientInfoModel *model = [[PatientInfoModel alloc] init];
        model.headImage = imageArr[i];
        model.name = nameArr[i];
        if (i == 0) {
            model.isSelect = YES;
        }else{
            model.isSelect = NO;
        }
        [self.dataArr addObject:model];
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
    PatientInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (self.dataArr) {
        PatientInfoModel *model = self.dataArr[indexPath.row];
        if (model.isSelect == YES) {
            cell.selectImageView.hidden = NO;
        }else{
            cell.selectImageView.hidden = YES;
        }
        cell.headImageView.image = [UIImage imageNamed:model.headImage];
        cell.nameLabel.text = model.name;
    }
    [cell addSubview:[DisplayUtils customCellLine:70]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (isEdit == NO) {
        //遍历viewModel的数组，如果点击的行数对应的viewModel相同，将isSelected变为Yes，反之为No
        for (NSInteger i = 0; i < self.dataArr.count; i++) {
            PatientInfoModel *model = self.dataArr[i];
            if (i != indexPath.row) {
                model.isSelect = NO;
            }else if (i == indexPath.row){
                model.isSelect = YES;
            }
        }
        [self.tableView reloadData];
    }else{
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
