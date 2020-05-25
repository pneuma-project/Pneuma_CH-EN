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
#import "UserDefaultsUtils.h"

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
//-----------------吸雾数据相关-----------------//
//喷雾蓝牙数据入口
+(NSString *)dataToNSString:(NSData *)data
{
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<data.length; i++) {
        NSInteger yaliData = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(0+i, 1)]];
        float yaliNum = (yaliData * 130)/60;
        yaliNum = [self yaliDataCalculate:yaliNum];
        [dataArr addObject:[NSString stringWithFormat:@"%.3f",yaliNum]];
    }
    NSString *yaliStr=[dataArr componentsJoinedByString:@","];
    return yaliStr;
}

//压力公式计算
+(float)yaliDataCalculate:(float)yaliData
{
    if (yaliData <= 0) {
        return 0;
    }else{
        float k1 = 0;
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"k1flowValue"]) {
            k1 = 0;
        }else {
            NSString *value = [UserDefaultsUtils valueWithKey:@"k1flowValue"];
            k1 = [value floatValue];
        }
        float k2 = 6.71;
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"k2flowValue"]) {
            k2 = 6.71;
        }else {
            NSString *value = [UserDefaultsUtils valueWithKey:@"k2flowValue"];
            k2 = [value floatValue];
        }
        float rate = k1 + k2*sqrtf(yaliData);
        return rate;
    }
}

//数据总和
+(NSString *)dataSumToNSString:(NSData *)data
{
    float sum = 0;
    for (int i = 0; i<data.length; i++) {
        NSInteger yaliData = [FLDrawDataTool NSDataToNSInteger:[data subdataWithRange:NSMakeRange(i, 1)]];
        float yaliNum = (yaliData * 130)/60;
        yaliNum = [self yaliDataCalculate:yaliNum];
        sum += yaliNum;
    }
    return [NSString stringWithFormat:@"%.3f",sum/600.0];
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

//时间戳处理
+(NSString *)dataToNSStringTime:(NSData *)data
{
    NSString *timeStr = [FLDrawDataTool hexStringFromData:[data subdataWithRange:NSMakeRange(0, 6)]];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSInteger i = timeStr.length; i > 0; i -= 2) {
        [arr addObject:[timeStr substringWithRange:NSMakeRange(i-2, 2)]];
    }
    NSString *time = [arr componentsJoinedByString:@"-"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YY-MM-dd-HH-mm-ss"];
    NSDate *date = [formatter dateFromString:time];
    NSString *timeStamp = [[NSString alloc] initWithFormat:@"%ld",(long)date.timeIntervalSince1970];
    return timeStamp;
}

//-----------------呼气数据相关-----------------//
+(NSString *)exhaleDataToNSString:(NSData *)data{
    NSMutableArray *slmArr = [[NSMutableArray alloc] init];
    NSMutableArray *yaliArr = [[NSMutableArray alloc] init];
    NSMutableArray *yaliOneArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<data.length; i+=2) {
        NSInteger yaliData = abs([self signedDataTointWithData:[data subdataWithRange:NSMakeRange(i, 2)] Location:0 Offset:2]);//[self input0x16String:[FLDrawDataTool hexStringFromData:[data subdataWithRange:NSMakeRange(i, 2)]]]
        float yaliNum = yaliData/60.0;
        [yaliOneArr addObject:@(yaliNum)];
    }
    
    for (int i = 0; i<yaliOneArr.count; i+=1) {
//        float yaliValue = 0.0;
//        if (i == 0) {
//            yaliValue = [yaliOneArr[i] floatValue]/2;
//        }else {
//            yaliValue = ([yaliOneArr[i-1] floatValue]+[yaliOneArr[i] floatValue])/2;
//        }
        float yaliData = [self exhaleDataCalculate:[yaliOneArr[i] floatValue]];
        [yaliArr addObject:[NSString stringWithFormat:@"%.5f",yaliData]];
    }
    for (int j = 0; j<yaliArr.count; j++) {
        float slmValue = 0.0;
        if (j == 0) {
            slmValue = [yaliArr[j] floatValue]/2;
        }else {
            slmValue = ([yaliArr[j-1] floatValue]+[yaliArr[j] floatValue])/2;
        }
        [slmArr addObject:[NSString stringWithFormat:@"%.4f",slmValue]];
    }
    NSString *yaliStr=[slmArr componentsJoinedByString:@","];
    return yaliStr;
}

