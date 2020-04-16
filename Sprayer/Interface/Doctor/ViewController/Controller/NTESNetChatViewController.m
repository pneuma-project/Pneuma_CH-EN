//
//  NTESNetChatViewController.m
//  NIM
//
//  Created by chris on 15/5/18.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESNetChatViewController.h"
#import "UIAlertView+NTESBlock.h"
#import "UIView+Toast.h"
#import "NTESTimerHolder.h"
#import "NTESNetCallChatInfo.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIView+NTES.h"
#import "Pneuma-Swift.h"

//十秒之后如果还是没有收到对方响应的control字段，则自己发起一个假的control，用来激活铃声并自己先进入房间
#define DelaySelfStartControlTime 10
//激活铃声后无人接听的超时时间
#define NoBodyResponseTimeOut 45

//周期性检查剩余磁盘空间
#define DiskCheckTimeInterval 10
//剩余磁盘空间不足的警告阈值
#define MB (1024ll * 1024ll)
#define FreeDiskSpaceWarningThreshold (10 * MB)

@interface NTESNetChatViewController ()

@property (nonatomic, strong) NTESTimerHolder *timer;

@property (nonatomic, strong) NSMutableArray *chatRoom;

@property (nonatomic, assign) BOOL recordWillStopForLackSpace;

@property (nonatomic, strong) NTESTimerHolder *diskCheckTimer;

@property (nonatomic, assign) BOOL userHangup;

@property (nonatomic, strong) NTESTimerHolder *calleeResponseTimer; //被叫等待用户响应接听或者拒绝的时间
@property (nonatomic, assign) BOOL calleeResponsed;

@property (nonatomic, assign) int successRecords;

//@property (nonatomic, strong) NTESRecordSelectView * recordView;
@end

@implementation NTESNetChatViewController

//NTES_FORBID_INTERACTIVE_POP

- (instancetype)initWithCallee:(NSString *)callee{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.peerUid = callee;
        self.callInfo.callee = callee;
        self.callInfo.caller = [[NIMSDK sharedSDK].loginManager currentAccount];
    }
    return self;
}

- (instancetype)initWithCaller:(NSString *)caller callId:(uint64_t)callID extendMessage:(NSString*)extend{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.peerUid = caller;
        self.callInfo.caller = caller;
        self.callInfo.callee = [[NIMSDK sharedSDK].loginManager currentAccount];
        self.callInfo.callID = callID;
        self.callInfo.message = extend;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        if (!self.callInfo) {
            [[NIMSDK sharedSDK].mediaManager switchAudioOutputDevice:NIMAudioOutputDeviceSpeaker];
            _callInfo = [[NTESNetCallChatInfo alloc] init];
        }
        _timer = [[NTESTimerHolder alloc] init];
        _diskCheckTimer = [[NTESTimerHolder alloc] init];
        //防止应用在后台状态，此时呼入，会走init但是不会走viewDidLoad,此时呼叫方挂断，导致被叫监听不到，界面无法消去的问题。
        id<NIMNetCallManager> manager = [NIMAVChatSDK sharedSDK].netCallManager;
        [manager addDelegate:self];
    }
    return self;
}

- (void)dealloc{
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) wself = self;
    [self checkServiceEnable:^(BOOL result) {
        if (result) {
            [wself afterCheckService];
        }else{
            //用户禁用服务，干掉界面
            if (wself.callInfo.callID) {
                //说明是被叫方
                [[NIMAVChatSDK sharedSDK].netCallManager response:wself.callInfo.callID accept:NO option:nil completion:nil];
            }
            [wself dismiss:nil];
        }
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpStatusBar:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player stop];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)afterCheckService{
    if (self.callInfo.isStart) {
        [self.timer startTimer:0.5 delegate:self repeats:YES];
        [self onCalling];
    }
    else if (self.callInfo.callID) {
        [self startByCallee];
    }
    else {
        [self startByCaller];
    }
    
    [self checkFreeDiskSpace];
    [self.diskCheckTimer startTimer:DiskCheckTimeInterval
                           delegate:self
                            repeats:YES];
}

