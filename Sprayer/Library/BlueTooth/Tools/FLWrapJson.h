//
//  FLWrapJson.h
//  rongXing
//
//  Created by cts on 16/8/11.
//  Copyright © 2016年 cts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FLWrapJson : NSObject

//数据入口
+(NSDictionary *)dataToNsDict:(NSData *)data;

//喷雾器蓝牙数据入口
+(NSString *)dataToNSString:(NSData *)data;

@end
