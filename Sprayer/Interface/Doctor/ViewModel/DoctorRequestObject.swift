//
//  DoctorRequestObject.swift
//  Sprayer
//
//  Created by fanglin on 2020/4/15.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit
import SwiftyJSON

class DoctorRequestObject: NSObject {
    @objc class var shared: DoctorRequestObject {
        struct instance {
            static let _instance:DoctorRequestObject = DoctorRequestObject()
        }
        return instance._instance
    }
    
    var requestGetPatientsInfoListSuc:((_ dataList:[UserInfoModel])->())?
    func requestGetPatientsInfoList(doctorId:Int32) {
        SURLRequest.sharedInstance.requestPostWithHeader(URL_GetPatientsInfo, param: ["doctorId":doctorId,"offset":0,"count":999], checkSum: ["\(doctorId)","0","999"], suc: { (data) in
            Dprint("URL_GetPatientsInfo:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            if code == "200" {
                var dataArr:[UserInfoModel] = []
                let resultJsonArr = dataJson["result"].arrayValue
                for resultJson:JSON in resultJsonArr {
                    let model = UserInfoModel.getFromModel(json: resultJson)
                    dataArr.append(model)
                }
                if let block = DoctorRequestObject.shared.requestGetPatientsInfoListSuc {
                    block(dataArr)
                }
            }
        }) { (error) in
            Dprint("URL_GetPatientsInfoError:\(error)")
        }
    }
    
    var requestGetTmpExhaleDataSuc:((_ model:ExhaleDataModel)->())?
    func requestGetTmpExhaleData(patientSsId:Int32) {
        if let loginKey = UserInfoData.mr_findFirst()?.loginKey {
            SURLRequest.sharedInstance.requestPostWithHeader(URL_GetTmpExhaleData, param: ["loginKey":loginKey,"ssId":patientSsId], checkSum: [loginKey,"\(patientSsId)"], suc: { (data) in
                Dprint("URL_GetTmpExhaleData:\(data)")
                let dataJson = JSON(data)
                let code = dataJson["code"].stringValue
                if code == "200" {
                    let resultJson = dataJson["result"]
                    let model = ExhaleDataModel.getFromModel(json: resultJson)
                    if let block = DoctorRequestObject.shared.requestGetTmpExhaleDataSuc {
                        block(model)
                    }
                }
            }) { (error) in
                Dprint("URL_GetTmpExhaleDataError:\(error)")
            }
        }
        
    }
    
    @objc var requestGetDoctorInfoSuc:((_ model:UserInfoModel)->())?
    @objc func requestGetDoctorInfo(doctorId:Int32) {
        SURLRequest.sharedInstance.requestPostWithHeader(URL_GetDoctorInfo, param: ["doctorId":doctorId], checkSum: ["\(doctorId)"], suc: { (data) in
            Dprint("URL_GetDoctorInfo:\(data)")
            let dataJson = JSON(data)
            let code = dataJson["code"].stringValue
            if code == "200" {
                let resultJson = dataJson["result"]
                let model = UserInfoModel.getFromModel(json: resultJson)
                DoctorBoardObject.shared().doctorSsId = model.ssId
                if let block = DoctorRequestObject.shared.requestGetDoctorInfoSuc {
                    block(model)
                }
            }
        }) { (error) in
            Dprint("URL_GetDoctorInfoError:\(error)")
        }
    }
}