#pragma mark - Subclass Impl
- (void)startByCaller{
    
    //视频呼叫马上发起
    [self doStartByCaller];
    
}

- (void)doStartByCaller
{
    [self playSenderRing];
    self.callInfo.isStart = YES;
    NSArray *callees = [NSArray arrayWithObjects:self.callInfo.callee, nil];
    
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    option.extendMessage = UserInfoData.MR_findFirst.name;
    option.apnsContent = @"视频聊天请求";
    option.apnsSound = @"video_chat_tip_receiver.aac";
    [self fillUserSetting:option];
    
    option.videoCaptureParam.startWithCameraOn = YES;

    __weak typeof(self) wself = self;

    [[NIMAVChatSDK sharedSDK].netCallManager start:callees type:NIMNetCallMediaTypeVideo option:option completion:^(NSError *error, UInt64 callID) {
        if (!error && wself) {
            wself.callInfo.callID = callID;
            wself.chatRoom = [[NSMutableArray alloc]init];
            //十秒之后如果还是没有收到对方响应的control字段，则自己发起一个假的control，用来激活铃声并自己先进入房间
            NSTimeInterval delayTime = DelaySelfStartControlTime;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself onControl:callID from:wself.callInfo.callee type:NIMNetCallControlTypeFeedabck];
            });
        }else{
            if (error) {
                [wself.navigationController.view makeToast:@"连接失败"
                                                  duration:2
                                                  position:CSToastPositionCenter];
            }else{
                //说明在start的过程中把页面关了。。
                [[NIMAVChatSDK sharedSDK].netCallManager hangup:callID];
            }
            [wself dismiss:nil];
        }
    }];
}

- (void)startByCallee{
    //告诉对方可以播放铃声了
    self.callInfo.isStart = YES;
    NSMutableArray *room = [[NSMutableArray alloc] init];
    [room addObject:self.callInfo.caller];
    self.chatRoom = room;
    [[NIMAVChatSDK sharedSDK].netCallManager control:self.callInfo.callID type:NIMNetCallControlTypeFeedabck];
    [self playReceiverRing];
    _calleeResponseTimer = [[NTESTimerHolder alloc] init];
    [_calleeResponseTimer startTimer:NoBodyResponseTimeOut + 10 delegate:self repeats:NO];
}


- (void)hangup{
    _userHangup = YES;
    [[NIMAVChatSDK sharedSDK].netCallManager hangup:self.callInfo.callID];
    
    if (self.callInfo.localRecording) {
        __weak typeof(self) wself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            wself.chatRoom = nil;
            [wself dismiss:nil];
        });
    }
    else {
        self.chatRoom = nil;
        [self dismiss:nil];
    }
}

- (void)response:(BOOL)accept{
    
    _calleeResponsed = YES;
    
    NIMNetCallOption *option = [[NIMNetCallOption alloc] init];
    [self fillUserSetting:option];
    
    __weak typeof(self) wself = self;

    [[NIMAVChatSDK sharedSDK].netCallManager response:self.callInfo.callID accept:accept option:option completion:^(NSError *error, UInt64 callID) {
        if (!error) {
                [wself onCalling];
                [wself.player stop];
                [wself.chatRoom addObject:wself.callInfo.callee];
                NSTimeInterval delay = 10.f; //10秒后判断下房间
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (wself.chatRoom.count == 1) {
                        [wself.navigationController.view makeToast:@"通话失败"
                                                          duration:2
                                                          position:CSToastPositionCenter];
                        [wself hangup];
                    }
                });
        }else{
            wself.chatRoom = nil;
            [wself.navigationController.view makeToast:@"连接失败"
                                              duration:2
                                              position:CSToastPositionCenter];
            [wself dismiss:nil];
        }
    }];
    //dismiss需要放在self后面，否在ios7下会有野指针
    if (accept) {
        [self waitForConnectiong];
    }else{
        [self dismiss:nil];
    }
}

