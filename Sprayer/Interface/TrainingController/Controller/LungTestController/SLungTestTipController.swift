//
//  SLungTestTipController.swift
//  Sprayer
//
//  Created by fanglin on 2020/3/12.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit

class SLungTestTipController: BaseViewController,CustemBBI {
    
    var tipBgView:UIView = UIView.init()
    var testNumLabel:UILabel = UILabel.init()
    var tipLabel:UILabel = UILabel.init()
    var startTestButton:UIButton = UIButton.init(type: .custom)
    
    var timer:Timer?
    
    var todayTestNum:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.setNavTitle(NSLocalizedString("Pulmonary Function Test", comment: ""))
        self.setInterface()
        self.requestDataBlock()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CustemNavItem.initWith(UIImage.init(named: "icon-back"), andTarget: self, andinfoStr: "first")
        self.requestData()
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectAction), name: NSNotification.Name(rawValue: PeripheralDidConnect), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopLungTrain), name: NSNotification.Name(rawValue: "stopLungTrain"), object: nil)
    }
    
    func bbIdidClick(withName infoStr: String!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func requestData() {
        guard let dateTime = DisplayUtils.getTimestampData("YYYY-MM-dd") else {
            return
        }
        let startStr = String.init(format: "%@ 00:00:00", dateTime)
        let endStr = String.init(format: "%@ 23:59:59", dateTime)
        DeviceRequestObject.shared.requestGetNowExhaleData(addDate: startStr, endDate: endStr)
    }
    
    @objc func writeDataAction() {
        let time = DisplayUtils.getNowTimestamp()
        let timeData = FLDrawDataTool.long(toNSData: time)
        BlueWriteData.startLungFunctionTrain(timeData)
    }
    
    @objc func disconnectAction() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    @objc func stopLungTrain() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
}

//数据回调
extension SLungTestTipController {
    func requestDataBlock() {
        DeviceRequestObject.shared.requestGetNowExhaleDataSuc = {[weak self](dataList) in
            if let weakself = self {
                weakself.todayTestNum = dataList.count
                if dataList.count == 3 {
                    weakself.testNumLabel.text = "您今天已测试完三次"
                    weakself.startTestButton.isEnabled = false
                }else {
                    weakself.testNumLabel.text = "您今天还差\(3-dataList.count)次测试"
                    weakself.startTestButton.isEnabled = true
                }
            }
        }
    }
}

extension SLungTestTipController {
    func setInterface() {
        tipBgView.backgroundColor = .white
        tipBgView.layer.borderWidth = 1
        tipBgView.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(tipBgView)
        tipBgView.snp.makeConstraints { (make) in
            make.top.equalTo(NEWNAVHEIGHT+10)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-120)
        }
        
        testNumLabel.font = UIFont.boldSystemFont(ofSize: 18)
        testNumLabel.text = "您今天还差3次测试"
        tipBgView.addSubview(testNumLabel)
        testNumLabel.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.height.equalTo(18)
            make.centerX.equalToSuperview()
        }
        
        tipLabel.font = UIFont.systemFont(ofSize: 17)
        tipLabel.text = "1、建议每天进行三次测试.\n\n2、点击开始训练，跟着提示进行测试."
        tipLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        tipLabel.numberOfLines = 0
        tipBgView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { (make) in
            make.top.equalTo(testNumLabel.snp.bottom).offset(40)
            make.left.equalTo(30)
            make.right.equalTo(30)
        }
        
        startTestButton.layer.cornerRadius = 7
        startTestButton.layer.masksToBounds = true
        startTestButton.setTitle(NSLocalizedString("Start Testing", comment: ""), for: .normal)
        startTestButton.setTitleColor(HEXCOLOR(h: 0xffffff, alpha: 1), for: .normal)
        startTestButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        startTestButton.backgroundColor = RGBCOLOR(r: 16, g: 101, b: 182, alpha: 1)
        startTestButton.addTarget(self, action: #selector(startTestButtonAction(sender:)), for: .touchUpInside)
        self.view.addSubview(startTestButton)
        startTestButton.snp.makeConstraints { (make) in
            make.top.equalTo(tipBgView.snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
    }
}

extension SLungTestTipController {
    @objc func startTestButtonAction(sender:UIButton) {
        var messageStr = ""
        if todayTestNum == 0 {
            messageStr = NSLocalizedString("Are you ready for your first test", comment: "")
        }else if todayTestNum == 1 {
            messageStr = NSLocalizedString("Are you ready for the second test", comment: "")
        }else if todayTestNum == 2 {
            messageStr = NSLocalizedString("Are you ready for the third test", comment: "")
        }
        let alertVC = UIAlertController.alertAlert(title: NSLocalizedString("Are you ready", comment: ""), message: messageStr, okTitle: NSLocalizedString("YES", comment: ""), cancelTitle: NSLocalizedString("Wait a minute", comment: "")) {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.writeDataAction), userInfo: nil, repeats: true)
            let slungTestDateVC = SLungTestDateController()
            self.navigationController?.pushViewController(slungTestDateVC, animated: true)
        }
        self.present(alertVC, animated: true, completion: nil)
    }
}
