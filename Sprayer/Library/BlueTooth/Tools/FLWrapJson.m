//
//  FLWrapJson.m
//  rongXing
//
//  Created by cts on 16/8/11.
//  Copyright © 2016年 cts. All rights reserved.
//

#import "FLWrapJson.h"
#import "FLWrapHeaderTool.h"
#import "FLWrapBobyTool.h"
#import "FLDrawDataTool.h"
#import "SqliteUtils.h"
#import "AddPatientInfoModel.h"
@implementation FLWrapJson

+(NSDictionary *)dataToNsDict:(NSData *)data
{
    
    //NSData *newData = [data subdataWithRange:NSMakeRange(0, 11)];
    //NSLog(@"========%@",newData);
    //得到头部header数据
    NSDictionary *headDict = [FLWrapHeaderTool headerDataToJson:[data subdataWithRange:NSMakeRange(0, 11)]];
    
    NSInteger bobyLength = [FLWrapHeaderTool getBobyLength:[data subdataWithRange:NSMakeRange(9, 2)]];
    
    //解析后面的数据
    NSData *bobyData = [data subdataWithRange:NSMakeRange(11, bobyLength)];
    
    NSString *module = [headDict valueForKey:@"module"];
    
    NSMutableDictionary *allDict = [[NSMutableDictionary alloc] init];
    
    if ([module isEqualToString:@"login"]) {
        
        [allDict setObject:[FLWrapBobyTool loginModToJson:bobyData] forKey:@"body"];
        [allDict setObject:headDict forKey:@"header"];

    }else if ([module isEqualToString:@"profile"]){
        
        [allDict setObject:[FLWrapBobyTool profileModToJson:bobyData] forKey:@"body"];
        [allDict setObject:headDict forKey:@"header"];
        
    }else if ([module isEqualToString:@"beat"]){
        
        [allDict setObject:[FLWrapBobyTool beatModToJson:bobyData] forKey:@"body"];
        [allDict setObject:headDict forKey:@"header"];
        
    }else if ([module isEqualToString:@"update"]){
        
    }else if ([module isEqualToString:@"sync"]){
        
    }else if ([module isEqualToString:@"monitor"]){
        
        [allDict setObject:[FLWrapBobyTool monitorModToJson:bobyData] forKey:@"boby"];
        [allDict setObject:headDict forKey:@"header"];
        
    }else if ([module isEqualToString:@"stats"]){
        
        [allDict setObject:[FLWrapBobyTool statsModToJson:bobyData] forKey:@"body"];
        [allDict setObject:headDict forKey:@"header"];
        
    }else if ([module isEqualToString:@"event"]){
        
        [allDict setObject:[FLWrapBobyTool eventModToJson:bobyData] forKey:@"body"];
        [allDict setObject:headDict forKey:@"header"];
        
    }else if ([module isEqualToString:@"alarm"]){
        
        [allDict setObject:[FLWrapBobyTool alarmModToJson:bobyData] forKey:@"body"];
        [allDict setObject:headDict forKey:@"header"];

    }else if ([module isEqualToString:@"prescription"]){
        
    }else if ([module isEqualToString:@"comfort"]){
        
    }else if ([module isEqualToString:@"setting"]){
        
    }
    return allDict;
}

#pragma mark - 喷雾器蓝牙数据
//时间戳处理
+(NSString *)dataToNSStringTime:(NSData *)data
{
    NSString *timeStr = [NSString stringWithFormat:@"%@",[FLDrawDataTool hexStringFromData:[data subdataWithRange:NSMakeRange(0, 6)]]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ssmmHHddMMYY"];
    NSDate *date = [formatter dateFromString:timeStr];
    NSString *timeStamp = [[NSString alloc] initWithFormat:@"%ld",(long)date.timeIntervalSince1970];
    return timeStamp;
}

//喷雾器蓝牙数据入口
+(NSString *)dataToNSString:(NSData *)data
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<30; i++) {
        NSInteger yaliData = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(0+i, 1)]];
        yaliData = [self yaliDataCalculate:yaliData];
        [dataArr addObject:[NSString stringWithFormat:@"%ld",yaliData]];
    }
    NSString *yaliStr=[dataArr componentsJoinedByString:@","];
    return yaliStr;
}

//压力公式计算
+(NSInteger)yaliDataCalculate:(NSInteger)yaliData
{
    float rate = 6.043*sqrtf(yaliData)-3.2146;
    return rate;
}

//数据总和
+(NSString *)dataSumToNSString:(NSData *)data
{
    NSInteger sum = 0;
    for (int i = 0; i<30; i++) {
        NSInteger yaliData = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(0+i, 1)]];
        yaliData = [self yaliDataCalculate:yaliData];
        sum += yaliData;
    }
    return [NSString stringWithFormat:@"%ld",sum];
}

//BCD编码
+(NSData *)bcdCodeString:(NSString *)bcdstr
{
    int leng = (int)bcdstr.length/2;
    if (bcdstr.length%2 == 1) //判断奇偶数
    {
        leng +=1;
    }
    Byte bbte[leng];
    for (int i = 0; i<leng-1; i++)
    {
        bbte[i] = (int)strtoul([[bcdstr substringWithRange:NSMakeRange(i*2, 2)]UTF8String], 0, 16);
    }
    if (bcdstr.length%2 == 1)
    {
        bbte[leng-1] = (int)strtoul([[bcdstr substringWithRange:NSMakeRange((leng - 1)*2, 1)]UTF8String], 0, 16) *16;
    }else
    {
        bbte[leng-1] = (int)strtoul([[bcdstr substringWithRange:NSMakeRange((leng - 1)*2, 2)]UTF8String], 0, 16);
    }
    NSData *de = [[NSData alloc]initWithBytes:bbte length:leng];
    return de;
}


#pragma mark ---- 获取用户ID
+(int)requireUserIdFromDb
{
    NSArray * arr = [SqliteUtils selectUserInfo];
    if (arr.count!=0) {
        for (AddPatientInfoModel * model in arr) {
            
            if (model.isSelect == 1) {
               
                return model.userId;
            }
            
        }
    }
    return 0;
    
}

@end
