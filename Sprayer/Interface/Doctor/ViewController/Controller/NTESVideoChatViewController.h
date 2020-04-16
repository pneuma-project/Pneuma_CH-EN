//
//  NTESVideoChatViewController.h
//  NIM
//
//  Created by chris on 15/5/5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESNetChatViewController.h"

@class NTESNetCallChatInfo;
@class NTESVideoChatNetStatusView;

@interface NTESVideoChatViewController : NTESNetChatViewController

@property (weak, nonatomic) IBOutlet UIImageView *bigVideoView;


@property (weak, nonatomic) IBOutlet UIView *smallVideoView;

@property (nonatomic,strong) IBOutlet UIButton *hungUpBtn;   //挂断按钮

@property (nonatomic,strong) IBOutlet UIButton *acceptBtn; //接通按钮

@property (nonatomic,strong) IBOutlet UIButton *refuseBtn;   //拒接按钮

@property (nonatomic,strong) IBOutlet UILabel  *durationLabel;//通话时长

@property (nonatomic,strong) IBOutlet UIButton *switchCameraBtn; //切换前后摄像头

@property (nonatomic,strong) IBOutlet UILabel  *connectingLabel;  //等待对方接听

@property (nonatomic,strong) IBOutlet UIButton  *fullScreenBtn;

@end
