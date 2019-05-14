//
//  SURLMacro.swift
//  Sheng
//
//  Created by DS on 2017/7/12.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

/*
 URL管理类
 */

import Foundation

// MARK: - BASE
/// 渠道号  1-备份 2-本地 60380000-正式 60990000-企业版 60660000-小版本（cn.psgker空耳语音）60550000-小版本（cn.kefm空耳FM） （如果增加一个渠道号，SCHANNEL_ID，is_no_qiye_version，is_test_version，UMCHANNELID，都需要做检查）
let SCHANNEL_ID = 1

/// 域名
let BASE_Url = (SCHANNEL_ID == 1) ? "https://i.sheng.mchang.cn/api-sheng":""

/// get请求后缀
let Suffix_Get = "/json"

/// post请求后缀
let Suffix_Post = "/jform"

