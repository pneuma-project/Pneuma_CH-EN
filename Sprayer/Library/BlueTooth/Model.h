//
//  Model.h
//  SY_CheShi
//
//  Created by 钱学明 on 16/1/26.
//  Copyright © 2016年 钱学明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface Model : NSObject

@property (nonatomic, strong)CBPeripheral * peripheral;
@property (nonatomic, assign)int num;

@end
