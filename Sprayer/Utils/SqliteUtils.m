//
//  SqliteUtils.m
//  Sprayer
//
//  Created by FangLin on 17/3/9.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "SqliteUtils.h"
#import "AddPatientInfoModel.h"
#import "BlueToothDataModel.h"
@implementation SqliteUtils

// 创建数据库指针
static sqlite3 *db = nil;

// 打开数据库
+ (void)open {
    //设置数据库的路径
    NSString * fileName = [[NSSearchPathForDirectoriesInDomains(13, 1, 1)lastObject]stringByAppendingPathComponent:@"sprayerDb.sqlite"];
    NSLog(@"%@",fileName);
    //打开数据库 如果没有打开的数据库就建立一个
    //第一个参数是数据库的路径 注意要转换为c的字符串
    if (sqlite3_open(fileName.UTF8String, &db) == SQLITE_OK) {
        NSLog(@"打开数据库成功");
            }else{
        NSLog(@"打开数据库失败");
    }
}
// 关闭数据库
+ (void)close {
    
    // 关闭数据库
    sqlite3_close(db);
    
    // 将数据库的指针置空
    db = nil;
}
//-----------------用户信息----------------//
+(void)createUserTable
{
    //打开数据库成功后建立数据库内的表
    //操作命令的字符串
    //注意字符串的结束处有 ; 号
    NSString * sql = @"create table if not exists userInfo (id integer primary key autoincrement,name text,phone text,sex text,age text,race text,height text,weight text,medical_history text,allergy_history text,device_serialnum text,relationship text,isselect integer,trainData text,macAddress text);";
    char * errmsg;
    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"建表失败 -- %s",errmsg);
    }else{
        NSLog(@"建表成功");
    }
}

+(BOOL)insertUserInfo:(NSString *)sqlStr
{
    [self open];
    [self createUserTable];
        char * errmsg;
        sqlite3_exec(db, sqlStr.UTF8String, NULL, NULL, &errmsg);
        if (errmsg) {
            NSLog(@"插入失败--%s",errmsg);
            [self close];
            return NO;
        }else{
            NSLog(@"插入成功");
            [self close];
            return YES;
        }
    
}

+(void)deleteUserInfo
{
    //这里删除随机id 大于3 小于6的
    //操作代码(sql)
    //最好先判断能否进入数据库在执行操作 这里偷下懒
    NSString * sql = @"delete from userInfo where id > 3 and id < 6;";
    char * errmsg;
    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"删除失败--%s",errmsg);
    }else{
        NSLog(@"删除成功");
    }
}

+(NSArray *)selectUserInfo
{
    [self open];
    [self createUserTable];
    NSString * sql = @"select * from userInfo";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    NSMutableArray * mutArr = [NSMutableArray array];
    //  判断语句是否正确
    if (result == SQLITE_OK) {
        NSLog(@"查询语句正确");
        //  进行查询
        //  如果 查询结果 返回 SQLITE_ROW 那么查询正确 执行循环
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            AddPatientInfoModel * model = [[AddPatientInfoModel alloc]init];
            model.userId = sqlite3_column_int(stmt, 0);
            model.name = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
            model.phone = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
            model.sex = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 3) encoding:NSUTF8StringEncoding];
            model.age = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 4) encoding:NSUTF8StringEncoding];
            model.race = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 5) encoding:NSUTF8StringEncoding];
            model.height = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 6) encoding:NSUTF8StringEncoding];
            model.weight = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 7) encoding:NSUTF8StringEncoding];
            model.deviceSerialNum = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 10) encoding:NSUTF8StringEncoding];
            model.relationship = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 11) encoding:NSUTF8StringEncoding];
            model.isSelect = [[NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 12) encoding:NSUTF8StringEncoding]integerValue];
            model.btData = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 13) encoding:NSUTF8StringEncoding];
            [mutArr addObject:model];
           
        }
    } else {
        NSLog(@"查询语句错误");
    }
    
    //  查询语句错误 也要释放跟随指针
    sqlite3_finalize(stmt);
 
    return mutArr;

}

+(BOOL)updateUserInfo:(NSString *)sqlStr
{
    [self open];
    [self createUserTable];
//    NSString * sql = @"update userInfo set name = 'hello-world' where id = 9;";
    char * errmsg;
    sqlite3_exec(db, sqlStr.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"修改失败--%s",errmsg);
        return NO;
    }else{
        NSLog(@"修改成功");
        return YES;
    }
}

