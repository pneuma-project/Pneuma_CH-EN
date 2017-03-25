//
//  BlueWriteData.m
//  Sprayer
//
//  Created by FangLin on 17/3/22.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "BlueWriteData.h"

@implementation BlueWriteData

+(void)bleConfigWithData:(NSData *)data
{
    Byte dataByte[12];
    dataByte[0] = 0xff;//头部
    dataByte[1] = 0x01;//类型
    dataByte[2] = 0x08;//长度
    dataByte[3] = 0x01;//用户ID
    Byte *timeByte = (Byte *)[data bytes];
    for (int i = 0; i<[data length]; i++) {
        dataByte[4+i] = timeByte[i];
    }
    dataByte[11] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    NSLog(@"newdata == %@",newData);
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

+(void)startTrainData
{
    Byte dataByte[5];
    dataByte[0] = 0xff;//头部
    dataByte[1] = 0x02;//类型
    dataByte[2] = 0x01;//长度
    dataByte[3] = 0x01;//用户ID
    dataByte[4] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

+(void)stopTrainData
{
    Byte dataByte[5];
    dataByte[0] = 0xff;//头部
    dataByte[1] = 0x03;//类型
    dataByte[2] = 0x01;//长度
    dataByte[3] = 0x01;//用户ID
    dataByte[4] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

+(void)sparyData
{
    Byte dataByte[5];
    dataByte[0] = 0xff;//头部
    dataByte[1] = 0x04;//类型
    dataByte[2] = 0x01;//长度
    dataByte[3] = 0x01;//用户ID
    dataByte[4] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    NSLog(@"newdata == %@",newData);
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

+(void)confirmCodeHistoryData
{
    Byte dataByte[5];
    dataByte[0] = 0xff;//头部
    dataByte[1] = 0x0A;//类型
    dataByte[2] = 0x01;//长度
    dataByte[3] = 0x02;//历史确认码
    dataByte[4] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    NSLog(@"确定码:---%@",newData);
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

+(void)confirmCodePresentData
{
    Byte dataByte[5];
    dataByte[0] = 0xff;//头部
    dataByte[1] = 0x0A;//类型
    dataByte[2] = 0x01;//长度
    dataByte[3] = 0x01;//当前确认码
    dataByte[4] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    NSLog(@"确定码:---%@",newData);
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

@end
