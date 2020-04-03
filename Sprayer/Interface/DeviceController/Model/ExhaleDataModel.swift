//
//  ExhaleDataModel.swift
//  Sprayer
//
//  Created by fanglin on 2020/3/10.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit
import SwiftyJSON

//呼气数据模型
class ExhaleDataModel: NSObject {
    /**
     * 呼气数据
     */
    @objc var exhaleData:String = ""
    
    /**
     * 数据总和
     */
    @objc var exhaleDataSum:Double = 0
    
    /**
     * 药物id
     */
    @objc var medicineId:Int32 = 0
    
    /**
     * 呼气时间
     */
    @objc var exhaleAddDate:String = ""
    
    /**
     * 当天吸雾次数
     */
    @objc var exhaleNum:Int16 = 0
    
    /**
     * 添加时间
     */
    @objc var addDate:Int64 = 0
    
    var list:[Int8] = []
    
    class func getFromModel(json:JSON) -> ExhaleDataModel {
        let model = ExhaleDataModel()
        model.exhaleData = json["exhaleData"].stringValue
        model.exhaleDataSum = json["exhaleDataSum"].doubleValue
        model.medicineId = json["medicineId"].int32Value
        model.addDate = json["addDate"].int64Value
        model.exhaleNum = json["exhaleNum"].int16Value
        model.exhaleAddDate = json["exhaleAddDate"].stringValue
        return model
    }
    
    class func getHistoryFromModel(json:JSON) -> ExhaleDataModel {
        let model = ExhaleDataModel()
        model.exhaleData = json["exhaleData"].stringValue
        model.exhaleDataSum = json["exhaleDataSum"].doubleValue
        model.medicineId = json["medicineId"].int32Value
        model.addDate = json["addDate"].int64Value
        model.exhaleNum = json["exhaleNum"].int16Value
        model.exhaleAddDate = json["exhaleAddDate"].stringValue
        if let arr = json["list"].arrayObject as? [Int8] {
            model.list = arr
        }
        return model
    }
}

class ExhaleNumberModel: NSObject {
    @objc var list:[ExhaleDataModel] = []
    
    @objc var isNext:Bool = false
    
    class func getFromModel(json:JSON) -> ExhaleNumberModel {
        let model = ExhaleNumberModel.init()
        let listJson = json["list"].arrayValue
        for json in listJson {
            let jsonModel = ExhaleDataModel.getFromModel(json: json)
            model.list.append(jsonModel)
        }
        let listLastModel = model.list[model.list.count-1]
        if model.list.count < 3 {
            let nowtimeStamp = DisplayUtils.getNowTimestamp()
            if nowtimeStamp - listLastModel.addDate/1000 > 3600 {
                model.isNext = true
            }else {
                model.isNext = false
            }
        }else {
            model.isNext = true
        }
        return model
    }
}
