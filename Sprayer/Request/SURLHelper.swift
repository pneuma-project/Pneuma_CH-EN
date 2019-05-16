//
//  SURLHelper.swift
//  Sheng
//
//  Created by DS on 2017/7/28.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

/*
 UKL帮助类
 */


import UIKit
import CryptoSwift

class SURLHelper: NSObject {
    /// 获取 CheckCode dictionary 作为 request header
    /// - Parameter checkArr: request parameters 组成的字符串数组
    /// - Returns: CheckCode dictionary
    class func getCheckCode(checkArr:[String]) -> [String:String] {
        let codeStr = checkArr.joined(separator: "&")
        let str = codeStr.md5()
        guard let data = str.data(using: String.Encoding.utf8) else {return ["checkSum":""]}
        let codeStr1: String = data.base64EncodedString()
        let dict = ["checkSum":codeStr1]
        return dict
    }
    
    /// 获取 CheckCode string 作为 request response 指定字段的对比对象
    ///
    /// - Parameter checkArr: request parameters 组成的字符串数组
    /// - Returns: CheckCode string
    class func getResponseMd5String(checkArr:[String]) -> String {
        let codeStr = checkArr.joined(separator: "&")
        let str = codeStr.md5()
        guard let data = str.data(using: String.Encoding.utf8) else {return ""}
        let codeStr1: String = data.base64EncodedString()
        return codeStr1
    }
    
}
