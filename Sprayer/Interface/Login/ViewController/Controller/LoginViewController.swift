//
//  LoginViewController.swift
//  Sheng
//
//  Created by FL on 2017/7/24.
//  Copyright © 2017年 First Cloud. All rights reserved.
//

/*
    登录界面
 */

import UIKit
import SwiftyJSON
import CoreData
import CryptoSwift
import Toast_Swift

class LoginViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var iphoneLabel: UILabel!
    @IBOutlet weak var iphoneTF: UITextField!
    
    @IBOutlet weak var oneLineLabel: UILabel!
    @IBOutlet weak var twoLineLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var bigRemView: UIView!
    @IBOutlet weak var smallRemView: UIView!
    @IBOutlet weak var rememberLabel: UILabel!
    
    @IBOutlet weak var forgetPwdBtn: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    var isRememberSelect:Bool = UserDefaults.standard.string(forKey: "isRemember") == nil ? true:FLUserDefaultsBoolGet(key: "isRemember")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //隐藏导航
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(true, animated: false)
            navigationController.interactivePopGestureRecognizer?.delegate = self  //侧滑返回
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(viewAction))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
        self.configInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUserNameAndPwd()
    }
    
    func setUserNameAndPwd() {
        if UserDefaults.standard.string(forKey: "userName") != nil {
            iphoneTF.text = FLUserDefaultsStringGet(key: "userName")
        }
        if UserDefaults.standard.string(forKey: "userName") != nil {
            if isRememberSelect {
                passwordTF.text = FLUserDefaultsStringGet(key: "password")
            }
        }
    }
    
    //MARK: - 配置界面
    func configInterface() {
        //标题
        titleLabel.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 18 : 17)
        titleLabel.textColor = HEXCOLOR(h: 0x1f1f1f, alpha: 1.0)
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(STATUSBAR_HEIGHT+CGFloat(40*IPONE_SCALE))
            maker.centerX.equalTo(self.view)
        }
        
        //手机号下的分割线
        oneLineLabel.backgroundColor = HEXCOLOR(h: 0xdadada, alpha: 1.0)
        oneLineLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(200*IPONE_SCALE)
            maker.left.equalTo(ISIPHONE6p ? 35 : 30)
            maker.right.equalTo(ISIPHONE6p ? -35 : -30)
            maker.height.equalTo(0.5)
        }
        
        //手机号
        iphoneLabel.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        iphoneLabel.textColor = HEXCOLOR(h: 0x676779, alpha: 1.0)
        iphoneLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(oneLineLabel)
            maker.bottom.equalTo(oneLineLabel.snp.top).offset(ISIPHONE6p ? -11 : -10)
            maker.height.equalTo(ISIPHONE6p ? 14 : 12)
        }
        
        //手机号输入框
        iphoneTF.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        iphoneTF.textColor = HEXCOLOR(h: 0x1f1f1f, alpha: 1.0)
        iphoneTF.delegate = self
        iphoneTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(iphoneLabel.snp.right).offset(ISIPHONE6p ? 36 : 31)
            maker.right.equalTo(ISIPHONE6p ? -35 : -30)
            maker.centerY.equalTo(iphoneLabel)
        }
        
        //密码下的分割线
        twoLineLabel.backgroundColor = HEXCOLOR(h: 0xdadada, alpha: 1.0)
        twoLineLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(oneLineLabel.snp.bottom).offset(ISIPHONE6p ? 89 : 77)
            maker.left.equalTo(ISIPHONE6p ? 35 : 30)
            maker.right.equalTo(ISIPHONE6p ? -35 : -30)
            maker.height.equalTo(0.5)
        }
        
        //密码
        passwordLabel.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        passwordLabel.textColor = HEXCOLOR(h: 0x676779, alpha: 1.0)
        passwordLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(twoLineLabel)
            maker.bottom.equalTo(twoLineLabel.snp.top).offset(ISIPHONE6p ? -11 : -10)
            maker.height.equalTo(ISIPHONE6p ? 14 : 12)
        }
        
        //密码输入框
        passwordTF.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        passwordTF.textColor = HEXCOLOR(h: 0x1f1f1f, alpha: 1.0)
        passwordTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(iphoneTF)
            maker.right.equalTo(ISIPHONE6p ? -35 : -30)
            maker.centerY.equalTo(passwordLabel)
        }
        
        //大环 -记住密码
        bigRemView.layer.borderColor = HEXCOLOR(h: 0x85888d, alpha: 1.0).cgColor
        bigRemView.layer.borderWidth = 0.5
        bigRemView.layer.cornerRadius = ISIPHONE6p ? 13/2 : 11/2
        bigRemView.layer.masksToBounds = true
        bigRemView.backgroundColor = UIColor.white
        bigRemView.snp.makeConstraints { (maker) in
            maker.left.equalTo(twoLineLabel)
            maker.top.equalTo(twoLineLabel.snp.bottom).offset(ISIPHONE6p ? 26 : 22)
            maker.width.height.equalTo(ISIPHONE6p ? 13 : 11)
        }
        
        //小view -记住密码
        if isRememberSelect {
            smallRemView.isHidden = false
        }else {
            smallRemView.isHidden = true
        }
        smallRemView.layer.cornerRadius = ISIPHONE6p ? 7/2 : 6/2
        smallRemView.layer.masksToBounds = true
        smallRemView.backgroundColor = HEXCOLOR(h: 0xffd400, alpha: 1.0)
        smallRemView.snp.makeConstraints { (maker) in
            maker.center.equalTo(bigRemView)
            maker.width.height.equalTo(ISIPHONE6p ? 7 : 6)
        }
        
        //记住密码
        rememberLabel.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 12 : 11)
        rememberLabel.textColor = HEXCOLOR(h: 0x67677a, alpha: 1.0)
        rememberLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(bigRemView.snp.right).offset(ISIPHONE6p ? 7 : 5)
            maker.height.equalTo(11)
            maker.centerY.equalTo(bigRemView)
        }
        let remenberBtn = UIButton.init(type: .custom)
        remenberBtn.addTarget(self, action: #selector(rememberAction), for: .touchUpInside)
        self.view.addSubview(remenberBtn)
        remenberBtn.snp.makeConstraints { (make) in
            make.left.equalTo(twoLineLabel)
            make.right.equalTo(rememberLabel.snp.right)
            make.centerY.equalTo(bigRemView)
            make.height.equalTo(20)
        }
        
        //忘记密码
        forgetPwdBtn.isHidden = true
        forgetPwdBtn.titleLabel?.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 12 : 11)
        forgetPwdBtn.setTitleColor(HEXCOLOR(h: 0x67677a, alpha: 1.0), for: UIControlState.normal)
        forgetPwdBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(ISIPHONE6p ? -35 : -30)
            maker.top.equalTo(twoLineLabel.snp.bottom).offset(ISIPHONE6p ? 26 : 22)
            maker.height.equalTo(11)
        }
        
        //登录按钮
        loginBtn.setTitleColor(HEXCOLOR(h: 0xffffff, alpha: 1.0), for: UIControlState.normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: ISIPHONE6p ? 15 : 13)
        loginBtn.layer.borderWidth = 0.5
        loginBtn.layer.borderColor = HEXCOLOR(h: 0xd28a00, alpha: 1.0).cgColor
        loginBtn.layer.cornerRadius = ISIPHONE6p ? 3.3 : 3.0
        loginBtn.layer.masksToBounds = true
        loginBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(forgetPwdBtn.snp.bottom).offset(ISIPHONE6p ? 50 : 40)
            maker.width.equalTo(ISIPHONE6p ? 269 : 234)
            maker.height.equalTo(ISIPHONE6p ? 45 : 40)
            maker.centerX.equalTo(self.view)
        }
    }
    
    //MARK: - 记住密码
    @objc func rememberAction() {
        isRememberSelect = !isRememberSelect
        if isRememberSelect {
            smallRemView.isHidden = false
        }else {
            smallRemView.isHidden = true
        }
        FLUserDefaultsBoolSet(key: "isRemember", obj: isRememberSelect)
    }
    
    
    //MARK: - 忘记密码
    @IBAction func forgetAction(_ sender: Any) {
        
    }
    
    
    //MARK: - 手机号登录
    @IBAction func LoginAction(_ sender: Any) {
        if iphoneTF.isFirstResponder {
            iphoneTF.resignFirstResponder()
        }else if passwordTF.isFirstResponder {
            passwordTF.resignFirstResponder()
        }
        if (iphoneTF.text?.isEmpty)! {
            self.view.makeToast("Phone number cannot be empty", duration: 1.0, position: .center)
            Dprint("手机号为空")
            return
        }else if (passwordTF.text?.isEmpty)! {
            self.view.makeToast("Password cannot be empty", duration: 1.0, position: .center)
            Dprint("密码为空")
            return
        }
        //加载动画
        self.view.makeToastActivity(.center)
        
        //密码md5加密
        let pwd = Tools.getMD5Str(content: passwordTF.text!)
        let appVersion = "V" + APP_VERSION
        let params = ["username":iphoneTF.text!,"password":pwd,"system":1,"appVersion":appVersion,"machineCode":getUUID(),"type":0] as [String : Any]
        SURLRequest.sharedInstance.requestPostWithHeader(Login_Url, param: params, checkSum: ["\(iphoneTF.text!)","\(pwd)","1","\(appVersion)","\(getUUID())","0"], suc: { [weak self](responseObject) in
            if let weekself = self{
                //隐藏加载动画
                weekself.view.hideToastActivity()
                Dprint("LOGIN_URL:\(responseObject)")
                let jsonDict = JSON(responseObject)
                if jsonDict["code"].stringValue == "200" {  //后台登录成功
                    let content = jsonDict["result"]
                    UserInfoModel.userData(content: content)
//                    FLUserDefaultsStringSet(key: "pwd", obj: weekself.passwordTF.text!)
                    FLUserDefaultsStringSet(key: "userName", obj: weekself.iphoneTF.text!)
                    if weekself.isRememberSelect {
                        FLUserDefaultsStringSet(key: "password", obj: weekself.passwordTF.text!)
                    }else {
                        FLUserDefaultsStringSet(key: "password", obj: "")
                    }
                    weekself.loginSucceeAction()
                }else {
                    let code = jsonDict["code"].stringValue
                    if code == "4000000" {
                        weekself.view.makeToast("用户名为空", duration: 1.0, position: .center)
                    }else if code == "4000001" {
                        weekself.view.makeToast("密码为空", duration: 1.0, position: .center)
                    }else if code == "4000002" {
                        weekself.view.makeToast("此账号不存在", duration: 1.0, position: .center)
                    }else if code == "4000003" {
                        weekself.view.makeToast("密码错误", duration: 1.0, position: .center)
                    }else if code == "4000004" {
                        weekself.view.makeToast("您的设备或账号已被禁封", duration: 2.0, position: .center)
                    }else if code == "5000000" {
                        weekself.view.makeToast("异常错误", duration: 2.0, position: .center)
                    }else if code == "7000000" {
                        weekself.view.makeToast("机器码为空", duration: 2.0, position: .center)
                    }else{
                        weekself.view.makeToast("未知错误", duration: 2.0, position: .center)
                    }
                }
            }
        }) { [weak self](error:Error) in
            if let weakSelf = self{
                //隐藏加载动画
                weakSelf.view.hideToastActivity()
                weakSelf.view.makeToast("请求出错", duration: 1.5, position: .center)
                Dprint("LOGIN_URLError:\(error)")
            }
        }
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - self.view点击事件，结束编辑
    @objc func viewAction() {
        self.view.endEditing(true)
    }
    
    //MARK: - 登录成功后的跳转
    func loginSucceeAction() {
        let rootVC = RootViewController()
        UIApplication.shared.keyWindow?.rootViewController = rootVC
    }
}


extension LoginViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == iphoneTF {
            passwordTF.text = ""
        }
        return true
    }
}
