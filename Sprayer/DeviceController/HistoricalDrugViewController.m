//
//  HistoricalDrugViewController.m
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/9.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "HistoricalDrugViewController.h"
#import "HistoricalDrugTableViewCell.h"
@interface HistoricalDrugViewController ()<CustemBBI,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)NSMutableArray * dataArr;
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
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:color}];
    [serachBgView addSubview:serachImgView];
    [serachBgView addSubview:textField];
    [headBgView addSubview:serachBgView];
    [self.view addSubview:headBgView];
    
    self.myTableView =[[UITableView alloc]initWithFrame:CGRectMake(0, headBgView.current_y_h, screen_width, screen_height-headBgView.current_y_h) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerNib:[UINib nibWithNibName:@"HistoricalDrugTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.myTableView.tableFooterView = [[UIView alloc]init];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoricalDrugTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该消息？" preferredStyle:UIAlertControllerStyleAlert];
        //        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //
            //            [_classArray removeObjectAtIndex:indexPath.row];
            //            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            MessageModel *model = weakself.dataArray[indexPath.row];
            [weakself singleDelet:model.mid];
            
            
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
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
