//
//  NTESVideoChatViewController.m
//  NIM
//
//  Created by chris on 15/5/5.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESVideoChatViewController.h"
#import "UIView+Toast.h"
#import "NTESTimerHolder.h"
#import "NTESNetCallChatInfo.h"
#import "UIView+NTES.h"
#import "NTESGLView.h"
#import "Pneuma-Swift.h"

@interface NTESVideoChatViewController ()

@property (nonatomic,assign) NIMNetCallCamera cameraType;

@property (nonatomic,strong) CALayer *localVideoLayer;

@property (nonatomic,weak) UIView   *localView;

@property (nonatomic,weak) UIView   *localPreView;

@property (nonatomic,weak) UIView   *remoteView;

@property (nonatomic, strong) NTESGLView *remoteGLView;

@property (nonatomic, assign) BOOL calleeBasy;

@property (nonatomic, copy) NSString *remoteUid;

@property (nonatomic, assign) BOOL oppositeCloseVideo;

@property (nonatomic, readonly) BOOL enableOpenGLView;

@end

@implementation NTESVideoChatViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cameraType = NIMNetCallCameraFront;
    }
    return self;
}

- (void)viewDidLoad {
    self.localView = self.smallVideoView;
    [super viewDidLoad];
    
    if (self.localPreView) {
        self.localPreView.frame = self.localView.bounds;
        [self.localView addSubview:self.localPreView];
    }
    
    [self initUI];
}

- (void)initUI
{
    self.refuseBtn.exclusiveTouch = YES;
    self.acceptBtn.exclusiveTouch = YES;
    self.hungUpBtn.layer.cornerRadius = 35;
    self.hungUpBtn.layer.masksToBounds = true;
    self.switchCameraBtn.layer.cornerRadius = 35;
    self.switchCameraBtn.layer.masksToBounds = true;
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        [self initRemoteGLView];
    }
}

- (void)initRemoteGLView {
    if (self.enableOpenGLView) {
        _remoteGLView = [[NTESGLView alloc] initWithFrame:_bigVideoView.bounds];
        [_remoteGLView setContentMode:UIViewContentModeScaleAspectFill];
        [_remoteGLView setBackgroundColor:[UIColor clearColor]];
        _remoteGLView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_bigVideoView addSubview:_remoteGLView];
    } else {
        if(!_remoteView) {
            _remoteView = [[NIMAVChatSDK sharedSDK].netCallManager remoteDisplayViewWithUid:_remoteUid];
        }
        if (self.remoteView) {
            self.remoteView.frame = self.bigVideoView.bounds;
            if (self.remoteView.superview != self.bigVideoView) {
                [self.remoteView removeFromSuperview];
                [self.bigVideoView addSubview:self.remoteView];
            }
        }
    }
}

#pragma mark - Call Life
- (void)startByCaller{
    [super startByCaller];
    [self startInterface];
}

- (void)startByCallee{
    [super startByCallee];
    dispatch_async(dispatch_get_main_queue(), ^{
       [self waitToCallInterface];
    });
}
- (void)onCalling{
    [super onCalling];
    [self videoCallingInterface];
}

- (void)waitForConnectiong{
    [super waitForConnectiong];
    [self connectingInterface];
}

- (void)onCalleeBusy
{
    _calleeBasy = YES;
    if (_localPreView)
    {
        [_localPreView removeFromSuperview];
    }
}

#pragma mark - Interface
//正在接听中界面
- (void)startInterface{
    self.acceptBtn.hidden = YES;
    self.refuseBtn.hidden   = YES;
    self.hungUpBtn.hidden   = NO;
    self.connectingLabel.hidden = NO;
    self.connectingLabel.text = NSLocalizedString(@"Calling_wait", nil);
    self.switchCameraBtn.hidden = NO;
    self.fullScreenBtn.hidden = YES;
    [self.hungUpBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.hungUpBtn addTarget:self action:@selector(hangup) forControlEvents:UIControlEventTouchUpInside];
    self.localView = self.bigVideoView;
}

//选择是否接听界面
- (void)waitToCallInterface{
    self.acceptBtn.hidden = NO;
    self.refuseBtn.hidden   = NO;
    self.hungUpBtn.hidden   = YES;
    self.connectingLabel.hidden = NO;
    self.connectingLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Caller_information", nil),self.callInfo.message];
    self.switchCameraBtn.hidden = YES;
}

//连接对方界面
- (void)connectingInterface{
    self.acceptBtn.hidden = YES;
    self.refuseBtn.hidden   = YES;
    self.hungUpBtn.hidden   = NO;
    self.connectingLabel.hidden = NO;
    self.connectingLabel.text = NSLocalizedString(@"Connecting_wait", nil);
    self.switchCameraBtn.hidden = YES;
    [self.hungUpBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.hungUpBtn addTarget:self action:@selector(hangup) forControlEvents:UIControlEventTouchUpInside];
}

