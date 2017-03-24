//
//  BlueWriteData.h
//  Sprayer
//
//  Created by FangLin on 17/3/22.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlueWriteData : NSObject

+(void)bleConfigWithData:(NSData *)data;

+(void)startTrainData;

+(void)stopTrainData;

+(void)sparyData;

+(void)confirmCodeData;

@end
