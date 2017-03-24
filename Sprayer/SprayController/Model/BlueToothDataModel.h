//
//  BlueToothDataModel.h
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/22.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "JSONModel.h"

@interface BlueToothDataModel : JSONModel

@property(nonatomic,assign) int userId;

@property(nonatomic,strong) NSString * timestamp;

@property(nonatomic,strong) NSString * blueToothData;

@property(nonatomic,strong) NSString * allBlueToothData;

@end
