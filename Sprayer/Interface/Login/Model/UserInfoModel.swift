//
//  UserInfoModel.swift
//  Sprayer
//
//  Created by FangLin on 2019/5/16.
//  Copyright © 2019 FangLin. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import MagicalRecord

class UserInfoModel: NSObject {
    //用户唯一标识
    var ssId: Int32 = 0
    
    //用户id
    var userId: Int32 = 0
    
    //用户名
    var username: String = ""
    
    //密码
    var password: String = ""
    
    //姓名
    var name: String = ""
    
    //头像
    var headImg: String = ""
    
    //关系
    var relationship: String = ""
    
    //性别 1:male   2:female
    var sex: Int16 = 0
    
    //地区
    var race: String = ""
    
    //身高
    var height: Int16 = 0
    
    //体重
    var weight: Int16 = 0
    
    //电话
    var phone: String = ""
    
    //mac地址
    var macAddress: String = ""
    
    //0:正常   1:冻结
    var isFrozen: Int16 = 0
    
    //机器码
    var machineCode: String = ""
    
    //注册时间
    var addDate: Int64 = 0
    var editDate: Int64 = 0
    
    class func userData(content: JSON) {
        guard let arr = UserInfoData.mr_findAll() as? [UserInfoData] else {
            return
        }
        if arr.count > 0{
            for user: UserInfoData in arr{
                user.mr_deleteEntity()
                NSManagedObjectContext .mr_default().mr_saveToPersistentStoreAndWait()
            }
        }
        let userInfo: UserInfoData = UserInfoData.mr_createEntity()!
        
        userInfo.ssId = content["ssId"].int32Value
        userInfo.userId = content["userId"].int32Value
        userInfo.username = content["username"].stringValue
        userInfo.password = content["password"].stringValue
        userInfo.name = content["name"].stringValue
        userInfo.headImg = content["headImg"].stringValue
        
        userInfo.relationship = content["relationship"].stringValue
        userInfo.sex = content["sex"].int16Value
        userInfo.race = content["race"].stringValue
        userInfo.height = content["height"].int16Value
        
        userInfo.weight = content["weight"].int16Value
        userInfo.phone = content["phone"].stringValue
        userInfo.macAddress = content["macAddress"].stringValue
        userInfo.isFrozen = content["isFrozen"].int16Value
        userInfo.machineCode = content["machineCode"].stringValue
        
        userInfo.addDate = content["addDate"].int64Value
        userInfo.editDate = content["editDate"].int64Value
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }  //存储个人信息数据
}
