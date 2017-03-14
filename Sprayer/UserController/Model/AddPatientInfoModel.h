//
//  AddPatientInfoModel.h
//  Sprayer
//
//  Created by 黄上凌 on 2017/3/13.
//  Copyright © 2017年 FangLin. All rights reserved.
//

#import "JSONModel.h"

@interface AddPatientInfoModel : JSONModel

@property(nonatomic,strong) NSString *   name;
@property(nonatomic,strong) NSString *   relationship;
@property(nonatomic,strong) NSString *   sex;
@property(nonatomic,strong) NSString *   age;
@property(nonatomic,strong) NSString *   race;
@property(nonatomic,strong) NSString *   height;
@property(nonatomic,strong) NSString *   weight;
@property(nonatomic,strong) NSString *   phone;
@property(nonatomic,strong) NSString *   deviceSerialNum;
@property(nonatomic,assign) NSInteger    isSelect;
@end
