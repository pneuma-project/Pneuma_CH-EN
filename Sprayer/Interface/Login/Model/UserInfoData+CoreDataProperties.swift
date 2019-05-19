//
//  UserInfoData+CoreDataProperties.swift
//  Sprayer
//
//  Created by FangLin on 2019/5/17.
//  Copyright © 2019 FangLin. All rights reserved.
//
//

import Foundation
import CoreData


extension UserInfoData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfoData> {
        return NSFetchRequest<UserInfoData>(entityName: "UserInfoData")
    }

    @NSManaged public var addDate: Int64
    @NSManaged public var editDate: Int64
    @NSManaged public var headImg: String?
    @NSManaged public var height: Int16
    @NSManaged public var isFrozen: Int16
    @NSManaged public var macAddress: String?
    @NSManaged public var machineCode: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var phone: String?
    @NSManaged public var race: String?
    @NSManaged public var relationship: String?
    @NSManaged public var sex: Int16
    @NSManaged public var ssId: Int32
    @NSManaged public var userId: Int32
    @NSManaged public var username: String?
    @NSManaged public var weight: Int16
    @NSManaged public var age: Int16
    @NSManaged public var loginKey: String?

}
