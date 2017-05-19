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
{
    FMDatabase *db;
}
+(SqliteUtils *)sharedManager
{
    SqliteUtils *api;
    
    if (api==nil) {
        api=[[SqliteUtils alloc]init];
    }
    return api;
}
// 打开数据库
- (void)open {
    // 1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"sprayerDb.sqlite"];
    
    // 2.得到数据库
    db = [FMDatabase databaseWithPath:filename];
    // 3.打开数据库
    if ([db open]) {
        NSLog(@"打开operDB成功");
    }else {
        NSLog(@"打开operDB失败");
    }
}
//-----------------用户信息----------------//
-(void)createUserTable
{
    [self open];
    // 4.创表
    if ([db open]) {
        BOOL result = [db executeUpdate:@"create table if not exists userInfo (id integer primary key autoincrement,name text,phone text,sex text,age text,race text,height text,weight text,device_serialnum text,relationship text,isselect integer,trainData text,medical text,allergy text);"];
        if (result) {
            NSLog(@"成功创表");
        } else {
            NSLog(@"创表失败");
        }
        [db close];
    }
}

-(BOOL)insertUserInfo:(NSString *)sqlStr
{
    [self createUserTable];
    if ([db open]) {
            BOOL res = [db executeUpdate:sqlStr];
            
            if (res) {
                NSLog(@"数据插入表成功");
            } else {
                NSLog(@"数据插入表失败");
            }
        [db close];
        return res;
        }
    return NO;
   }


-(void)deleteUserInfo:(NSString *)idStr;
{
    [self createUserTable];
    if ([db open]) {
        BOOL res1 = [db executeUpdate:[NSString stringWithFormat:@"delete from userInfo where id = %@;",idStr]];
        BOOL res2 = [db executeUpdate:[NSString stringWithFormat:@"delete from RealTimeBTData where id = %@;",idStr]];
        BOOL res3 = [db executeUpdate:[NSString stringWithFormat:@"delete from historyBTDb where id = %@;",idStr]];
        
        if (res1&&res2&&res3) {
            NSLog(@"删除相关用户数据表成功");
        } else {
            NSLog(@"删除相关用户数据表失败");
        }
    }
    
    [db close];
}

-(NSArray *)selectUserInfo
{
    [self createUserTable];
    NSMutableArray * mutArr = [NSMutableArray array];

    if ([db open]) {
        NSString * sql = @"select * from userInfo";
        FMResultSet * rs = [db executeQuery:sql];
               while ([rs next]) {
//            NSLog(@"查询语句正确");
            AddPatientInfoModel * model = [[AddPatientInfoModel alloc]init];
            model.userId = [rs intForColumn:@"id"];
            model.name = [rs stringForColumn:@"name"];
            model.phone = [rs stringForColumn:@"phone"];
            model.sex = [rs stringForColumn:@"sex"];
            model.age = [rs stringForColumn:@"age"];
            model.race = [rs stringForColumn:@"race"];
            model.height = [rs stringForColumn:@"height"];
            model.weight = [rs stringForColumn:@"weight"];
            model.medical = [rs stringForColumn:@"medical"];
            model.allergy = [rs stringForColumn:@"allergy"];
            model.deviceSerialNum = [rs stringForColumn:@"device_serialnum"];
            model.relationship = [rs stringForColumn:@"relationship"];
            model.isSelect = [rs intForColumn:@"isselect"];
            model.btData = [rs stringForColumn:@"trainData"];
            
            [mutArr addObject:model];
        }
        [db close];
    }

   
    return mutArr;

}

-(BOOL)updateUserInfo:(NSString *)sqlStr
{
    [self createUserTable];
    if ([db open]) {
        NSString *updateSql = sqlStr;
        BOOL res = [db executeUpdate:updateSql];
        if (res) {
            NSLog(@"修改数据成功");
        } else {
            NSLog(@"修改数据失败");
        }
        [db close];
        return res;
        
        
    }
    return NO;
}

//----------------实时蓝牙数据------------//
- (void)openRealTimeBTData {
    // 1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"realTimeBTDb.sqlite"];
    
    // 2.得到数据库
    db = [FMDatabase databaseWithPath:filename];
    // 3.打开数据库
    if ([db open]) {
        NSLog(@"打开operDB成功");
    }else {
        NSLog(@"打开operDB失败");
    }

}

