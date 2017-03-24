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

//喷雾器蓝牙数据入口
+(NSString *)dataToNSString:(NSData *)data
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    NSData *sprayData = [data subdataWithRange:NSMakeRange(11, 30)];
    for (int i = 0; i<30; i++) {
        NSInteger yaliData = [FLDrawDataTool NSDataToNSInteger:[sprayData subdataWithRange:NSMakeRange(0+i, 1)]];
        [dataArr addObject:[NSString stringWithFormat:@"%ld",yaliData]];
    }
    NSString *yaliStr=[dataArr componentsJoinedByString:@","];
    return yaliStr;
}

@end
