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
    dataByte[0] = 0xFF;//头部
    dataByte[1] = 0x01;//类型
    dataByte[2] = 0x08;//长度
    dataByte[3] = 0x01;//用户ID
    Byte *timeByte = (Byte *)[data bytes];
    for (int i = 0; i<[data length]; i++) {
        dataByte[4+i] = timeByte[i];
    }
    dataByte[11] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
   
}

+(void)startTrainData:(NSData *)data
{
    Byte dataByte[5];
    dataByte[0] = 0xFF;//头部
    dataByte[1] = 0x02;//类型
    dataByte[2] = 0x01;//长度
    dataByte[3] = 0x01;//用户ID
    dataByte[4] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

+(void)stopTrainData:(NSData *)data
{
    Byte dataByte[5];
    dataByte[0] = 0xFF;//头部
    dataByte[1] = 0x03;//类型
    dataByte[2] = 0x01;//长度
    dataByte[3] = 0x01;//用户ID
    dataByte[4] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

+(void)sparyData:(NSData *)data
{
    Byte dataByte[5];
    dataByte[0] = 0xFF;//头部
    dataByte[1] = 0x04;//类型
    dataByte[2] = 0x01;//长度
    dataByte[3] = 0x01;//用户ID
    dataByte[4] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

+(void)confirmCodeData:(NSData *)data
{
    Byte dataByte[5];
    dataByte[0] = 0xFF;//头部
    dataByte[1] = 0x0A;//类型
    dataByte[2] = 0x01;//长度
    dataByte[3] = 0xAA;
    dataByte[4] = 0xAB;//结束
    NSData *newData = [NSData dataWithBytes:&dataByte length:sizeof(dataByte)];
    //写数据到蓝牙
    [[BlueToothManager getInstance] sendDataWithString:newData];
}

@end
