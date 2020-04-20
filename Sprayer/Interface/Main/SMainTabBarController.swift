//
//  SMainTabBarController.swift
//  Sprayer
//
//  Created by fanglin on 2020/4/17.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit

class SMainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.isHidden = true
        self.setSubViewController()
        
    }
    
    func setSubViewController() {
        let videoVC = NTESVideoChatViewController.init()
        if SMainBoardObject.shared().role == 0 { //病人端
            let rootVC = RootViewController()
            let tabArray = [rootVC,videoVC]
            self.viewControllers = tabArray
        }else { //医生端
            let memberVC = MembersController()
            let navVC = BaseNavViewController.init(rootViewController: memberVC)
            navVC.navigationBar.barTintColor = RGBCOLOR(r: 0, g: 83, b: 181, alpha: 1)
            let tabArray = [navVC,videoVC]
            self.viewControllers = tabArray
        }
    }
    
    func resetSubViewController(vc:NTESVideoChatViewController) {
        if SMainBoardObject.shared().role == 0 { //病人端
            let tabArray = [self.viewControllers![0],vc]
            self.viewControllers = tabArray
        }else { //医生端
            let tabArray = [self.viewControllers![0],vc]
            self.viewControllers = tabArray
        }
    }
}
