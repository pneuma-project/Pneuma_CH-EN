//
//  SprayViewController.m
//  Sprayer
//
//  Created by FangLin on 17/2/27.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "SprayViewController.h"
#import "JHChartHeader.h"
#import "SqliteUtils.h"
#import "BlueToothDataModel.h"
#import "AddPatientInfoModel.h"
#import "DisplayUtils.h"
#import "UserDefaultsUtils.h"
#import "FLWrapJson.h"
#import "FLDrawDataTool.h"
#import "Pneuma-Swift.h"

#define k_MainBoundsWidth [UIScreen mainScreen].bounds.size.width
#define k_MainBoundsHeight [UIScreen mainScreen].bounds.size.height
@interface SprayViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    float allTotalNum;
    float allTrainTotalNum;
    float lastTrainNum;
    NSInteger indexItem;
    
    NSData *timeData;
    NSString *medicineName; //药品名称
    
    UILabel * referenceInfoLabel;
    UILabel * totalInfoLabel;
    UILabel *medicineNameL;
    UILabel *currentInfoLabel;
    
    UILabel * currentLabel;
    UILabel * yLineLabel;
    UILabel * xLineLabel;
    UILabel * downDateLabel;
    UIView * downBgView;
}
@property(nonatomic,strong)JHLineChart *lineChart;

@property(nonatomic,strong)UIView * upBgView;

@property(nonatomic,strong)UILabel * slmLabel;

@property(nonatomic,strong)NSMutableArray * sprayDataArr;//训练最佳曲线数据(1.2....)

@property(nonatomic,strong)NSMutableArray<SprayerDataModel *> * totalDayDataList;//当天喷雾数据

@property (nonatomic,strong)NSTimer *timer;

@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation SprayViewController

-(NSMutableArray<SprayerDataModel *> *)totalDayDataList {
    if (!_totalDayDataList) {
        _totalDayDataList = [[NSMutableArray alloc] init];
    }
    return _totalDayDataList;
}

-(NSMutableArray *)sprayDataArr {
    if (!_sprayDataArr) {
        _sprayDataArr = [[NSMutableArray alloc] init];
    }
    return _sprayDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBColor(240, 248, 252, 1.0);
    [self setNavTitle:[DisplayUtils getTimestampData:NSLocalizedString(@"TrainingNavHeadTimeFormat", nil)]];
    [self setUpInterface];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(writeDataAction) userInfo:nil repeats:YES];
    [self.timer setFireDate:[NSDate distantFuture]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
    [self.timer setFireDate:[NSDate distantPast]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectAction) name:PeripheralDidConnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshViewAction) name:@"refreshSprayView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleConnectSucceedAction) name:ConnectSucceed object:nil]; //设备连接成功
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.timer setFireDate:[NSDate distantFuture]];
}

-(void)refreshViewAction
{
    [self requestData];
}

-(void)disconnectAction
{
    [self.timer setFireDate:[NSDate distantFuture]];
}

-(void)bleConnectSucceedAction
{
    if ([[UIViewController getCurrentViewCtrl] isKindOfClass:[self class]]) {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

-(void)writeDataAction
{
    long long time = [DisplayUtils getNowTimestamp];
    timeData = [FLDrawDataTool longToNSData:time];
    [BlueWriteData sparyData:timeData];
}

-(void)setNavTitle:(NSString *)title
{
    UIView * titileBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 215, 44)];
    UIImageView *  leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 10, 15)];
    leftImgView.image = [UIImage imageNamed:@"icon-back"];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(leftImgView.current_x_w, 0, 180, titileBgView.current_h)];
    label.text=NSLocalizedString(title, nil);
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:19];
    UIImageView * rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(label.current_x_w, 15, 10, 15)];
    rightImgView.image = [UIImage imageNamed:@"spray-icon--选择日期"];
    
    UITapGestureRecognizer * tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftTap)];
    tapOne.numberOfTapsRequired = 1;
    leftImgView.userInteractionEnabled = YES;
    [leftImgView addGestureRecognizer:tapOne];
    
    UITapGestureRecognizer * tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightTap)];
    tapTwo.numberOfTapsRequired = 1;
    rightImgView.userInteractionEnabled = YES;
    [rightImgView addGestureRecognizer:tapTwo];
    
    [titileBgView addSubview:label];
    self.navigationItem.titleView = titileBgView;
    
}

