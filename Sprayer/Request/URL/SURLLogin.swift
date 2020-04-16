//
//  SURLLogin.swift
//  Sprayer
//
//  Created by FangLin on 2019/5/17.
//  Copyright © 2019 FangLin. All rights reserved.
//

///登录相关
import Foundation

/**
 * 登录
 * @param username   用户名
 * @param password   密码 （md5 16位加密）
 * @param system    1：ios   2：Android
 * @param appVersion  版本号
 * @param machineCode  机器码
 * @param type      登录类型   0：手机登录
 * @param checkSum
 * @return
 * @throws ApiException
@PostMapping
@ResponseBody
public Result<PnAccountModel> login(@RequestParam("username") String username,
@RequestParam("password") String password,
@RequestParam("system") Integer system,
@RequestParam("appVersion") String appVersion,
@RequestParam("machineCode") String machineCode,
@RequestParam("type") Integer type,
@RequestHeader("checkSum") String checkSum) throws ApiException
  */
let Login_Url = BASE_Url + "/pneuma/login"

/**
 * 退出登录
 * @param loginKey   用户登录凭证
 * @param checkSum
 * @return
 * @throws ApiException
@PostMapping(value = "logout")
@ResponseBody
public Result logout(@RequestParam("loginKey") String loginKey,
@RequestHeader("checkSum") String checkSum) throws ApiException {
  */
let Logout_Url = BASE_Url + "/pneuma/login/logout"

/**
 * 绑定mac地址
 * @param loginKey     用户凭证
 * @param macAddress     mac地址
 * @param checkSum
 * @return     0:失败  1：成功  2：已绑定
 * @throws ApiException
@PostMapping(value = "edit/mac/address")
@ResponseBody
public Integer editMacAddress(@RequestParam("loginKey") String loginKey,
@RequestParam("macAddress") String macAddress,
@RequestHeader("checkSum") String checkSum) throws ApiException
  */
let Url_EditMacAddress = BASE_Url + "/pneuma/account/edit/mac/address"

/**
 * mac地址绑定状态
 * @param macAddress     mac地址
 * @param checkSum
 * @return    1：未绑定   2：已绑定
 * @throws ApiException
@PostMapping(value = "get/mac/address/bind/state")
@ResponseBody
public Result getMacAddressBindState(@RequestParam("macAddress") String macAddress,
@RequestHeader("checkSum") String checkSum) throws ApiException {
  */
let URL_GetMacAddressBindState = BASE_Url + "/pneuma/account/get/mac/address/bind/state"

/**
 * 获取某个医生绑定的病人信息
 * @param doctorId 医生id
 * @param checkSum
 * @return
 * @throws ApiException
 
@PostMapping(value = "get/patients/info")
@ResponseBody
public Result<List<PnPatientsModel>> getPatientsInfo(@RequestParam("doctorId") Long doctorId,
                                                     @RequestParam("offset") int offset,
                                                     @RequestParam("count") int count,
                                                     @RequestHeader("checkSum") String checkSum) throws ApiException {
接口地址：http://localhost:7001/pneuma-api/pneuma/account/get/patients/info
 */
let URL_GetPatientsInfo = BASE_Url + "/pneuma/account/get/patients/info"

/**
     * 获取医生信息
     * @param doctorId 医生id
     * @param checkSum
     * @return
     * @throws ApiException
     
    @PostMapping(value = "get/doctor/info")
    @ResponseBody
    public Result<PnDoctorModel> getDoctorInfo(@RequestParam("doctorId") Long doctorId,
                                               @RequestHeader("checkSum") String checkSum) throws ApiException {
接口地址：http://localhost:7001/pneuma-api/pneuma/account/get/doctor/info
*/
let URL_GetDoctorInfo = BASE_Url + "/pneuma/account/get/doctor/info"
