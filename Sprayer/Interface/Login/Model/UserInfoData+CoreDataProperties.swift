//
//  UserInfoData+CoreDataProperties.swift
//  Sprayer
//
//  Created by FangLin on 2019/5/16.
//  Copyright © 2019 FangLin. All rights reserved.
//
//

import Foundation
import CoreData


extension UserInfoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfoData> {
        return NSFetchRequest<UserInfoData>(entityName: "UserInfoData")
    }

    @NSManaged public var add_date: Int64
    @NSManaged public var birthday: Int64
    @NSManaged public var edit_date: Int64
    @NSManaged public var head_img: String?
    @NSManaged public var height: Int16
    @NSManaged public var is_frozen: Int16
    @NSManaged public var last_password_error_num: Int16
    @NSManaged public var last_password_error_time: Int64
    @NSManaged public var mac_address: String?
    @NSManaged public var machine_code: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var phone: String?
    @NSManaged public var race: String?
    @NSManaged public var relationship: String?
    @NSManaged public var sex: Int16
    @NSManaged public var ss_id: Int32
    @NSManaged public var user_id: Int32
    @NSManaged public var username: String?
    @NSManaged public var weight: Int16

}
