//
//  SyTableViewCell.h
//  SY_CheShi
//
//  Created by 钱学明 on 16/1/26.
//  Copyright © 2016年 钱学明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SyTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel * titleLable;
@property (nonatomic,strong)UILabel * rssiLable;
//@property (nonatomic,strong)UIButton * cellBtn;

-(void)addUI;

@end
