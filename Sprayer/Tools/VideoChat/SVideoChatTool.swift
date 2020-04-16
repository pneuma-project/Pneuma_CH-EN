//
//  SVideoChatTool.swift
//  Sprayer
//
//  Created by fanglin on 2020/4/15.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit
import NIMAVChat

class SVideoChatTool: NSObject {
    
    @objc static let shared:SVideoChatTool = {
        let tool = SVideoChatTool()
        return tool
    }()
    
    @objc func registerNIMManager() {
        let appKey = "883ba07828988bf912ff75717de3b7a2"
        NIMSDK.shared().register(withAppID: appKey, cerName: nil)
        NIMSDK.shared().loginManager.add(SVideoChatTool.shared as NIMLoginManagerDelegate)
        NIMAVChatSDK.shared().netCallManager.add(SVideoChatTool.shared as NIMNetCallManagerDelegate)
    }
    
    func startVideoChat(ssId:Int32,otherName:String) {
        let option = NIMNetCallOption.init()
        option.extendMessage = otherName
        option.apnsContent = "通话请求"
        option.apnsSound = "video_chat_tip_receiver.aac"
        let param = NIMNetCallVideoCaptureParam.init()
        param.preferredVideoQuality = .quality480pLevel
        param.videoCrop = .crop16x9
        param.startWithBackCamera = true
        option.videoCaptureParam = param
        
        NIMAVChatSDK.shared().netCallManager.start(["pn"+"\(ssId)"], type: .video, option: option) { (error, callId) in
            if error == nil { //通话发起成功
                
            }else { //通话发起失败
                
            }
        }
    }
}

extension SVideoChatTool: NIMNetCallManagerDelegate {
    func onReceive(_ callID: UInt64, from caller: String, type: NIMNetCallMediaType, message extendMessage: String?) {
        if UIViewController.getCurrentViewCtrl().isKind(of: NTESNetChatViewController.classForCoder()) {
            NIMAVChatSDK.shared().netCallManager.control(callID, type: .busyLine)
        }else {
            var vc = UIViewController()
            switch type {
            case .video:
                vc = NTESVideoChatViewController.init(caller: caller, callId: callID, extendMessage: extendMessage)
                break
            default:
                break
            }
            //由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
            let transition = CATransition.init()
            transition.duration = 0.25
            transition.timingFunction = CAMediaTimingFunction.init(name: "default")
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromTop
            UIViewController.getCurrentViewCtrl().navigationController?.view.layer.add(transition, forKey: nil)
            UIViewController.getCurrentViewCtrl().navigationController?.isNavigationBarHidden = true
//            UIViewController.getCurrentViewCtrl().navigationController?.pushViewController(vc, animated: false)
            vc.view.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            UIViewController.getCurrentViewCtrl().view.addSubview(vc.view)
            UIViewController.getCurrentViewCtrl().addChildViewController(vc)
            
        }
        
    }
}

extension SVideoChatTool: NIMLoginManagerDelegate {
    func onKick(_ code: NIMKickReason, clientType: NIMLoginClientType) {
        var reason = ""
        switch code {
        case .byClient:
            reason = "你的账号在另一端登录，请注意帐号信息安全"
            break
        case .byServer:
            break
        default:
            break
        }
        NIMSDK.shared().loginManager.logout { (error) in
            let alertVC = UIAlertController.alertAlert(title: "温馨提示", message: reason, okTitle: "确定") {
                let loginVC = LoginViewController()
                UIApplication.shared.keyWindow?.rootViewController = loginVC
            }
            UIViewController.getCurrentViewCtrl().present(alertVC, animated: true, completion: nil)
        }
    }
}