-(void)setUpInterface{
    _upBgView = [[UIView alloc]initWithFrame:CGRectMake(10, kSafeAreaTopHeight+10, screen_width-20, (screen_height-kSafeAreaTopHeight-kTabbarHeight)/2-20)];
    _upBgView.layer.cornerRadius = 3.0;
    _upBgView.backgroundColor = [UIColor whiteColor];
    
    NSString * str = NSLocalizedString(@"Reference Total Volume", nil);
    CGSize strSize = [DisplayUtils stringWithWidth:str withFont:12];
    UILabel * referenceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,strSize.width, strSize.height)];
    referenceLabel.font = [UIFont systemFontOfSize:12];
    referenceLabel.textColor = RGBColor(238, 146, 1, 1.0);
    referenceLabel.text = str;
    
    referenceInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(referenceLabel.current_x_w+5, 10, 50,strSize.height)];
    referenceInfoLabel.textColor = RGBColor(238, 146, 1, 1.0);
    referenceInfoLabel.font = [UIFont systemFontOfSize:15];
    referenceInfoLabel.text = [NSString stringWithFormat:@"%.1fL",allTrainTotalNum];
    
    NSString * str1 = NSLocalizedString(@"Current Total Volume", nil);
    strSize = [DisplayUtils stringWithWidth:str1 withFont:12];
    currentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, referenceLabel.current_y_h, strSize.width, strSize.height)];
    currentLabel.font = [UIFont systemFontOfSize:12];
    currentLabel.textColor = RGBColor(0, 64, 181, 1.0);
    currentLabel.text = str1;
    
    currentInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(currentLabel.current_x_w+5, referenceInfoLabel.current_y_h, 50, strSize.height)];
    currentInfoLabel.text = [NSString stringWithFormat:@"%.1fL",lastTrainNum];
    currentInfoLabel.textColor = RGBColor(0, 64, 181, 1.0);
    currentInfoLabel.font = [UIFont systemFontOfSize:15];
    
    medicineNameL = [[UILabel alloc] initWithFrame:CGRectMake(currentLabel.current_x, currentLabel.current_y_h, 100, 12)];
    medicineNameL.font = [UIFont systemFontOfSize:12];
    medicineNameL.textColor = RGBColor(0, 64, 181, 1.0);
    medicineNameL.text = medicineName;
    [medicineNameL setHidden:true];
    
    UILabel * trainLabel = [[UILabel alloc]initWithFrame:CGRectMake(_upBgView.current_w-55, 10, 55, strSize.height)];
    trainLabel.text = NSLocalizedString(@"Training", nil);
    trainLabel.textColor = RGBColor(238, 146, 1, 1.0);
    trainLabel.font = [UIFont systemFontOfSize:12];
    
    UIView * trainView = [[UIView alloc]initWithFrame:CGRectMake(trainLabel.current_x-15, 15, 10, 3)];
    CGPoint trainPoint = trainView.center;
    trainPoint.y = trainLabel.center.y;
    trainView.center = trainPoint;
    trainView.backgroundColor = RGBColor(238, 146, 1, 1.0);
    
    UILabel * sprayLabel = [[UILabel alloc]initWithFrame:CGRectMake(trainLabel.current_x, trainLabel.current_y_h, 55, strSize.height)];
    sprayLabel.text = NSLocalizedString(@"Spray", nil);
    sprayLabel.textColor = RGBColor(0, 83, 181, 1.0);
    sprayLabel.font = [UIFont systemFontOfSize:12];
    
    UIView * sprayView = [[UIView alloc]initWithFrame:CGRectMake(sprayLabel.current_x-15, 15, 10, 3)];
    CGPoint sprayPoint = sprayView.center;
    sprayPoint.y = sprayLabel.center.y;
    sprayView.center = sprayPoint;
    sprayView.backgroundColor = RGBColor(0, 83, 181, 1.0);
    
    _slmLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, currentLabel.current_y_h+15, 50, 15)];
    _slmLabel.text = @"SLM";
    _slmLabel.font = [UIFont systemFontOfSize:12];
    _slmLabel.textColor = RGBColor(221, 222, 223, 1.0);

    UILabel * SecLabel = [[UILabel alloc]initWithFrame:CGRectMake(_lineChart.current_x_w, _lineChart.current_y_h-30, _upBgView.current_w-_lineChart.current_x_w, 20)];
    SecLabel.text = @"Sec";
    SecLabel.textColor = RGBColor(204, 205, 206, 1.0);
    SecLabel.font = [UIFont systemFontOfSize:10];
    
    [_upBgView addSubview:trainView];
    [_upBgView addSubview:trainLabel];
    [_upBgView addSubview:sprayView];
    [_upBgView addSubview:sprayLabel];
    [_upBgView addSubview:referenceLabel];
    [_upBgView addSubview:referenceInfoLabel];
    [_upBgView addSubview:currentLabel];
    [_upBgView addSubview:currentInfoLabel];
    [_upBgView addSubview:medicineNameL];
    [_upBgView addSubview:SecLabel];
    [_upBgView addSubview:_slmLabel];
    [self.view addSubview:_upBgView];
    
    /*创建第二个柱状图 */
    downBgView = [[UIView alloc]initWithFrame:CGRectMake(10, _upBgView.current_y_h+10, screen_width-20,(screen_height-kSafeAreaTopHeight-kTabbarHeight)/2-20)];
    downBgView.backgroundColor = [UIColor whiteColor];
    UIView * pointView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 8, 8)];
    pointView.backgroundColor = RGBColor(0, 83, 181, 1.0);
    pointView.layer.cornerRadius = 4.0;
    pointView.layer.masksToBounds = 4.0;
    UILabel *inspirationLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointView.current_x_w+5, 10, screen_width-pointView.current_x_w, 15)];
    inspirationLabel.text = NSLocalizedString(@"Inspiration Volume Distribution", nil);
    inspirationLabel.textColor = RGBColor(0, 83, 181, 1.0);
    CGPoint insPoint = pointView.center;
    insPoint.y = inspirationLabel.center.y;
    pointView.center = insPoint;
    
    totalInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(downBgView.current_w-60, inspirationLabel.current_y+15, 60, 30)];
    
    totalInfoLabel.text = [NSString stringWithFormat:@"%.1fL",allTotalNum];
    totalInfoLabel.textAlignment = NSTextAlignmentLeft;
    totalInfoLabel.textColor = RGBColor(0, 83, 181, 1.0);
    totalInfoLabel.font = [UIFont systemFontOfSize:16];
    UILabel * totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(totalInfoLabel.current_x-40, inspirationLabel.current_y_h+8,40,15)];
    totalLabel.text = NSLocalizedString(@"Total", nil);
    totalLabel.textAlignment = NSTextAlignmentRight;
    totalLabel.font = [UIFont systemFontOfSize:12];
    totalLabel.textColor = RGBColor(0, 83, 181, 1.0);
    UILabel * unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointView.current_x, totalLabel.current_y_h+5, 35, 15)];
    unitLabel.text = NSLocalizedString(@"Unit:L", nil);
    unitLabel.font = [UIFont systemFontOfSize:12];
    unitLabel.textColor = RGBColor(203, 204, 205, 1.0);
    
    yLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(unitLabel.current_x_w, unitLabel.current_y_h+10, 1, downBgView.current_h-unitLabel.current_y_h-40)];
    yLineLabel.backgroundColor = RGBColor(204, 205, 206, 1.0);
    
    //绘制y坐标轴的数值
    int sum = 6;
    for (int i=0; i<=6; i++) {
        UILabel * yNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(yLineLabel.current_x-35,yLineLabel.current_y+i*(10+(yLineLabel.current_h-10-70)/6)+10, 30, 10)];
        yNumLabel.textColor = RGBColor(204, 205, 206, 1.0);
        yNumLabel.textAlignment = NSTextAlignmentRight;
        yNumLabel.text = [NSString stringWithFormat:@"%d",sum-i];
        yNumLabel.font = [UIFont systemFontOfSize:10];
        [downBgView addSubview:yNumLabel];
    }
    
    xLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(yLineLabel.current_x_w, yLineLabel.current_y_h, downBgView.current_w-yLineLabel.current_x_w-30, 1)];
    xLineLabel.backgroundColor = RGBColor(204, 205, 206, 1.0);
    downDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(yLineLabel.current_x_w+xLineLabel.current_w/2-70, xLineLabel.current_y_h, 180, 30)];
    downDateLabel.textColor = RGBColor(0, 83, 181, 1.0);
    downDateLabel.font = [UIFont systemFontOfSize:10];
    
    [self setInterface];
    
    UILabel * dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(xLineLabel.current_x_w, xLineLabel.current_y_h-10, downBgView.current_w-xLineLabel.current_x_w, 20)];
    dateLabel.text = NSLocalizedString(@"Date", nil);
    dateLabel.textColor = RGBColor(204, 205, 206, 1.0);
    dateLabel.font = [UIFont systemFontOfSize:12];
    
    [downBgView addSubview:dateLabel];
    [downBgView addSubview:downDateLabel];
    [downBgView addSubview:xLineLabel];
    [downBgView addSubview:yLineLabel];
    [downBgView addSubview:unitLabel];
    [downBgView addSubview:totalLabel];
    [downBgView addSubview:totalInfoLabel];
    [downBgView addSubview:pointView];
    [downBgView addSubview:inspirationLabel];
    [self.view addSubview:downBgView];
}

