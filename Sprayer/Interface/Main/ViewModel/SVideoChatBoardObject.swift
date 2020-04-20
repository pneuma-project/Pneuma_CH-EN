//
//  SVideoChatBoardObject.swift
//  Sprayer
//
//  Created by fanglin on 2020/4/20.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit

class SVideoChatBoardObject: NSObject {
    private static var _sharedInstance: SVideoChatBoardObject?
    private override init() {
         
    }
    class func shared() -> SVideoChatBoardObject {
        guard let instance = _sharedInstance else {
            _sharedInstance = SVideoChatBoardObject()
            return _sharedInstance!
        }
        return instance
    }
    class func destroy() {
        _sharedInstance = nil
    }
    
    ///视图对象
    lazy var hangView:CRHangView = {
        let bottomSpace:CGFloat = (ISIPHONE6p ? 42.7:(ISIPHONE6 ? 70:49))
        let view = CRHangView.init(frame: CGRect.init(x: CGFloat(10*IPONE_SCALE), y: SCREEN_HEIGHT-bottomSpace-44, width: CGFloat(155*IPONE_SCALE), height: CGFloat(62*IPONE_SCALE)))
        UIApplication.shared.keyWindow?.addSubview(view)
        return view
    }()
    
    
    class func enterVideoChat() {
        guard let tabbarCtrl = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else {
            return
        }
        SVideoChatBoardObject.shared().hangView.isHidden = true
        tabbarCtrl.selectedIndex = 1
        SMainBoardObject.shared().isVideoChatExist = true
    }
    
    
    /// 关闭视频通话
    /// -closetype:  0_完全关闭     1_最小化    2——跳转到后续界面
    @objc class func quitVideoChat(closeType:Int) {
        SVideoChatBoardObject.shared().hangView.isHidden = (closeType == 0)
        guard let tabbarCtrl = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController else {
            return
        }
        if closeType == 2 {
            tabbarCtrl.selectedIndex = 1
        }else {
            tabbarCtrl.selectedIndex = 0
        }
        if closeType == 0 {
            SMainBoardObject.shared().isVideoChatExist = false
        }
    }
}
