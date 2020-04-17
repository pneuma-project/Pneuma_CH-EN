//
//  SMainBoardObject.swift
//  Sprayer
//
//  Created by fanglin on 2020/4/17.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit

class SMainBoardObject: NSObject {
    private static var _sharedInstance: SMainBoardObject?
    private override init() {
         
    }
    
    class func shared() -> SMainBoardObject {
        guard let instance = _sharedInstance else {
            _sharedInstance = SMainBoardObject()
            return _sharedInstance!
        }
        return instance
    }
    
    class func destroy() {
        _sharedInstance = nil
    }
    
    //账号类型 ： 0：患者    1：医生  2：超级管理员
    var role:Int16 = 0
}