- (void)dismiss:(void (^)(void))completion{
    //由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionPush;
    transition.subtype  = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    self.navigationController.navigationBarHidden = NO;
//    [self.navigationController popViewControllerAnimated:NO];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self setUpStatusBar:UIStatusBarStyleDefault];
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(transition.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

- (void)onCalling{
    //子类重写
}

- (void)waitForConnectiong{
    //子类重写
}

- (void)onCalleeBusy
{
    //子类重写
}

- (void)udpateLowSpaceWarning:(BOOL)show
{
    //子类重写
}

#pragma mark - NIMNetCallManagerDelegate
- (void)onControl:(UInt64)callID
             from:(NSString *)user
             type:(NIMNetCallControlType)control{
    
    if (user == [[NIMSDK sharedSDK].loginManager currentAccount]) {
        //多端登录时，自己会收到自己发出的控制指令，这里忽略他
        return;
    }
    
    if (callID != self.callInfo.callID) {
        return;
    }
    
    switch (control) {
        case NIMNetCallControlTypeFeedabck:{
            NSMutableArray *room = self.chatRoom;
            if (room && !room.count && !_userHangup) {
//                [self playSenderRing];
                [room addObject:self.callInfo.caller];
                //40秒之后查看一下房间状态，如果房间还在一个人的话，就播放铃声超时
                __weak typeof(self) wself = self;
                uint64_t callId = self.callInfo.callID;
                NSTimeInterval delayTime = NoBodyResponseTimeOut;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSMutableArray *room = wself.chatRoom;
                    if (wself && room && room.count == 1) {
                        [[NIMAVChatSDK sharedSDK].netCallManager hangup:callId];
                        wself.chatRoom = nil;
                        [wself playTimeoutRing];
                        [wself.navigationController.view makeToast:@"无人接听"
                                                          duration:2
                                                          position:CSToastPositionCenter];
                        [wself dismiss:nil];
                    }
                });
            }
            break;
        }
        case NIMNetCallControlTypeBusyLine: {
            [self onCalleeBusy];
            [self playOnCallRing];
            _userHangup = YES;
            [[NIMAVChatSDK sharedSDK].netCallManager hangup:callID];
            __weak typeof(self) wself = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself dismiss:nil];
            });
            break;
        }
        default:
            break;
    }
}

- (void)onResponse:(UInt64)callID from:(NSString *)callee accepted:(BOOL)accepted{
    if (self.callInfo.callID == callID) {
        if (!accepted) {
            self.chatRoom = nil;
            [self.navigationController.view makeToast:@"对方拒绝接听"
                                             duration:2
                                             position:CSToastPositionCenter];
            [self playHangUpRing];
            __weak typeof(self) wself = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself dismiss:nil];
            });

        }else{
            [self.player stop];
            [self onCalling];
            [self.chatRoom addObject:callee];
        }
    }
}

-(void)onCallEstablished:(UInt64)callID
{
    if (self.callInfo.callID == callID) {
        self.callInfo.startTime = [NSDate date].timeIntervalSince1970;
        [self.timer startTimer:0.5 delegate:self repeats:YES];
    }
}

- (void)onCallDisconnected:(UInt64)callID withError:(NSError *)error
{
    if (self.callInfo.callID == callID) {
        [self.timer stopTimer];
        [self dismiss:nil];
        self.chatRoom = nil;
    }
}


- (void)onResponsedByOther:(UInt64)callID
                  accepted:(BOOL)accepted{
    [self.view.window makeToast:@"已在其他端处理"
                       duration:2
                       position:CSToastPositionCenter];
    [self dismiss:nil];
}

- (void)onHangup:(UInt64)callID
              by:(NSString *)user{
    if (self.callInfo.callID == callID) {
        [self.player stop];
        if (self.callInfo.localRecording) {
            __weak typeof(self) wself = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself dismiss:nil];
            });
        }
        else {
            [self dismiss:nil];
        }
    }
}


