//
//  DeviceRequestObject.swift
//  Sprayer
//
//  Created by FangLin on 2019/5/17.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit
import SwiftyJSON

class DeviceRequestObject: NSObject {
    
    @objc class var shared: DeviceRequestObject {
        struct instance {
            static let _instance:DeviceRequestObject = DeviceRequestObject()
        }
        return instance._instance
    }
    
    //绑定蓝牙mac地址
    @objc func requestEditMacAddress(macAddress:String,sucBlock:((_ status:Int)->())?) {
        if let loginKey = UserInfoData.mr_findFirst()?.loginKey {
            SURLRequest.sharedInstance.requestPostWithHeader(Url_EditMacAddress, param: ["loginKey":loginKey,"macAddress":macAddress], checkSum: [loginKey,macAddress], suc: { (data) in
                Dprint("EditMacAddress_Url:\(data)")
                let dataStatus = JSON(data).intValue
                if let block = sucBlock {
                    block(dataStatus)
                }
            }) { (error) in
                Dprint("EditMacAddress_UrlError:\(error)")
            }
        }
    }
    
    //蓝牙设备绑定状态
    @objc func requestGetMacAddressBindState(macAddress:String,sucBlock:((_ status:Int)->())?) {
        SURLRequest.sharedInstance.requestPostWithHeader(URL_GetMacAddressBindState, param: ["macAddress":macAddress], checkSum: [macAddress], suc: { (data) in
            Dprint("URL_GetMacAddressBindState:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            if code == "200" {
                let result = dataJson["result"].intValue
                if let block = sucBlock {
                    block(result)
                }
            }
        }) { (error) in
            Dprint("URL_GetMacAddressBindStateError:\(error)")
        }
    }
}
