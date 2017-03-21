//
//  BlueToothManager.m
//  BlueToothTest
//
//  Created by soft-angel on 15/12/28.
//  Copyright © 2015年 soft－angel. All rights reserved.
//

#import "BlueToothManager.h"
#import "Model.h"
#import "FLWrapJson.h"

typedef enum _TTGState{
    
    stx_h = 0,
    pkt_h,
    etx_e
    
}TTGState;

#define kServiceUUID @"FFF0" //服务的UUID
#define kNotifyUUID @"FFF3" //特征的UUID
#define kReadWriteUUID @"FFF4" //特征的UUID

@interface BlueToothManager ()
{
    BOOL isLinked;
}
@property (nonatomic,assign)TTGState state;
@property (nonatomic,strong)NSMutableData *putData;

@end

@implementation BlueToothManager

-(NSMutableData *)putData
{
    if (!_putData) {
        _putData = [[NSMutableData alloc] init];
    }
    return _putData;
}

//创建单例类
+(instancetype)getInstance
{
    static BlueToothManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BlueToothManager alloc]init];
        
    });
    return manager;
}

//开始扫描
- (void)startScan
{
    //[LCProgressHUD showLoadingText:@"正在扫描"];
    _manager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];
    _peripheralList = [[NSMutableArray alloc]initWithCapacity:0];
}

//停止扫描
-(void)stopScan
{
    [_manager stopScan];
    [LCProgressHUD hide];
}

//检查蓝牙信息
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        NSLog(@"BLE已打开");
        [central scanForPeripheralsWithServices:nil options:nil];
        [LCProgressHUD showSuccessText:@"蓝牙已打开"];
        [[NSNotificationCenter defaultCenter] postNotificationName:BleIsOpen object:nil userInfo:nil];
    }
    else
    {
        NSLog(@"蓝牙不可用");
        [LCProgressHUD showFailureText:@"蓝牙不可用"];
    }
}

//扫描到的设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"发现外围设备....%@===%@----%@",peripheral.name,RSSI,advertisementData);
    if (peripheral == nil) {
        [_peripheralList removeAllObjects];
    }
    if (peripheral.name != nil) {
        Model * model = [[Model alloc]init];
        model.peripheral = peripheral;
        model.num = [RSSI intValue];
        //如果 外设数组数量为0 则 直接将 该 model 添加到 外设数组中
        //如果 外设数组数量不为0 则 用遍历数组 用外设的名称 进行判断 是否 存在于该数组中
        //如果 外设名称相同  则 只修改 该外设 所对应的 rssi
        //如果 外设名称不同  则 将此外设 加入到外设数组中
        if (_peripheralList.count == 0 && ([peripheral.name isEqualToString:@"ELK_BLE"])) {
            [self connectPeripheralWith:peripheral];
            [_peripheralList addObject:model];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scanDevice" object:nil userInfo:nil];
        }else{
            BOOL ishave = NO;
            for (Model * mo in _peripheralList) {
                if ([mo.peripheral.name isEqualToString:model.peripheral.name]) {
                    mo.num = model.num;
                    ishave = YES;
                    break;
                }else{
                    
                }
            }
            //判断名称是否是设备的默认名称
            if (ishave == NO && ([peripheral.name isEqualToString:@"ELK_BLE"])) {
                [_peripheralList addObject:model];
                [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(scanDeivceAction) userInfo:nil repeats:YES];
            }
        }
    }
}

-(void)scanDeivceAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scanDevice" object:nil userInfo:nil];
}

//获取扫描到设备的列表
-(NSMutableArray *)getNameList
{
    return _peripheralList;
}

//连接设备
-(void)connectPeripheralWith:(CBPeripheral *)per
{
    NSLog(@"开始连接外围设备...");
    [_manager connectPeripheral:per options:nil];
}

//连接设备失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //[LCProgressHUD showFailureText:NSLocalizedString(@"", nil)];
    isLinked = NO;
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
}

//设备断开连接
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    isLinked = NO;
    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
}

//连接设备成功
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    //[LCProgressHUD showSuccessText:NSLocalizedString(@"Connection succeeded", nil)];
    NSLog(@"连接到%@成功",peripheral.name);
    isLinked = YES;
    _per = peripheral;
    [_per setDelegate:self];
    [_per discoverServices:nil];
}


//扫描设备的服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"发现可用服务...");
    if (error)
    {
        NSLog(@"扫描%@的服务发生的错误是：%@",peripheral.name,[error localizedDescription]);

    }
    else
    {
        for (CBService * ser in peripheral.services)
        {
            [_per discoverCharacteristics:nil forService:ser];
        }

    }
}

//扫描服务的特征值
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"已发现可用特征...");
    if (error)
    {
        NSLog(@"扫描服务：%@的特征值的错误是：%@",service.UUID,[error localizedDescription]);
    }
    else
    {
        CBUUID *serviceUUID = [CBUUID UUIDWithString:kServiceUUID];
        CBUUID *notifyUUID = [CBUUID UUIDWithString:kNotifyUUID];
        CBUUID *readWriteUUID = [CBUUID UUIDWithString:kReadWriteUUID];
        if ([service.UUID isEqual:serviceUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                if ([characteristic.UUID isEqual:notifyUUID]) {
                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                }
                if ([characteristic.UUID isEqual:readWriteUUID]) {
                    _char = characteristic;
//                    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectSucceed object:self userInfo:nil];
                }
            }
        }
        
    }
}

