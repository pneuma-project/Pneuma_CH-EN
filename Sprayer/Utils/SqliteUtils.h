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

+(sqlite3 *)open;

+(void)close;

@end
