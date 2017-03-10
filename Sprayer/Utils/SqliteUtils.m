//
//  SqliteUtils.m
//  Sprayer
//
//  Created by FangLin on 17/3/9.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "SqliteUtils.h"

@implementation SqliteUtils

// 创建数据库指针
static sqlite3 *db = nil;

// 打开数据库
+ (sqlite3 *)open {
    
    // 此方法的主要作用是打开数据库
    // 返回值是一个数据库指针
    // 因为这个数据库在很多的SQLite API（函数）中都会用到，我们声明一个类方法来获取，更加方便
    
    // 懒加载
    if (db != nil) {
        return db;
    }
    
    // 获取Documents路径
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    
    // 生成数据库文件在沙盒中的路径
    NSString *sqlPath = [docPath stringByAppendingPathComponent:@"sprayerDB.sqlite"];
    
    // 创建文件管理对象
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 判断沙盒路径中是否存在数据库文件，如果不存在才执行拷贝操作，如果存在不在执行拷贝操作
    if ([fileManager fileExistsAtPath:sqlPath] == NO) {
        // 获取数据库文件在包中的路径
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sprayerDB" ofType:@"sqlite"];
        
        // 使用文件管理对象进行拷贝操作
        // 第一个参数是拷贝文件的路径
        // 第二个参数是将拷贝文件进行拷贝的目标路径
        [fileManager copyItemAtPath:filePath toPath:sqlPath error:nil];
        
    }
    
    // 打开数据库需要使用一下函数
    // 第一个参数是数据库的路径（因为需要的是C语言的字符串，而不是NSString所以必须进行转换）
    // 第二个参数是指向指针的指针
    sqlite3_open([sqlPath UTF8String], &db);
    
    return db;
}

// 关闭数据库
+ (void)close {
    
    // 关闭数据库
    sqlite3_close(db);
    
    // 将数据库的指针置空
    db = nil;
}

@end