//压力公式计算
+(float)exhaleDataCalculate:(float)exhaleData
{
    float rate = 0.0;
//    if (exhaleData <= 90) {
//        rate = 0.0004*powf(exhaleData, 3) - 0.0588*powf(exhaleData, 2) + 4.4107*exhaleData;
//    }else if (exhaleData > 90 && exhaleData <= 194) {
//        rate = 0.000004*powf(exhaleData, 3) - 0.0047*powf(exhaleData, 2) + 2.7935*exhaleData;
//    }else if (exhaleData > 194 && exhaleData <= 326) {
//        rate = exhaleData + 200;
//    }else {
//        rate = exhaleData + (416/exhaleData)*157;
//    }
    if (exhaleData >= 546) {
        rate = 546;
    }else {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"lungTestData" ofType:@"plist"];
        NSMutableDictionary *plistDic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
        
        if (floorf(exhaleData) == exhaleData) {
            rate = [[plistDic objectForKey:[NSString stringWithFormat:@"%.0f",exhaleData]] floatValue];
        }else {
            float slm1 = [[plistDic objectForKey:[NSString stringWithFormat:@"%.0f",floorf(exhaleData)]] floatValue];
            float slm2 = [[plistDic objectForKey:[NSString stringWithFormat:@"%.0f",ceilf(exhaleData)]] floatValue];
            rate = slm1 + ((exhaleData-floorf(exhaleData)) * (slm2-slm1));
        }
    }
    return rate;
}


//有符号16进制转10进制
+ (int)input0x16String:(NSString *)string{
    char *_0x16String = (char *)string.UTF8String;
    NSMutableString *binaryString = [[NSMutableString alloc] init];
    for (int i = 0; i < string.length; i++) {
        char c = _0x16String[i];
        NSString *binary = [self binaryWithHexadecimal:[NSString stringWithFormat:@"%c",c]];
        [binaryString appendString:binary];
    }
    
    if ([binaryString characterAtIndex:0] == '1') {
        //反码
        for (int i = (int)binaryString.length - 1; i > 0; i--) {
            char c = [binaryString characterAtIndex:i];
            c = c^0x1;
            [binaryString replaceCharactersInRange:NSMakeRange(i, 1) withString:[NSString stringWithFormat:@"%c",c]];
        }
        
        //补码
        BOOL flag = NO; //进位
        NSInteger lastIndex = binaryString.length - 1;
        char lastChar = [binaryString characterAtIndex:lastIndex];
        if (lastChar == '0') {
            lastChar = '1';
        } else {
            lastChar = '0';
            flag = YES;
        }
        
        [binaryString replaceCharactersInRange:NSMakeRange(lastIndex, 1) withString:[NSString stringWithFormat:@"%c",lastChar]];
        
        if (flag) {
            for (int i = (int)binaryString.length - 2; i > 0; i--) {
                char c = [binaryString characterAtIndex:i];
                if (flag) {//进位
                    if (c == '0') {
                        c = '1';
                        flag = NO;
                        [binaryString replaceCharactersInRange:NSMakeRange(i, 1) withString:[NSString stringWithFormat:@"%c",c]];
                        break;
                    } else if (c == '1'){
                        c = '0';
                        flag = YES;
                        [binaryString replaceCharactersInRange:NSMakeRange(i, 1) withString:[NSString stringWithFormat:@"%c",c]];
                    }
                }
            }
        }
    }
    
    int result = 0;
    int bit = 0;
    //计算
    for (int i = (int)binaryString.length - 1; i > 0; i--) {
        char c = [binaryString characterAtIndex:i];
        if (c == '1') {
            result += pow(2, bit);
        }
        ++bit;
    }
    if ([binaryString characterAtIndex:0] == '1') {
        result = result *-1;
    }
    return result;
}
+ (NSString *)binaryWithHexadecimal:(NSString *)string{
    // 现将16进制转换车无符号的10进制
    long a = strtoul(string.UTF8String, NULL, 16);
    NSMutableString *binary = [[NSMutableString alloc] init];
    while (a/2 !=0) {
        [binary insertString:[NSString stringWithFormat:@"%ld",a%2] atIndex:0];
        a = a/2;
    }
    
    [binary insertString:[NSString stringWithFormat:@"%ld",a%2] atIndex:0];
    
    //不够4位的高位补0
    while (binary.length%4 !=0) {
        [binary insertString:@"0" atIndex:0];
    }
    return binary;
}

// 转为本地大小端模式 返回Signed类型的数据
+(signed short)signedDataTointWithData:(NSData *)data Location:(NSInteger)location Offset:(NSInteger)offset {
    signed short value=0;
//    NSData *intdata= [data subdataWithRange:NSMakeRange(location, offset)];
    if (offset==2) {
        value=CFSwapInt16BigToHost(*(short*)([data bytes]));
    }
    else if (offset==4) {
        value = CFSwapInt32BigToHost(*(int*)([data bytes]));
    }
    else if (offset==1) {
        signed char *bs = (signed char *)[[data subdataWithRange:NSMakeRange(location, 1) ] bytes];
        value = *bs;
    }
    return value;
}

