//
//  UIAlertControllerEx.swift
//  Sprayer
//
//  Created by fanglin on 2020/3/12.
//  Copyright © 2020 FangLin. All rights reserved.
//

import Foundation

extension UIAlertController {
    ///可空的无参无返回值 Block
    typealias AlertCompleteOptional = (() -> Swift.Void)?
    typealias AlertCancelOptional = (() -> Swift.Void)?
    
    /// 返回alertController 有取消和确定按钮
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 内容
    ///   - okTitle: 确定按钮的文字
    ///   - okComplete: 回调事件
    /// - Returns: alertController 实例
    class func alertAlert(title: String?, message: String?, okTitle: String, cancelTitle: String? = nil, okComplete: AlertCompleteOptional) -> UIAlertController{
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: okTitle, style: .default, handler: { (_) in
            if okComplete != nil{
                okComplete!()
            }
        })
        
        let cancel = UIAlertAction(title: cancelTitle ?? "取消", style: .cancel) { (alert: UIAlertAction) -> Void in
        }
        
        alertVC.addAction(alertAction)
        alertVC.addAction(cancel)
        return alertVC
    }
    
    /// 返回alertController 有取消和确定按钮
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 内容
    ///   - okTitle: 确定按钮的文字
    ///   - okComplete: 回调事件
    ///   - cancelComplete: 回调事件
    /// - Returns: alertController 实例
    class func alertAlert(title: String?, message: String?, okTitle: String, okComplete: AlertCompleteOptional, cancelTitle: String? = nil, cancelComplete: AlertCancelOptional) -> UIAlertController{
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: okTitle, style: .default, handler: { (_) in
            if okComplete != nil{
                okComplete!()
            }
        })
        
        let cancel = UIAlertAction(title: cancelTitle ?? "取消", style: .cancel) { (alert: UIAlertAction) -> Void in
            if cancelComplete != nil {
                cancelComplete!()
            }
        }
        alertVC.addAction(alertAction)
        alertVC.addAction(cancel)
        return alertVC
    }
    
    /// 返回alertController 仅确定按钮
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 内容
    ///   - okTitle: 确定按钮的文字
    ///   - okComplete: 回调事件
    /// - Returns: alertController 实例
    class func alertAlert(title: String?, message: String?, okTitle: String, okComplete: AlertCompleteOptional) -> UIAlertController{
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: okTitle, style: .default, handler: { (_) in
            if okComplete != nil{
                okComplete!()
            }
        })
        alertVC.addAction(alertAction)
        return alertVC
    }
}
