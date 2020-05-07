//
//  SURLExhale.swift
//  Sprayer
//
//  Created by fanglin on 2020/3/10.
//  Copyright © 2020 FangLin. All rights reserved.
//

///呼气数据相关
import Foundation

let Base_Exhale_Url = BASE_Url + "/pneuma/exhale/"


/**
     * 添加呼气数据
     * @param loginKey     用户凭证
     * @param medicineId   药物id
     * @param exhaleData    呼气数据
     * @param exhaleDataSum    呼气数据总和
     * @param addDate      训练时间 （格式: 2019-05-17 00:00:01）
     * @param checkSum
     * @return
     * @throws ApiException
    @PostMapping(value = "save/exhale/data")
    @ResponseBody
    public Result saveExHaleData(@RequestParam("loginKey") String loginKey,
                                @RequestParam("medicineId") String medicineId,
                                @RequestParam("exhaleData") String exhaleData,
                                @RequestParam("exhaleDataSum") Double exhaleDataSum,
                                @RequestParam("addDate") String addDate,
                                @RequestHeader("checkSum") String checkSum) throws ApiException {
地址：http://pneuma-admin.com/pneuma-api/pneuma/exhale/save/exhale/data
参数：loginKey=7c0050420ec4dc88&medicineId=1&exhaleData=16,27,38&exhaleDataSum=80&addDate=2020-03-09 15:19:01
*/
let URL_SaveExhaleData = Base_Exhale_Url + "save/exhale/data"


/**
     * 获取历史呼气数据(根据日期分组)
     * @param loginKey     用户凭证
     * @param checkSum
     * @return
     * @throws ApiException
    @PostMapping(value = "get/history/exhale/data/group/date")
    @ResponseBody
    public Result<List<PnExhaleDataModel>> getHistoryExhaleDataGroupDate(@RequestParam("loginKey") String loginKey,
                                                            @RequestHeader("checkSum") String checkSum) throws ApiException {
地址：http://pneuma-admin.com/pneuma-api/pneuma/exhale/get/history/exhale/data/group/date
参数：loginKey=7c0050420ec4dc88
*/
let URL_GetHistoryExhaleData = Base_Exhale_Url + "get/history/exhale/data/group/date"


/**
     * 获取某天呼气数据(废弃)
     * @param loginKey     用户凭证
     * @param addDate
     * @param endDate
     * @param checkSum
     * @return
     * @throws ApiException
    @PostMapping(value = "get/now/date/exhale/data")
    @ResponseBody
    public Result<List<PnExhaleDataModel>> getNowDateExhaleData(@RequestParam("loginKey") String loginKey,
                                                                  @RequestParam("addDate") String addDate,
                                                                  @RequestParam("endDate") String endDate,
                                                                  @RequestHeader("checkSum") String checkSum) throws ApiException {
地址：http://pneuma-admin.com/pneuma-api/pneuma/exhale/get/now/date/exhale/data
参数：loginKey=7c0050420ec4dc88&addDate=2020-03-09 00:00:01&endDate=2020-03-09 23:59:59
 */
let URL_GetNowDateExhaleData = Base_Exhale_Url + "get/now/date/exhale/data"

/**
     * 获取某天呼气数据(第二版)
     * @param loginKey     用户凭证
     * @param addDate    （格式: 2019-05-17 00:00:01）
     * @param endDate     （格式: 2019-05-17 00:00:01）
     * @param checkSum
     * @return
     * @throws ApiException
    @PostMapping(value = "get/now/date/exhale/data/v2")
    @ResponseBody
    public Result<List<PnExhaleDataListModel>> getNowDateExhaleDataV2(@RequestParam("loginKey") String loginKey,
                                                                      @RequestParam("addDate") String addDate,
                                                                      @RequestParam("endDate") String endDate,
                                                                      @RequestHeader("checkSum") String checkSum) throws ApiException {
地址：http://pneuma-admin.com/pneuma-api/pneuma/exhale/get/now/date/exhale/data/v2
参数：loginKey=7c0050420ec4dc88&addDate=2020-03-12 00:00:00&endDate=2020-03-12 23:59:59
 */