// 转为本地大小端模式 返回Unsigned类型的数据
+(unsigned int)unsignedDataTointWithData:(NSData *)data Location:(NSInteger)location Offset:(NSInteger)offset {
    unsigned int value=0;
    NSData *intdata= [data subdataWithRange:NSMakeRange(location, offset)];
    
    if (offset==2) {
        value=CFSwapInt16BigToHost(*(int*)([intdata bytes]));
    }
    else if (offset==4) {
        value = CFSwapInt32BigToHost(*(int*)([intdata bytes]));
    }
    else if (offset==1) {
        unsigned char *bs = (unsigned char *)[[data subdataWithRange:NSMakeRange(location, 1) ] bytes];
        value = *bs;
    }
    return value;
}

#pragma mark ---- 获取用户ID和名称
+(NSArray *)requireUserIdFromDb
{
    NSArray * arr = [[SqliteUtils sharedManager]selectUserInfo];
    if (arr.count!=0) {
        for (AddPatientInfoModel * model in arr) {
            if (model.isSelect == 1) {
                return @[[NSString stringWithFormat:@"%d",model.userId],model.name];
            }
        }
    }
    return nil;
}

//获取药品名称
+(NSString *)getMedicineNameToInt:(NSData *)data
{
    NSInteger type = [FLDrawDataTool NSDataToNSInteger:data];
    if (type == 1 || type == 3) { //Albutero
        return @"Albuterol sulfate";
    }else if (type == 2 || type == 4) { //Tiotropium
        return @"Tiotropium bromide";
    }else if (type == 5 || type == 0) {  //无药瓶
        return @"No cartridge";
    }
    return @"";
}

//获取药品信息
+(NSString *)getMedicineInfo:(NSData *)data AndDrugInjectionTime:(NSData *)data1 AndDrugExpirationTime:(NSData *)data2 AndDrugOpeningTime:(NSData *)data3 AndVolatilizationTime:(NSData *)data4
{
    NSInteger type = [FLDrawDataTool NSDataToNSInteger:data];
    NSString *timeStamp1 = [NSString stringWithFormat:@"%ld",(long)[FLDrawDataTool NSDataToNSInteger:data1]];
    NSString *timeStamp2 = [NSString stringWithFormat:@"%ld",(long)[FLDrawDataTool NSDataToNSInteger:data2]];
    NSString *timeStamp3 = [NSString stringWithFormat:@"%ld",(long)[FLDrawDataTool NSDataToNSInteger:data3]];
    NSInteger volatilizationTime = [FLDrawDataTool NSDataToNSInteger:data4];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *confromTimesp1 = [NSDate dateWithTimeIntervalSince1970:[timeStamp1 doubleValue]];
    NSString * confromTimespStr1 = [formatter stringFromDate:confromTimesp1];
    NSDate *confromTimesp2 = [NSDate dateWithTimeIntervalSince1970:[timeStamp2 doubleValue]];
    NSString * confromTimespStr2 = [formatter stringFromDate:confromTimesp2];
    NSDate *confromTimesp3 = [NSDate dateWithTimeIntervalSince1970:[timeStamp3 doubleValue]];
    NSString * confromTimespStr3 = [formatter stringFromDate:confromTimesp3];
    if (type == 1) { //Albutero
        return [NSString stringWithFormat: @"Drug: Albuterol sulfate\nDose: 108 mcg (equivalent to 90 mcg albuterol base)\nLot #:  231-148-321\nFill date: %@\nExpiration date: %@\nData of first use: %@\nTotal evaporation time: %lds",confromTimespStr1,confromTimespStr2,confromTimespStr3,(long)volatilizationTime];
    }else if (type == 2) { //Tiotropium
        return [NSString stringWithFormat: @"Drug: Tiotropium bromide\nDose: 2.5 mcg\nLot #: 232-147-112\nFill date: %@\nExpiration date: %@\nData of first use: %@\nTotal evaporation time: %lds",confromTimespStr1,confromTimespStr2,confromTimespStr3,(long)volatilizationTime];
    }else if (type == 3) {
        return [NSString stringWithFormat: @"Drug: Albuterol sulfate\nDose: 108 mcg (equivalent to 90 mcg albuterol base)\nLot #:  231-148-323\nFill date: %@\nExpiration date: %@\nData of first use: %@\nTotal evaporation time: %lds",confromTimespStr1,confromTimespStr2,confromTimespStr3,(long)volatilizationTime];
    }else if (type == 4) {
        return [NSString stringWithFormat: @"Drug: Tiotropium bromide\nDose: 2.5 mcg\nLot #: 232-147-114\nFill date: %@\nExpiration date: %@\nData of first use: %@\nTotal evaporation time: %lds",confromTimespStr1,confromTimespStr2,confromTimespStr3,(long)volatilizationTime];
    }else if (type == 5 || type == 0) {  //无药瓶
        return @"No cartridge";
    }
    return @"";
}

@end