//----------------实时蓝牙数据------------//
+ (void)openRealTimeBTData {
    //设置数据库的路径
    NSString * fileName = [[NSSearchPathForDirectoriesInDomains(13, 1, 1)lastObject]stringByAppendingPathComponent:@"realTimeBTDb.sqlite"];
    NSLog(@"%@",fileName);
    if (sqlite3_open(fileName.UTF8String, &db) == SQLITE_OK) {
        NSLog(@"打开数据库成功");
    }else{
        NSLog(@"打开数据库失败");
    }
}

+(void)createRealTimeBTTable
{
    NSString * sql = @"create table if not exists RealTimeBTData (id integer primary key autoincrement,userid integer,nowtime text,btData text,sumBtData text);";
    char * errmsg;
    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"建表失败 -- %s",errmsg);
    }else{
        NSLog(@"建表成功");
    }
    
}
+(BOOL)insertRealBTInfo:(NSString *)sqlStr
{
    [self openRealTimeBTData];
    [self createRealTimeBTTable];
    
    char * errmsg;
    sqlite3_exec(db, sqlStr.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"插入失败--%s",errmsg);
        [self close];
        return NO;
    }else{
        NSLog(@"插入成功");
        [self close];
        return YES;
    }

}
+(NSArray *)selectRealBTInfo
{
    [self openRealTimeBTData];
    [self createRealTimeBTTable];
    NSString * sql = @"select * from RealTimeBTData";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    NSMutableArray * mutArr = [NSMutableArray array];
    //  判断语句是否正确
    if (result == SQLITE_OK) {
        NSLog(@"查询语句正确");
        //  进行查询
        //  如果 查询结果 返回 SQLITE_ROW 那么查询正确 执行循环
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            BlueToothDataModel * model = [[BlueToothDataModel alloc]init];
            model.userId= sqlite3_column_int(stmt, 1);
            model.timestamp = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
            model.blueToothData = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 3) encoding:NSUTF8StringEncoding];
            [mutArr addObject:model];
            
        }
    } else {
        NSLog(@"查询语句错误");
    }
    
    //  查询语句错误 也要释放跟随指针
    sqlite3_finalize(stmt);
    
    return mutArr;

    
    
    
}

//----------------历史蓝牙数据------------//
+ (void)openHistoryBTData {
    //设置数据库的路径
    NSString * fileName = [[NSSearchPathForDirectoriesInDomains(13, 1, 1)lastObject]stringByAppendingPathComponent:@"historyBTDb.sqlite"];
    NSLog(@"%@",fileName);
    if (sqlite3_open(fileName.UTF8String, &db) == SQLITE_OK) {
        NSLog(@"打开数据库成功");
    }else{
        NSLog(@"打开数据库失败");
    }
}

+(void)createHistoryBTTable
{
    NSString * sql = @"create table if not exists historyBTDb (id integer primary key autoincrement,userid integer,nowtime text,btData text,sumBtData text);";
    char * errmsg;
    sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"建表失败 -- %s",errmsg);
    }else{
        NSLog(@"建表成功");
    }
    
}
+(BOOL)insertHistoryBTInfo:(NSString *)sqlStr
{
    [self openHistoryBTData];
    [self createHistoryBTTable];
    
    char * errmsg;
    sqlite3_exec(db, sqlStr.UTF8String, NULL, NULL, &errmsg);
    if (errmsg) {
        NSLog(@"插入失败--%s",errmsg);
        [self close];
        return NO;
    }else{
        NSLog(@"插入成功");
        [self close];
        return YES;
    }
    
}
+(NSArray *)selectHistoryBTInfo
{
    [self openHistoryBTData];
    [self createHistoryBTTable];
    NSString * sql = @"select * from historyBTDb";
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL);
    NSMutableArray * mutArr = [NSMutableArray array];
    //  判断语句是否正确
    if (result == SQLITE_OK) {
        NSLog(@"查询语句正确");
        //  进行查询
        //  如果 查询结果 返回 SQLITE_ROW 那么查询正确 执行循环
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            BlueToothDataModel * model = [[BlueToothDataModel alloc]init];
            model.userId= sqlite3_column_int(stmt, 1);
            model.timestamp = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
            model.blueToothData = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 3) encoding:NSUTF8StringEncoding];
            model.allBlueToothData = [NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 4) encoding:NSUTF8StringEncoding];
            [mutArr addObject:model];
            
        }
    } else {
        NSLog(@"查询语句错误");
    }
    
    //  查询语句错误 也要释放跟随指针
    sqlite3_finalize(stmt);
    
    return mutArr;
    
 
}

@end