-(void)setInterface {
    /**
     创建layout(布局)
     UICollectionViewFlowLayout 继承与UICollectionLayout
     对比其父类 好处是 可以设置每个item的边距 大小 头部和尾部的大小
     */
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemWidth = 40;
    // 设置每个item的大小
    layout.itemSize = CGSizeMake(itemWidth, yLineLabel.current_h);
    // 设置列间距
    layout.minimumInteritemSpacing = 0;
    // 设置行间距
    layout.minimumLineSpacing = 20;
    //滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //每个分区的四边间距UIEdgeInsetsMake
    layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(yLineLabel.current_x_w, yLineLabel.current_y, xLineLabel.current_w, yLineLabel.current_h) collectionViewLayout:layout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    /** mainCollectionView 的布局(必须实现的) */
    _collectionView.collectionViewLayout = layout;
    //mainCollectionView 的背景色
    _collectionView.backgroundColor = [UIColor whiteColor];
    //设置代理协议
    _collectionView.delegate = self;
    //设置数据源协议
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [downBgView addSubview:self.collectionView];
}

#pragma mark -- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.totalDayDataList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    if (indexPath.row == indexItem) {
        view.backgroundColor = RGBColor(25, 25, 112, 1.0);
    }else {
        view.backgroundColor = RGBColor(10, 77, 170, 1);
    }
    UILabel *numL = [[UILabel alloc] initWithFrame:CGRectZero];
    numL.font = [UIFont systemFontOfSize:13];
    numL.textColor = [UIColor grayColor];
    numL.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:view];
    [cell.contentView addSubview:numL];
    int viewH = (self.totalDayDataList[indexPath.item].dataSum) * (yLineLabel.current_h-10)/6;
    view.frame = CGRectMake(0, yLineLabel.current_h-viewH, 40, viewH);
    numL.frame = CGRectMake(0, view.current_y-20, 40, 14);
    numL.text = [NSString stringWithFormat:@"%ld(%.1f)",indexPath.item+1,self.totalDayDataList[indexPath.item].dataSum];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    indexItem = indexPath.item;
    [self.collectionView reloadData];
    [self createLineChart:indexPath.item];
}

