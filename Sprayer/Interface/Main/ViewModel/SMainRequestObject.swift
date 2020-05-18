//
//  SMainRequestObject.swift
//  Sprayer
//
//  Created by fanglin on 2020/5/18.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit
import SwiftyJSON

class SMainRequestObject: NSObject {
    @objc class var shared: SMainRequestObject {
        struct instance {
            static let _instance:SMainRequestObject = SMainRequestObject()
        }
        return instance._instance
    }
    
    @objc func requestLogoutObj(sucBlock:((_ code:String)->())?) {
        if let loginkey = UserInfoData.mr_findFirst()?.loginKey {
            SURLRequest.sharedInstance.requestPostWithHeader(Logout_Url, param: ["loginKey":loginkey], checkSum: [loginkey], suc: { (data) in
                Dprint("Logout_Url:\(data)")
                let dataJson = JSON(data)
                let code = dataJson["code"].stringValue
                if let block = sucBlock {
                    block(code)
                }
            }) { (error) in
                Dprint("Logout_UrlError:\(error)")
            }
        }
        
    }
}
