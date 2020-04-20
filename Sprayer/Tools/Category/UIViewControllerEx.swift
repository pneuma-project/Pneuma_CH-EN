//
//  UIViewControllerEx.swift
//  Sheng
//
//  Created by fanglin on 2019/04/02.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

/*
 UIViewController类扩展
 */

import Foundation
import UIKit

extension UIViewController{
    
    /// 使嵌入的横向滚动视图不影响控制器的拖返功能
    ///
    /// - Parameter scrollV: 嵌入的横向滚动视图,它也可能是UICollectionView或UITableView
    func notDistrubSlipBack(with scrollV:UIScrollView) {
        if let gestureArr = self.navigationController?.view.gestureRecognizers{
            for gesture in gestureArr {
                if (gesture as AnyObject).isKind(of:UIScreenEdgePanGestureRecognizer.self){
                    scrollV.panGestureRecognizer.require(toFail: gesture)
                }
            }
        }
    }
    
    /// 获取当前视图控制器
    ///
    /// - Returns: 当前视图控制器
    @objc class func getCurrentViewCtrl()->UIViewController{
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindowLevelNormal {
            let windows = UIApplication.shared.windows
            for subWin in windows {
                if subWin.windowLevel == UIWindowLevelNormal {
                    window = subWin
                    break
                }
            }
        }
        if window?.rootViewController is UINavigationController {
            return (window?.rootViewController as! UINavigationController).visibleViewController!
        }else if window?.rootViewController is RootViewController {
            let tabbarCtrl = window?.rootViewController as! RootViewController
            let tabbarSuperClassCtrl = tabbarCtrl.childViewControllers.first as! UITabBarController
            var tabbarSelCtrl = tabbarSuperClassCtrl.selectedViewController
            if tabbarSelCtrl == nil{
                tabbarSelCtrl = tabbarSuperClassCtrl.viewControllers?.first
            }
            if tabbarSelCtrl is UINavigationController {
                if let navRootCtrl = (tabbarSelCtrl as! UINavigationController).visibleViewController{
                    return navRootCtrl
                }
                return tabbarSelCtrl!
            }else{
                return tabbarSelCtrl!
            }
        }else if window?.rootViewController is SMainTabBarController{
            let tabbarCtrl = window?.rootViewController as! SMainTabBarController
            var tabbarSelCtrl = tabbarCtrl.selectedViewController
            if tabbarSelCtrl == nil {
                tabbarSelCtrl = tabbarCtrl.viewControllers?.first
            }
            if tabbarSelCtrl?.classForCoder == RootViewController.classForCoder() {
                let tabbarCtrl = tabbarSelCtrl as! RootViewController
                let tabbarSuperClassCtrl = tabbarCtrl.childViewControllers.first as! UITabBarController
                var tabbarSelCtrl = tabbarSuperClassCtrl.selectedViewController
                if tabbarSelCtrl == nil{
                    tabbarSelCtrl = tabbarSuperClassCtrl.viewControllers?.first
                }
                if tabbarSelCtrl is UINavigationController {
                    if let navRootCtrl = (tabbarSelCtrl as! UINavigationController).visibleViewController{
                        return navRootCtrl
                    }
                    return tabbarSelCtrl!
                }else{
                    return tabbarSelCtrl!
                }
            }else if tabbarSelCtrl is UINavigationController {
                if let navRootCtrl = (tabbarSelCtrl as! UINavigationController).visibleViewController{
                    return navRootCtrl
                }
                return tabbarSelCtrl!
            }else {
                return tabbarSelCtrl!
            }
        }else {
            return (window?.rootViewController)!
        }
    }
}
