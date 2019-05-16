//
//  Tools.swift
//  Sheng
//
//  Created by chengrong on 2017/8/2.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

import UIKit

class Tools: NSObject {

    //MARK: - MD5加密转化成16位  后台是16位
    class func getMD5Str(content: String) -> String {
        let pas: String = content.md5()
        let start = pas.index(pas.startIndex, offsetBy: 8)
        let end = pas.index(pas.startIndex, offsetBy: 24)
        let re: Range = start..<end
        let a = pas.substring(with: re)
        return a
    }
    
    //MARK: - JSON字符串转换为字典
    class func getDictionaryFromJSONString(jsonString:String) -> NSDictionary{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
}
