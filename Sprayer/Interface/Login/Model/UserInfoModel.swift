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
    var ss_id: Int32 = 0
    
    //用户id
    var user_id: Int32 = 0
    
    //用户名
    var username: String = ""
    
    //密码
    var password: String = ""
    
    //姓名
    var name: String = ""
    
    //头像
    var head_img: String = ""
    
    //关系
    var relationship: String = ""
    
    //性别 1:male   2:female
    var sex: Int16 = 0
    
    //生日
    var birthday: Int64 = 0
    
    //地区
    var race: String = ""
    
    //身高
    var height: Int16 = 0
    
    //体重
    var weight: Int16 = 0
    
    //电话
    var phone: String = ""
    
    //mac地址
    var mac_address: String = ""
    
    //0:正常   1:冻结
    var is_frozen: Int16 = 0
    
    //机器码
    var machine_code: String = ""
    
    //最后一次输入错误密码时间
    var last_password_error_time: Int64 = 0
    
    //一分钟之内输入密码次数
    var last_password_error_num: Int16 = 0
    
    //注册时间
    var add_date: Int64 = 0
    var edit_date: Int64 = 0
    
    class func userData(content: JSON) {
        let arr: [UserInfoData] = UserInfoData.mr_findAll()! as! [UserInfoData]
        if arr.count > 0{
            for user: UserInfoData in arr{
                user.mr_deleteEntity()
                NSManagedObjectContext .mr_default().mr_saveToPersistentStoreAndWait()
            }
        }
        let userInfo: UserInfoData = UserInfoData.mr_createEntity()!
        
        userInfo.ss_id = content["ss_id"].int32Value
        userInfo.user_id = content["user_id"].int32Value
        userInfo.username = content["username"].stringValue
        userInfo.password = content["password"].stringValue
        userInfo.name = content["name"].stringValue
        userInfo.head_img = content["head_img"].stringValue
        
        userInfo.relationship = content["relationship"].stringValue
        userInfo.sex = content["sex"].int16Value
        userInfo.birthday = content["birthday"].int64Value
        userInfo.race = content["race"].stringValue
        userInfo.height = content["height"].int16Value
        
        userInfo.weight = content["weight"].int16Value
        userInfo.phone = content["phone"].stringValue
        userInfo.mac_address = content["mac_address"].stringValue
        userInfo.is_frozen = content["is_frozen"].int16Value
        userInfo.machine_code = content["machine_code"].stringValue
        
        userInfo.last_password_error_time = content["last_password_error_time"].int64Value
        userInfo.last_password_error_num = content["last_password_error_num"].int16Value
        userInfo.add_date = content["add_date"].int64Value
        userInfo.edit_date = content["edit_date"].int64Value
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }  //存储个人信息数据
}