#pragma mark ----- 查询数据
-(void)requestData{
    [DeviceRequestObject.shared requestGetNewTrainData];
    //    __weak typeof(self) weakSelf = self;
    [DeviceRequestObject.shared setRequestGetNewTrainDataSuc:^(SprayerDataModel * _Nonnull model) {
        if ([model.suckFogData isEqualToString:@""]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"Please go to training", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoTrain" object:nil userInfo:nil];
            }];
            [alertController addAction:alertAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        allTrainTotalNum = model.dataSum;
        if (model.medicineId == 1 || model.medicineId == 3) {
            medicineName = @"Albuterol sulfate";
        }else if (model.medicineId == 2 || model.medicineId == 4) {
            medicineName = @"Tiotropium bromide";
        }
        referenceInfoLabel.text = [NSString stringWithFormat:@"%.1fL",allTrainTotalNum];
        medicineNameL.text = medicineName;
        NSArray * trainArr = [model.suckFogData componentsSeparatedByString:@","];
        [self.sprayDataArr removeAllObjects];
        for (NSString * str in trainArr) {
            [self.sprayDataArr addObject:str];
        }
        [self createLineChart:self.totalDayDataList.count-1];
        NSString *dateTime = [[DisplayUtils getTimestampData:@"YYYY-MM-dd"] substringToIndex:10];
        NSString * startStr = [NSString stringWithFormat:@"%@ 00:00:00",dateTime];
        NSString * endStr = [NSString stringWithFormat:@"%@ 23:59:59",dateTime];
        [DeviceRequestObject.shared requestGetNowDataSuckFogDataWithAddDate:startStr endDate:endStr];
    }];
    
    [DeviceRequestObject.shared setRequestGetNowDataSuckFogDataSuc:^(NSArray<SprayerDataModel *> * _Nonnull dataList) {
        if (dataList.count != 0) {
            lastTrainNum = dataList[dataList.count-1].dataSum;
            currentInfoLabel.text = [NSString stringWithFormat:@"%.1fL",lastTrainNum];
            totalInfoLabel.text = [NSString stringWithFormat:@"%.1fL",lastTrainNum];
            downDateLabel.text = [DisplayUtils getTimeStampToString:NSLocalizedString(@"SprayTimeFormat", nil) AndTime:[NSString stringWithFormat:@"%lld",dataList[dataList.count-1].addDate/1000]];
            [self.totalDayDataList removeAllObjects];
            for (SprayerDataModel *model in dataList) {
                [self.totalDayDataList addObject:model];
            }
            indexItem = dataList.count - 1;
            [self.collectionView reloadData];
            [self createLineChart:dataList.count-1];
        }
    }];
}

