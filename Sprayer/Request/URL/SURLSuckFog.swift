//
//  SURLSuckFog.swift
//  Sprayer
//
//  Created by FangLin on 2019/5/17.
//  Copyright © 2019 FangLin. All rights reserved.
//

//吸雾数据相关
import Foundation

let Base_SuckFog_Url = BASE_Url + "/pneuma/suck/fog/"

/**
 * 添加训练数据
 * @param loginKey     用户凭证
 * @param medicineId   药物id
 * @param trainData    训练数据
 * @param addDate      训练时间 （格式: 2019-05-17 00:00:01）
 * @param checkSum
 * @return
 * @throws ApiException
@PostMapping(value = "save/train/data")
@ResponseBody
public Result saveTrainData(@RequestParam("loginKey") String loginKey,
@RequestParam("medicineId") String medicineId,
@RequestParam("trainData") String trainData,
@RequestParam("addDate") String addDate,
@RequestHeader("checkSum") String checkSum) throws ApiException {
  */
let URL_SaveTrainData = Base_SuckFog_Url + "save/train/data"

/**
 * 获取最新一条训练数据
 * @param loginKey     用户凭证
 * @param checkSum
 * @return
 * @throws ApiException
@PostMapping(value = "get/new/train/data")
@ResponseBody
public Result<PnSuckFogDataModel> getNewTrainData(@RequestParam("loginKey") String loginKey,
@RequestHeader("checkSum") String checkSum) throws ApiException {
  */
let URL_GetNewTrainData = Base_SuckFog_Url + "get/new/train/data"

/**
 * 添加吸雾数据
 * @param loginKey     用户凭证
 * @param medicineId   药物id
 * @param suckFogData    训练数据
 * @param addDate      训练时间
 * @param checkSum
 * @return
 * @throws ApiException
@PostMapping(value = "save/suck/fog/data")
@ResponseBody
public Result saveSuckFogData(@RequestParam("loginKey") String loginKey,
@RequestParam("medicineId") String medicineId,
@RequestParam("suckFogData") String suckFogData,
@RequestParam("addDate") String addDate,
@RequestHeader("checkSum") String checkSum) throws ApiException {
 */
let URL_SaveSuckFogData = Base_SuckFog_Url + "save/suck/fog/data"

/**
 * 获取历史吸雾数据
 * @param loginKey     用户凭证
 * @param offset
 * @param count
 * @param checkSum
 * @return
 * @throws ApiException
@PostMapping(value = "get/history/suck/fog/data")
@ResponseBody
public Result<List<PnSuckFogDataModel>> getHistorySuckFogData(@RequestParam("loginKey") String loginKey,
@RequestParam("offset") Integer offset,
@RequestParam("count") Integer count,
@RequestHeader("checkSum") String checkSum) throws ApiException {
  */
let URL_GetHistorySuckFogData = Base_SuckFog_Url + "get/history/suck/fog/data"
