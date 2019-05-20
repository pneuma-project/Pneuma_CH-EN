//
//  SprayerDataModel.swift
//  Sprayer
//
//  Created by fanglin on 2019/5/20.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit
import SwiftyJSON

class SprayerDataModel: NSObject {
    @objc var suckFogData:String = ""
    
    @objc var dataSum:Float = 0.0
    
    @objc var medicineId:Int32 = 0
    
    @objc var addDate:Int64 = 0
    
    class func getFromModel(json:JSON) -> SprayerDataModel {
        let model = SprayerDataModel()
        model.suckFogData = json["suckFogData"].stringValue
        model.dataSum = json["dataSum"].floatValue
        model.medicineId = json["medicineId"].int32Value
        model.addDate = json["addDate"].int64Value
        return model
    }
}