#pragma mark ----导航栏点击事件
-(void)leftTap
{
    NSLog(@"点击了左侧");
}
-(void)rightTap
{
    NSLog(@"点击了右侧");
}

#pragma mark ---创建曲线图
-(void)createLineChart:(NSInteger)index
{
    for (UIView *view in _upBgView.subviews) {
        if ([view isKindOfClass:[JHLineChart class]]) {
            [view removeFromSuperview];
        }
    }
    //展示药品信息
    if (self.totalDayDataList.count != 0) {
        SprayerDataModel *model = self.totalDayDataList[index];
        if (model.medicineId == 1 || model.medicineId == 3) {
            medicineName = @"Albuterol sulfate";
        }else if (model.medicineId == 2 || model.medicineId == 4) {
            medicineName = @"Tiotropium bromide";
        }
        medicineNameL.text = medicineName;
        currentInfoLabel.text = [NSString stringWithFormat:@"%.1fL",model.dataSum];
        totalInfoLabel.text = [NSString stringWithFormat:@"%.1fL",model.dataSum];
        downDateLabel.text = [DisplayUtils getTimeStampToString:NSLocalizedString(@"SprayTimeFormat", nil) AndTime:[NSString stringWithFormat:@"%lld",model.addDate/1000]];
    }
    
    self.lineChart = [[JHLineChart alloc] initWithFrame:CGRectMake(5, _slmLabel.current_y_h, _upBgView.current_w-25, _upBgView.current_h-_slmLabel.current_y_h) andLineChartType:JHChartLineValueNotForEveryX];
    _lineChart.xLineDataArr = @[@"0",@"0.1",@"0.2",@"0.3",@"0.4",@"0.5",@"0.6",@"0.7",@"0.8",@"0.9",@"1.0",@"1.1",@"1.2",@"1.3",@"1.4",@"1.5",@"1.6",@"1.7",@"1.8",@"1.9",@"2.0",@"2.1",@"2.2",@"2.3",@"2.4",@"2.5",@"2.6",@"2.7",@"2.8",@"2.9",@"3.0",@"3.1",@"3.2",@"3.3",@"3.4",@"3.5",@"3.6",@"3.7",@"3.8",@"3.9",@"4.0",@"4.1",@"4.2",@"4.3",@"4.4",@"4.5",@"4.6",@"4.7",@"4.8",@"4.9",@"5.0"];//拿到X轴坐标
    _lineChart.contentInsets = UIEdgeInsetsMake(0, 25, 20, 10);
    _lineChart.lineChartQuadrantType = JHLineChartQuadrantTypeFirstQuardrant;
    if (self.totalDayDataList.count!=0) {
        _lineChart.valueArr = @[self.sprayDataArr,[self.totalDayDataList[index].suckFogData componentsSeparatedByString:@","]];
    }else{
        _lineChart.valueArr = @[self.sprayDataArr];
    }
    
    _lineChart.showYLevelLine = YES;
    _lineChart.showYLine = NO;
    _lineChart.showValueLeadingLine = NO;
    _lineChart.valueFontSize = 0.0;
    
    _lineChart.backgroundColor = [UIColor whiteColor];
    /* Line Chart colors */
    _lineChart.valueLineColorArr =@[RGBColor(238, 146, 1, 1.0),RGBColor(0, 83, 181, 1.0)];
    /* Colors for every line chart*/
    _lineChart.pointColorArr = @[[UIColor blueColor],[UIColor orangeColor]];
    /* color for XY axis */
    _lineChart.xAndYLineColor = [UIColor blackColor];
    /* XY axis scale color */
    _lineChart.xAndYNumberColor = [UIColor darkGrayColor];
    /* Dotted line color of the coordinate point */
    _lineChart.positionLineColorArr = @[[UIColor blueColor],[UIColor greenColor]];
    /*        Set whether to fill the content, the default is False         */
    _lineChart.contentFill = YES;
    /*        Set whether the curve path         */
    _lineChart.pathCurve = YES;
    /*        Set fill color array         */
    _lineChart.contentFillColorArr = @[[UIColor colorWithRed:0 green:1 blue:0 alpha:0.0],[UIColor colorWithRed:1 green:0 blue:0 alpha:0.0]];
    
    [_upBgView addSubview:_lineChart];
    [_lineChart showAnimation];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