-(void)createRealTimeBTTable
{
    [self openRealTimeBTData];
    // 4.创表
    if ([db open]) {
        BOOL result = [db executeUpdate:@"create table if not exists RealTimeBTData (id integer primary key autoincrement,userid integer,nowtime text,btData text,sumBtData text);"];
        if (result) {
            NSLog(@"成功创表");
        } else {
            NSLog(@"创表失败");
        }
        [db close];
    }

}
-(BOOL)insertRealBTInfo:(NSString *)sqlStr
{
    [self createRealTimeBTTable];
    if ([db open]) {
        BOOL res = [db executeUpdate:sqlStr];
        
        if (res) {
            NSLog(@"数据插入表成功");
        } else {
            NSLog(@"数据插入表失败");
        }
         [db close];
        return res;
    }
    
    return NO;
}
-(NSArray *)selectRealBTInfo
{
    [self createRealTimeBTTable];
    NSMutableArray * mutArr = [NSMutableArray array];
    
    if ([db open]) {
        NSString * sql = @"select * from RealTimeBTData";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
//            NSLog(@"查询语句正确");
             BlueToothDataModel * model = [[BlueToothDataModel alloc]init];
            model.userId = [rs intForColumn:@"userid"];
            model.timestamp = [rs stringForColumn:@"nowtime"];
            model.blueToothData = [rs stringForColumn:@"btData"];
            model.allBlueToothData = [rs stringForColumn:@"sumBtData"];
            [mutArr addObject:model];
        }
        [db close];
    }
    return mutArr;
}
-(void)deleteRealTimeBTData:(NSString *)sqlStr
{
    [self createRealTimeBTTable];
    if ([db open]) {
        
        BOOL res = [db executeUpdate:sqlStr];
        
        if (res) {
            NSLog(@"删除实时蓝牙数据表成功");
        } else {
            NSLog(@"删除实时蓝牙数据表失败");
        }
    }
 
}
//----------------历史蓝牙数据------------//
- (void)openHistoryBTData {
    // 1.获得数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"historyBTDb.sqlite"];
    
    // 2.得到数据库
    db = [FMDatabase databaseWithPath:filename];
    // 3.打开数据库
    if ([db open]) {
        NSLog(@"打开operDB成功");
    }else {
        NSLog(@"打开operDB失败");
    }

}

-(void)createHistoryBTTable
{
    [self openHistoryBTData];
    // 4.创表
    if ([db open]) {
        BOOL result = [db executeUpdate:@"create table if not exists historyBTDb (id integer primary key autoincrement,userid integer,nowtime text,btData text,sumBtData text,date text);"];
        if (result) {
            NSLog(@"成功创表");
        } else {
            NSLog(@"创表失败");
        }
        [db close];
    }

}
-(BOOL)insertHistoryBTInfo:(NSString *)sqlStr
{
    [self createHistoryBTTable];
    if ([db open]) {
        BOOL res = [db executeUpdate:sqlStr];
        
        if (res) {
            NSLog(@"数据插入表成功");
        } else {
            NSLog(@"数据插入表失败");
        }
         [db close];
        return res;
    }
    
    return NO;
   
}
-(NSArray *)selectHistoryBTInfo
{
    [self createHistoryBTTable];
    NSMutableArray * mutArr = [NSMutableArray array];
    
    if ([db open]) {
        NSString * sql = @"select * from historyBTDb";
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSLog(@"查询语句正确");
            BlueToothDataModel * model = [[BlueToothDataModel alloc]init];
            model.userId = [rs intForColumn:@"userid"];
            model.timestamp = [rs stringForColumn:@"nowtime"];
            model.blueToothData = [rs stringForColumn:@"btData"];
            model.allBlueToothData = [rs stringForColumn:@"sumBtData"];
            [mutArr addObject:model];
        }
        [db close];
    }
    return mutArr;
}
-(void)deleteHistoryBTData:(NSString *)sqlStr
{
    [self createHistoryBTTable];
    if ([db open]) {
      
        BOOL res = [db executeUpdate:sqlStr];
        
        if (res) {
            NSLog(@"删除历史数据表成功");
        } else {
            NSLog(@"删除历史数据表失败");
        }
    }
 
}
@end
