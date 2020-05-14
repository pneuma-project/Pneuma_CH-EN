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
        if SMainBoardObject.shared().role == 1 && UIViewController.getCurrentViewCtrl().isKind(of: MembersController.classForCoder()) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: JumpPatientChartPage), object: ["SSID": caller], userInfo: nil)
        }
        if UIViewController.getCurrentViewCtrl().isKind(of: NTESNetChatViewController.classForCoder()) {
            NIMAVChatSDK.shared().netCallManager.control(callID, type: .busyLine)
        }else {
            guard let tabbarCtrl = UIApplication.shared.keyWindow?.rootViewController as? SMainTabBarController else {
                return
            }
            var vc = NTESVideoChatViewController()
            switch type {
            case .video:
                vc = NTESVideoChatViewController.init(caller: caller, callId: callID, extendMessage: extendMessage)
                break
            default:
                break
            }
            tabbarCtrl.resetSubViewController(vc: vc)
            SVideoChatBoardObject.enterVideoChat()
            
            guard let name = extendMessage else {
                return
            }
            let notification = UILocalNotification.init()
            notification.alertBody = name+NSLocalizedString("Start_call", comment: "")
            notification.fireDate = Date.init(timeIntervalSinceNow: 0.1)
            notification.soundName = "in.caf"
            notification.userInfo = ["aps":["alert":name+NSLocalizedString("Start_call", comment: ""),"sound":"default"],"sessionId":callID, "nickName":name as Any,"nim":"1"]
            UIApplication.shared.scheduleLocalNotification(notification)
        }
        
    }
}

extension SVideoChatTool: NIMLoginManagerDelegate {
    func onKick(_ code: NIMKickReason, clientType: NIMLoginClientType) {
        var reason = ""
        switch code {
        case .byClient:
            reason = NSLocalizedString("Accout_logout", comment: "")
            break
        case .byServer:
            break
        default:
            break
        }
        NIMSDK.shared().loginManager.logout { (error) in
            let alertVC = UIAlertController.alertAlert(title: NSLocalizedString("Reminder", comment: ""), message: reason, okTitle: NSLocalizedString("OK", comment: "")) {
                SVideoChatBoardObject.destroy()
                SMainBoardObject.destroy()
                let loginVC = LoginViewController()
                UIApplication.shared.keyWindow?.rootViewController = loginVC
            }
            UIViewController.getCurrentViewCtrl().present(alertVC, animated: true, completion: nil)
        }
    }
}
