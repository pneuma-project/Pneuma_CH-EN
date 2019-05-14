//
//  SURLRequest.swift
//  TestAlamofire
//
//  Created by DS on 2017/7/12.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

/*
 网络请求(基于Alamofire框架)
 */

import UIKit
import Alamofire
/// 请求成功回调
typealias ResponseSuccess = (_ data:Any)->()
/// 请求出错回调
typealias ResponseError = (_ error:Error)->()

//进度回调
typealias ResponseProgress = (_ pro: CGFloat)->()

class SURLRequest: NSObject {
    
    /// 单例
    class var sharedInstance: SURLRequest {
        struct instance {
            static let _instance:SURLRequest = SURLRequest()
        }
        return instance._instance
    }
    
    //自定义Alamofire.SessionManager.default(设置请求超时时间)
    static let defaultSessionManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 30 //30秒
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    /// Create a get request
    ///
    /// - Parameters:
    ///   - url: the request url
    ///   - suc: request success callback
    ///   - err: request error callback
    func requestGetWithUrl(_ url: String ,
                           suc: @escaping ResponseSuccess ,
                           err: @escaping ResponseError) {
        let urlStr: String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        SURLRequest.defaultSessionManager.request(urlStr)
            .responseJSON {response in
                switch response.result{
                case .success(let value):
                        suc(value)
                case .failure(let error):
                    err(error)
                }
        }
    }

    /// Create a post request
    ///
    /// - Parameters:
    ///   - url: the post request url
    ///   - param: the request parameters
    ///   - suc: request success callback
    ///   - err: request error callback
    func requestPostWithUrl(_ url :String ,
                            param :[String: Any]?,
                            suc :@escaping ResponseSuccess ,
                            err :@escaping ResponseError) {
        let urlStr: String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        SURLRequest.defaultSessionManager.request(urlStr, method: .post, parameters: param).responseJSON { (response) in
            
            switch response.result{
            case .success(let value):
                suc(value)
            case .failure(let error):
                err(error)
            }
        }
    }

    /// Create a get request with request header
    ///
    /// - Parameters:
    ///   - url: the get request url
    ///   - checkSum: checkSumArray
    ///   - suc: request success callback
    ///   - err: request error callback
    func requestGetWithHeader(_ url :String ,
                               param :[String: Any]? = nil,
                               checkSum:[String],
                               suc :@escaping ResponseSuccess ,
                               err :@escaping ResponseError) {
        guard let urlStr: String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {return}
        let checkCode = SURLHelper.getCheckCode(checkArr: checkSum)
        SURLRequest.defaultSessionManager.request(urlStr, method: .get, parameters: param, headers: checkCode).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                suc(value)
            case .failure(let error):
                err(error)
            }
        }
    }
    
    /// Create a post request with request header
    ///
    /// - Parameters:
    ///   - url: the post request url
    ///   - param: the request parameters
    ///   - checkSum: checkSumArray
    ///   - suc: request success callback
    ///   - err: request error callback
    func requestPostWithHeader(_ url :String ,
                               param :[String: Any]?,
                               checkSum:[String],
                               suc :@escaping ResponseSuccess ,
                               err :@escaping ResponseError) {
        guard let urlStr: String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {return}
        let checkCode = SURLHelper.getCheckCode(checkArr: checkSum)
        SURLRequest.defaultSessionManager.request(urlStr, method: .post, parameters: param, headers: checkCode).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                    suc(value)
            case .failure(let error):
                err(error)
            }
        }
    }

    /// 下载歌曲、伴奏、歌词请求(存储在DOCUMENT下)
    ///
    /// - Parameters:
    ///   - url: 下载路径
    ///   - songName: 歌曲、伴奏、歌词名
    ///   - downType: 文件类型
    ///   - pro: 下载进度回调
    ///   - suc: 请求成功回调
    ///   - err: 请求失败回调
    func down(url: String,songName: String, downType: String, pro: @escaping ResponseProgress,suc: @escaping ResponseSuccess, err: @escaping ResponseError){
        let urlStr: String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let manager = FileManager.default
        if !manager.fileExists(atPath: downLoadFile) {
            try! manager.createDirectory(atPath: downLoadFile, withIntermediateDirectories: true, attributes: nil)
        }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let a: String = String.init(format: "DownLoad/%@.%@", songName,downType)
            let fileURL = documentsURL.appendingPathComponent(a)
            return (fileURL, [.createIntermediateDirectories, .removePreviousFile])
        }
    
        Alamofire.download(urlStr, to: destination).downloadProgress { (progress) in
            let a = progress.completedUnitCount
            let b = progress.totalUnitCount
            let pro1: CGFloat = CGFloat(a)/CGFloat(b)
            if downType == "mp3"{
                pro(pro1)
            }
        }.responseData { (data1) in
            switch data1.result{
            case .success(let value):
                if downType == "mp3"{
                    suc(value)
                }
            case .failure(let error):
                if downType == "mp3"{
                    err(error)
                }
            }
        }
    }
    
    //
    
    /// 下载文件请求(存储在DOCUMENT下)
    ///
    /// - Parameters:
    ///   - url: 下载路径
    ///   - name: 文件名
    ///   - downType: 文件类型
    ///   - address: 存储路径
    ///   - pro: 下载进度回调
    ///   - suc: 请求成功回调
    ///   - err: 请求失败回调
    func downAnimation(url: String,name: String, downType: String,address: String, pro: @escaping ResponseProgress,suc: @escaping ResponseSuccess, err: @escaping ResponseError){
        let urlStr: String = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let manager = FileManager.default
        if !manager.fileExists(atPath: downLoadFile) {
            try! manager.createDirectory(atPath: downLoadFile, withIntermediateDirectories: true, attributes: nil)
        }
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let a: String = String.init(format: "%@/%@.%@",address, name,downType)
            let fileURL = documentsURL.appendingPathComponent(a)
            return (fileURL, [.createIntermediateDirectories, .removePreviousFile])
        }
        
        Alamofire.download(urlStr, to: destination).downloadProgress { (progress) in
            let a = progress.completedUnitCount
            let b = progress.totalUnitCount
            let pro1: CGFloat = CGFloat(a)/CGFloat(b)
                pro(pro1)
            }.responseData { (data1) in
                switch data1.result{
                case .success(let value):
                        suc(value)
                case .failure(let error):
                        err(error)
                }
        }
    }
}
