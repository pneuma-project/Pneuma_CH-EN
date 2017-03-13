//
//  SqliteUtils.h
//  Sprayer
//
//  Created by FangLin on 17/3/9.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SqliteUtils : NSObject

+(void)open;//创建或打开数据库

+(void)close;//关闭数据库

+(void)createUserTable;//创建用户表

+(BOOL)insertUserInfo:(NSString *)sqlStr;//插入数据

+(void)deleteUserInfo;//删除数据

+(NSArray *)selectUserInfo;//查询数据

+(void)updateUserInfo;//跟新数据

@end