let URL_GetNowDateExhaleV2Data = Base_Exhale_Url + "get/now/date/exhale/data/v2"

/**
     * 获取呼气数据 （视频时使用）
     * @param loginKey 医生登录凭证
     * @param ssId     病人ssId
     * @param checkSum
     * @return
     * @throws ApiException
     
    @PostMapping(value = "get/tmp/exhale/data")
    @ResponseBody
    public Result<PnExhaleDataModel> getTmpExhaleData(@RequestParam("loginKey") String loginKey,
                                                      @RequestParam("ssId") Long ssId,
                                                      @RequestHeader("checkSum") String checkSum) throws ApiException {
接口地址：http://localhost:7001/pneuma-api/pneuma/exhale/get/tmp/exhale/data
*/
let URL_GetTmpExhaleData = Base_Exhale_Url + "get/tmp/exhale/data"


/**
     * 保存临时呼气数据（视频时使用）
     * @param loginKey      用户凭证
     * @param medicineId    药物id
     * @param exhaleData    呼气数据
     * @param exhaleDataSum 呼气数据总和
     * @param addDate       训练时间 （格式: 2019-05-17 00:00:01）
     * @param checkSum
     * @return
     * @throws ApiException
     
    @PostMapping(value = "save/tmp/exhale/data")
    @ResponseBody
    public Result saveTmpExHaleData(@RequestParam("loginKey") String loginKey,
                                    @RequestParam("medicineId") String medicineId,
                                    @RequestParam("exhaleData") String exhaleData,
                                    @RequestParam("exhaleDataSum") Double exhaleDataSum,
                                    @RequestParam("addDate") String addDate,
                                    @RequestHeader("checkSum") String checkSum) throws ApiException {
接口地址：http://localhost:7001/pneuma-api/pneuma/exhale/save/tmp/exhale/data
 */
let URL_SaveTmpExhaleData = Base_Exhale_Url + "save/tmp/exhale/data"


/**
     * 获取病人某天呼气数据
     *
     * @param loginKey 用户凭证
     * @param addDate
     * @param endDate
     * @param checkSum
     * @return
     * @throws ApiException
    
    @PostMapping(value = "get/patient/now/date/exhale/data")
    @ResponseBody
    public Result<List<PnExhaleDataListModel>> getPatientNowDateExhaleData(@RequestParam("loginKey") String loginKey,
                                                                      @RequestParam("ssId") Long ssId,
                                                                      @RequestParam("addDate") String addDate,
                                                                      @RequestParam("endDate") String endDate,
                                                                      @RequestHeader("checkSum") String checkSum) throws ApiException {
地址：http://pneuma-admin.com/pneuma-api/pneuma/exhale/get/patient/now/date/exhale/data
  */
let URL_GetPatientNowExhaleData = Base_Exhale_Url + "get/patient/now/date/exhale/data"


/**
     * 获取病人历史呼气数据(根据日期分组)
     *
     * @param loginKey 用户凭证
     * @param checkSum
     * @return
     * @throws ApiException
     
    @PostMapping(value = "get/patient/history/exhale/data/group/date")
    @ResponseBody
    public Result<List<PnExhaleDataModel>> getPatientHistoryExhaleDataGroupDate(@RequestParam("loginKey") String loginKey,
                                                                         @RequestParam("ssId") Long ssId,
                                                                         @RequestHeader("checkSum") String checkSum) throws ApiException {
地址：http://pneuma-admin.com/pneuma-api/pneuma/exhale/get/patient/history/exhale/data/group/date
*/
let URL_GetPatientHistoryExhaleData = Base_Exhale_Url + "get/patient/history/exhale/data/group/date"
