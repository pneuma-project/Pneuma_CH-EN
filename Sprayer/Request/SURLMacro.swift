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
/// 渠道号  1-备份 2008300-正式
let SCHANNEL_ID = 2008300

/// 域名
let BASE_Url = (SCHANNEL_ID == 1) ? "":"http://pneuma-admin.com/pneuma-api"

/// get请求后缀
let Suffix_Get = "/json"

/// post请求后缀
let Suffix_Post = "/jform"