//接听中界面(视频)
- (void)videoCallingInterface{
    NIMNetCallNetStatus status = [[NIMAVChatSDK sharedSDK].netCallManager netStatus:self.peerUid];
    self.acceptBtn.hidden = YES;
    self.refuseBtn.hidden   = YES;
    self.hungUpBtn.hidden   = NO;
    self.connectingLabel.hidden = YES;
    self.switchCameraBtn.hidden = NO;
    self.fullScreenBtn.hidden = NO;
    [self.hungUpBtn removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [self.hungUpBtn addTarget:self action:@selector(hangup) forControlEvents:UIControlEventTouchUpInside];
//    self.localVideoLayer.hidden = NO;
    self.localPreView.hidden = NO;
}

#pragma mark - IBAction

- (IBAction)acceptToCall:(id)sender{
    BOOL accept = (sender == self.acceptBtn);
    //防止用户在点了接收后又点拒绝的情况
    [self response:accept];
}


- (IBAction)switchCamera:(id)sender{
    if (self.cameraType == NIMNetCallCameraFront) {
        self.cameraType = NIMNetCallCameraBack;
    }else{
        self.cameraType = NIMNetCallCameraFront;
    }
    [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:self.cameraType];
    self.switchCameraBtn.selected = (self.cameraType == NIMNetCallCameraBack);
}

-(IBAction)fullScreenAction:(UIButton*)sender{
    [SVideoChatBoardObject quitVideoChatWithCloseType:1];
}

#pragma mark - NIMNetCallManagerDelegate
- (void)onLocalDisplayviewReady:(UIView *)displayView
{
    if (_calleeBasy) {
        return;
    }
    
    if (self.localPreView) {
        [self.localPreView removeFromSuperview];
    }
    
    self.localPreView = displayView;
    displayView.frame = self.localView.bounds;

    [self.localView addSubview:displayView];
}

- (void)onRemoteDisplayviewReady:(UIView *)displayView user:(NSString *)user {
    
    if (self.enableOpenGLView) {
        return;
    }
    
    if (_remoteView != displayView) {
        if (displayView.superview) {
            [displayView removeFromSuperview];
        }
        [_remoteView removeFromSuperview];
        _remoteView = displayView;
        _remoteView.frame = _bigVideoView.bounds;
        _remoteView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [_bigVideoView addSubview:displayView];
    }
}

- (void)onRemoteYUVReady:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                    from:(NSString *)user
{
    if (!self.enableOpenGLView) {
        return;
    }
    
    if (([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) && !self.oppositeCloseVideo) {
        
        if (!_remoteGLView) {
            [self initRemoteGLView];
        }
        [_remoteGLView render:yuvData width:width height:height];
    }
}

- (void)onControl:(UInt64)callID
             from:(NSString *)user
             type:(NIMNetCallControlType)control{
    [super onControl:callID from:user type:control];
    switch (control) {
        case NIMNetCallControlTypeToAudio:

            break;
        case NIMNetCallControlTypeCloseVideo:
            [self resetRemoteImage];
            self.oppositeCloseVideo = YES;
            _remoteView.hidden = YES;
            [self.view makeToast:@"对方关闭了摄像头"
                        duration:2
                        position:CSToastPositionCenter];
            break;
        case NIMNetCallControlTypeOpenVideo:
            self.oppositeCloseVideo = NO;
            _remoteView.hidden = NO;
            [self.view makeToast:@"对方开启了摄像头"
                        duration:2
                        position:CSToastPositionCenter];
            break;
        default:
            break;
    }
}


-(void)onCallEstablished:(UInt64)callID
{
    if (self.callInfo.callID == callID) {
        [super onCallEstablished:callID];
        
        self.durationLabel.hidden = NO;
        self.durationLabel.text = self.durationDesc;
        
        if (self.localView == self.bigVideoView) {
            self.localView = self.smallVideoView;
            
            if (self.localPreView) {
                [self onLocalDisplayviewReady:self.localPreView];
            }
        }
    }
}


#pragma mark - M80TimerHolderDelegate

- (void)onNTESTimerFired:(NTESTimerHolder *)holder{
    [super onNTESTimerFired:holder];
    self.durationLabel.text = self.durationDesc;
}

#pragma mark - Misc

- (NSString*)durationDesc{
    if (!self.callInfo.startTime) {
        return @"";
    }
    NSTimeInterval time = [NSDate date].timeIntervalSince1970;
    NSTimeInterval duration = time - self.callInfo.startTime;
    return [NSString stringWithFormat:@"%02d:%02d",(int)duration/60,(int)duration%60];
}

- (void)resetRemoteImage{
    [self.remoteGLView render:nil width:0 height:0];
    self.bigVideoView.image = [UIImage imageNamed:@"netcall_bkg.png"];
}

- (BOOL)enableOpenGLView {
    return NO;
}

@end
