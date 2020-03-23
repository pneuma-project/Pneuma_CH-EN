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
     * 获取某天呼气数据
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