//获取特征值的信息
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"获取特征值%@的错误为%@",characteristic.UUID,error);

    }
    else
    {
        NSLog(@"特征值：%@  value：%@",characteristic.UUID,characteristic.value);
        _responseData = characteristic.value;
        [self showResult];
    }
}

//扫描特征值的描述
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"搜索到%@的Descriptors的错误是：%@",characteristic.UUID,error);

    }
    else
    {
        NSLog(@"characteristic uuid:%@",characteristic.UUID);

        for (CBDescriptor * d in characteristic.descriptors)
        {
            NSLog(@"Descriptor uuid:%@",d.UUID);

        }
    }
}

//获取描述值的信息
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error
{
    if (error)
    {
        NSLog(@"获取%@的描述的错误是：%@",peripheral.name,error);
    }
    else
    {
        NSLog(@"characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],descriptor.value);

    }
}

//像蓝牙发送信息
- (void)sendDataWithString:(NSData *)data
{
    //NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"%@", data);
//    if (_per && _char)
//    {
//        switch (_char.properties & 0x04) {
//            case CBCharacteristicPropertyWriteWithoutResponse:
//            {
//                [_per writeValue:data forCharacteristic:_char type:CBCharacteristicWriteWithoutResponse];
//                break;
//
//            }
//            default:
//            {
//                [_per writeValue:data forCharacteristic:_char type:CBCharacteristicWriteWithResponse];
//                break;
//
//            }
//        }
//        
//    }
    [_per writeValue:data forCharacteristic:_char type:CBCharacteristicWriteWithResponse];

}

//展示蓝牙返回的信息
-(void)showResult
{
    if (_responseData) {
        NSLog(@"读取到特征值：%@",_responseData);
        //NSInteger data_len = 0;
        NSData *data = _responseData;
        Byte *bytes = (Byte *)[data bytes];
        //data_len = data.length;
        
        Byte newByte[data.length];
        
        for (NSInteger i = 0; i < data.length; i++) {
            newByte[i] = bytes[i];
            //NSLog(@"newByte = %d",newByte[i]);
        }
        if (newByte[0] == 0xfd) {
            _state = stx_h;
        }
        
        switch (_state) {
            case stx_h:
            {
                if (newByte[data.length - 2] == 0xa5 && newByte[data.length - 1] == 0xa5) {
                    Byte middleByte[data.length - 3];
                    for (NSInteger j = 0; j<data.length - 3; j++) {
                        
                        middleByte[j] = newByte[j+1];
                    }
                    NSData *newData = [NSData dataWithBytes:middleByte
                                                     length:sizeof(middleByte)];
                    NSLog(@"newdata = %@",newData);
                    NSDictionary *dict = [FLWrapJson dataToNsDict:newData];
                    NSString *moduleStr = dict[@"header"][@"module"];
                    NSLog(@"moduleStr ===== %@",moduleStr);
                    if ([moduleStr isEqualToString:@"profile"]) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:ConnectStatus object:self userInfo:@{@"result_code":dict[@"body"][@"result_code"],@"device_id":dict[@"header"][@"dev_id"]}];
                    }
                    NSData *dictData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                    NSString *jsonStr = [[NSString alloc] initWithData:dictData encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"jsonStr = %@",jsonStr);
                    
                    _state = etx_e;
                    self.putData = nil;
                    
                }else if (newByte[data.length - 2] != 0xa5 ||newByte[data.length - 2] != 0xa5){
                    
                    [self.putData appendData:data];
                    NSLog(@"*******%@",self.putData);
                    _state = pkt_h;
                }
                
            }
                break;
            case pkt_h:
            {
                if (newByte[data.length - 2] == 0xa5 && newByte[data.length - 1] == 0xa5) {
                    
                    [self.putData appendData:data];
                    NSLog(@"~~~~~%@",self.putData);
                    Byte *putDataByte = (Byte *)[self.putData bytes];
                    
                    Byte newbt[self.putData.length-3];
                    
                    for (NSInteger j = 0; j<self.putData.length - 3; j++) {
                        
                        newbt[j] = putDataByte[j+1];
                    }
                    
                    
                    NSData *newData = [NSData dataWithBytes:newbt
                                                     length:sizeof(newbt)];
                    
                    NSLog(@"newdata = %@",newData);
                    NSDictionary *dict = [FLWrapJson dataToNsDict:newData];
                                            NSData *dictData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                                            NSString *jsonStr = [[NSString alloc] initWithData:dictData encoding:NSUTF8StringEncoding];
                    
                    NSLog(@"jsonStr = %@",jsonStr);
                    _state = etx_e;
                    self.putData = nil;
                    
                }else if (newByte[data.length - 2] != 0xa5 ||newByte[data.length - 2] != 0xa5){
                    
                    [self.putData appendData:data];
                    NSLog(@"------%@",self.putData);
                    _state = pkt_h;
                }
            }
                break;
            case etx_e:
                
                break;
            default:
                break;
        }
    }else{
        NSLog(@"未发现特征值.");
    }
}

//隐藏HUD
- (void)hideHUD {
    
    [LCProgressHUD hide];
}

//打开通知
-(void)openNotify
{
    [_per setNotifyValue:YES forCharacteristic:_readChar];
}

//关闭通知
-(void)cancelNotify
{
    [_per setNotifyValue:NO forCharacteristic:_readChar];

}

//断开连接
-(void)cancelPeripheralWith:(CBPeripheral *)per
{
    [_manager cancelPeripheralConnection:_per];
    
}

-(BOOL)connectSucceed
{
    return isLinked;
}

@end
