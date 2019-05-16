//
//  KeychainUtils.swift
//  Sheng
//
//  Created by FL on 2017/7/25.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

/*
    获取唯一的UDID
 */

import Foundation

func getUUID()->String{
    
    
    let UUIDDate = SSKeychain.passwordData(forService: "com.dzkj.hanxs.xinsen1", account: "com.dzkj.hanxs.xinsen1")
    
    
    var UUID : NSString!
    if UUIDDate != nil{
        
        UUID = NSString(data: UUIDDate!, encoding: String.Encoding.utf8.rawValue)
    }
    
    
    if(UUID == nil){
        
        UUID = UIDevice.current.identifierForVendor?.uuidString as NSString!
        
        
        SSKeychain.setPassword(UUID as String, forService: "com.dzkj.hanxs.xinsen1", account: "com.dzkj.hanxs.xinsen1")
    }
    UUID = UUID.replacingOccurrences(of: "-", with: "") as NSString!
    return UUID as String
}