#pragma mark - NTESRecordSelectViewDelegate

-(void)onRecordWithAudioConversation:(BOOL)audioConversationOn myMedia:(BOOL)myMediaOn otherSideMedia:(BOOL)otherSideMediaOn
{
    //子类重写
}

#pragma mark - M80TimerHolderDelegate
- (void)onNTESTimerFired:(NTESTimerHolder *)holder{
    if (holder == self.diskCheckTimer) {
        [self checkFreeDiskSpace];
    }
    else if(holder == self.calleeResponseTimer) {
        if (!_calleeResponsed) {
            [self.navigationController.view makeToast:@"接听超时"
                                              duration:2
                                              position:CSToastPositionCenter];
            [self response:NO];
        }
    }
}


#pragma mark - Misc
- (void)checkServiceEnable:(void(^)(BOOL))result{
    AVAuthorizationStatus audioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (videoStatus == AVAuthorizationStatusRestricted
        || videoStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"相机权限受限,无法视频聊天"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert showAlertWithCompletionHandler:^(NSInteger idx) {
            if (result) {
                result(NO);
            }
        }];
        return;
    }
    
    if (audioStatus == AVAuthorizationStatusRestricted
        || audioStatus == AVAuthorizationStatusDenied ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"麦克风权限受限,无法聊天"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert showAlertWithCompletionHandler:^(NSInteger idx) {
            if (result) {
                result(NO);
            }
        }];
        return;
    }
    
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                NSString *mediaType = AVMediaTypeVideo;
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
                if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"相机权限受限,无法视频聊天"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert showAlertWithCompletionHandler:^(NSInteger idx) {
                        if (result) {
                            result(NO);
                        }
                    }];
                }else{
                    if (result) {
                        result(YES);
                    }
                }
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"麦克风权限受限,无法聊天"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert showAlertWithCompletionHandler:^(NSInteger idx) {
                    if (result) {
                        result(NO);
                    }
                }];
            }
        }];
    } else {
        if (result) {
            result(NO);
        }
    }
}

- (void)setUpStatusBar:(UIStatusBarStyle)style{
    [[UIApplication sharedApplication] setStatusBarStyle:style
                                                animated:NO];
}

- (void)checkFreeDiskSpace{
    
    if (self.callInfo.localRecording) {
        uint64_t freeSpace = 1000 * MB;
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSDictionary *attrbites = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
        
        if (attrbites) {
            NSNumber *freeFileSystemSizeInBytes = [attrbites objectForKey:NSFileSystemFreeSize];
            freeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        
            [self udpateLowSpaceWarning:(freeSpace < FreeDiskSpaceWarningThreshold)];
        }
    }
}

- (void)fillUserSetting:(NIMNetCallOption *)option
{
    //指定 option 中的 videoCaptureParam 参数
    NIMNetCallVideoCaptureParam *param = [[NIMNetCallVideoCaptureParam alloc] init];
    //清晰度480P
    param.preferredVideoQuality = NIMNetCallVideoQuality480pLevel;
    //裁剪类型 16:9
    param.videoCrop  = NIMNetCallVideoCrop16x9;
    //打开初始为前置摄像头
    param.startWithBackCamera = NO;
    option.videoCaptureParam = param;

}


#pragma mark - Ring
//铃声 - 正在呼叫请稍后
- (void)playConnnetRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_connect_chat_tip_sender" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
}

//铃声 - 对方暂时无法接听
- (void)playHangUpRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_HangUp" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
}

//铃声 - 对方正在通话中
- (void)playOnCallRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_OnCall" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
}

//铃声 - 对方无人接听
- (void)playTimeoutRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_onTimer" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [self.player play];
}

//铃声 - 接收方铃声
- (void)playReceiverRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_receiver" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = 20;
    [self.player play];
}

//铃声 - 拨打方铃声
- (void)playSenderRing{
    [self.player stop];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"video_chat_tip_sender" withExtension:@"aac"];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.player.numberOfLoops = 20;
    [self.player play];
}



@end
