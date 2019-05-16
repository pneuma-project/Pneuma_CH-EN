//
//  FLUserDefaults.swift
//  Sheng
//
//  Created by Cheng Rong on 2017/9/8.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

import UIKit

func FLUserDefaultsSet(key:String, obj:AnyObject) {
    UserDefaults.standard.set(obj, forKey: key)
    FLUserDefaultsSyn()
}
func FLUserDefaultsBoolSet(key:String, obj:Bool) {
    UserDefaults.standard.set(obj, forKey: key)
    FLUserDefaultsSyn()
}
func FLUserDefaultsStringSet(key:String, obj:String) {
    UserDefaults.standard.set(obj, forKey: key)
    FLUserDefaultsSyn()
}
func FLUserDefaultsGet(key:String) -> AnyObject {
    return UserDefaults.standard.value(forKey: key)! as AnyObject
}
func FLUserDefaultsBoolGet(key:String) -> Bool {
    return UserDefaults.standard.bool(forKey: key)
}
func FLUserDefaultsStringGet(key:String) -> String {
    return UserDefaults.standard.string(forKey: key)!
}
func FLUserDefaultsRemo(key:String) {
    UserDefaults.standard.removeObject(forKey: key)
    FLUserDefaultsSyn()
}
func FLUserDefaultsSyn() {
    UserDefaults.standard.synchronize()
}
