//
//  DoctorBoardObject.swift
//  Sprayer
//
//  Created by fanglin on 2020/4/16.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit

class DoctorBoardObject: NSObject {
    private static var _sharedInstance: DoctorBoardObject?
    private override init() {
         
    }
    
    class func shared() -> DoctorBoardObject {
        guard let instance = _sharedInstance else {
            _sharedInstance = DoctorBoardObject()
            return _sharedInstance!
        }
        return instance
    }
    
    class func destroy() {
        _sharedInstance = nil
    }
    
    var doctorSsId:Int32 = 0
    
    
}
