//
//  SLungTestDateController.swift
//  Sprayer
//
//  Created by fanglin on 2020/3/12.
//  Copyright © 2020 FangLin. All rights reserved.
//

import UIKit
import Toast_Swift

class SLungTestDateController: BaseViewController,CustemBBI {

    var scrollView:UIScrollView!
    
    var numResultLabel:UILabel!
    var firstChatView:FLChartView!
    var secondChatView:FLChartView!
    var thirdChatView:FLCustomChartView!
    
    var countOneLabel:UILabel!
    var countTwoLabel:UILabel = UILabel.init()
    var countThreeLabel:UILabel = UILabel.init()
    
    var startTestBtn:UIButton!
    
    //数据数组
    var dataList:[String] = []
    var xNumArr:[String] = []
    var thirdXNumArr:[String] = []
    var secondDataArr:[String] = []
    
    //数据
    var exhaleTime = ""
    var exhaleDataStr = ""
    var medicineId = ""
    
    //当天测试次数
    var todayTestNum:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.setNavTitle(NSLocalizedString("Pulmonary Function Test", comment: ""))
        self.setInterface()
        self.requestDataBlock()
        self.requestData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem = CustemNavItem.initWith(UIImage.init(named: "icon-back"), andTarget: self, andinfoStr: "first")
        NotificationCenter.default.addObserver(self, selector: #selector(refreshExhaleData), name: NSNotification.Name(rawValue: "refreshExhaleData"), object: nil)
    }
    
    func bbIdidClick(withName infoStr: String!) {
        if dataList.count == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopLungTrain"), object: nil, userInfo: nil)
            self.writeDataAction()
            self.navigationController?.popViewController(animated: true)
        }else {
            let alertVC = UIAlertController.alertAlert(title: "", message: NSLocalizedString("Do you want to save test results", comment: ""), okTitle: NSLocalizedString("Save", comment: ""), okComplete: {
                //加载动画
                self.view.makeToastActivity(.center)
                guard let exhaleDataSum = Double(self.secondDataArr[self.secondDataArr.count-1]) else {
                    return
                }
                DeviceRequestObject.shared.requestSaveExhaleData(medicineId: self.medicineId, exhaleData: self.exhaleDataStr, exhaleDataSum: exhaleDataSum, addDate: self.exhaleTime) { [weak self](code) in
                    if let weakself = self {
                        //隐藏加载动画
                        weakself.view.hideToastActivity()
                        if code == "200" {
                            LCProgressHUD.showSuccessText(NSLocalizedString("Upload success", comment: ""))
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopLungTrain"), object: nil, userInfo: nil)
                            weakself.writeDataAction()
                            weakself.navigationController?.popViewController(animated: true)
                        }else {
                            LCProgressHUD.showSuccessText(NSLocalizedString("Upload failed", comment: ""))
                        }
                    }
                }
            }, cancelTitle: NSLocalizedString("Return", comment: "")) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopLungTrain"), object: nil, userInfo: nil)
                self.writeDataAction()
                self.navigationController?.popViewController(animated: true)
            }
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @objc func refreshExhaleData(obj: Notification) {
        let objDict:[String:Any] = obj.object as! [String : Any]
        exhaleDataStr = objDict["exhaleData"] as! String
        medicineId = objDict["medicineId"] as! String
        exhaleTime = objDict["exhaleTime"] as! String
        let exhaleDataArr = exhaleDataStr.components(separatedBy: ",")
        self.XNumSetting(dataArr: exhaleDataArr)
    }
    
    func XNumSetting(dataArr:[String]) {
        dataList = []
        xNumArr = []
        thirdXNumArr = []
        secondDataArr = []
        
        //计算x轴的数值
        if dataArr.count%10 == 0{
            for i in 0...dataArr.count {
                xNumArr.append(String.init(format: "%.1f", Double(i)*0.1))
            }
        }else {
            let baseNum = (dataArr.count/10)+1
            for i in 0...(baseNum*10) {
                xNumArr.append(String.init(format: "%.1f", Double(i)*0.1))
            }
        }
        dataList = dataArr
        
        //计算thirdChatView 的数据
        var secondSum = 0.0
        for i in 0..<dataArr.count {
            guard let dataNum = Double(dataArr[i]) else {
                return
            }
            secondSum += dataNum
            secondDataArr.append(String.init(format: "%.3f", secondSum/600))
        }
        //计算thirdChatView 的y轴坐标数值
        guard let lastDataStr = secondDataArr.last else {
            return
        }
        guard let lastData = Double(lastDataStr) else {
            return
        }
        let maxNum = ceil(lastData)
        for i in 0...(Int(maxNum)*10) {
            thirdXNumArr.append(String.init(format: "%.1f", Double(i)*0.1))
        }
        self.setInterface()
    }
}

extension SLungTestDateController {
    @objc func writeDataAction() {
        let time = DisplayUtils.getNowTimestamp()
        let timeData = FLDrawDataTool.long(toNSData: time)
        BlueWriteData.stopLungFunctionTrain(timeData)
    }
    
    //请求当天的数据
    func requestData() {
        guard let dateTime = DisplayUtils.getTimestampData("YYYY-MM-dd") else {
            return
        }
        let startStr = String.init(format: "%@ 00:00:00", dateTime)
        let endStr = String.init(format: "%@ 23:59:59", dateTime)
        DeviceRequestObject.shared.requestGetNowExhaleData(addDate: startStr, endDate: endStr)
    }
    
    func requestDataBlock() {
        DeviceRequestObject.shared.requestGetNowExhaleDataSuc = {[weak self](dataList) in
            if let weakself = self {
                weakself.todayTestNum = dataList.count
                if dataList.count == 0 {
                    weakself.numResultLabel.text = NSLocalizedString("First Test Results", comment: "")
                    weakself.startTestBtn.setTitle(NSLocalizedString("Start The Second Test", comment: ""), for: .normal)
                }else if dataList.count == 1 {
                    weakself.numResultLabel.text = NSLocalizedString("Second Test Results", comment: "")
                    weakself.startTestBtn.setTitle(NSLocalizedString("Start The Third Test", comment: ""), for: .normal)
                }else if dataList.count == 2 {
                    weakself.numResultLabel.text = NSLocalizedString("Third Test Result", comment: "")
                    weakself.startTestBtn.setTitle(NSLocalizedString("End Test", comment: ""), for: .normal)
                }
            }
        }
    }
}

/// 初始化界面
extension SLungTestDateController {
    
    fileprivate func setInterface() {
        for view in self.view.subviews {
            view.removeFromSuperview()
            view.snp.removeConstraints()
        }

        numResultLabel = UILabel.init()
        numResultLabel.textColor = UIColor.black
        numResultLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.view.addSubview(numResultLabel)
        numResultLabel.snp.makeConstraints { (make) in
            make.top.equalTo(NEWNAVHEIGHT+CGFloat(10*IPONE_SCALE))
            make.centerX.equalToSuperview()
            make.height.equalTo(18)
        }
        
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: CGFloat(200*IPONE_SCALE)))
        scrollView.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.contentSize = CGSize.init(width: 2*SCREEN_WIDTH, height: CGFloat(200*IPONE_SCALE))
        scrollView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(numResultLabel.snp.bottom)
            make.height.equalTo(200*IPONE_SCALE)
        }
        
        var yNumArr:[String] = []
        for i in (0...6).reversed() {
            yNumArr.append(String.init(format: "%d", i*100))
        }
        firstChatView = FLChartView.init(frame: CGRect.init(x: CGFloat(10*IPONE_SCALE), y: 0, width: SCREEN_WIDTH-CGFloat(20*IPONE_SCALE), height: CGFloat(200*IPONE_SCALE)))
        firstChatView.backgroundColor = .clear
        firstChatView.titleOfXStr = "Sec"
        firstChatView.titleOfYStr = "SLM(L/min)"
        firstChatView.leftDataArr = dataList
        firstChatView.dataArrOfY = yNumArr
        if xNumArr.count == 0 {
            firstChatView.dataArrOfX = ["0","0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0","1.1","1.2","1.3","1.4","1.5","1.6","1.7","1.8","1.9","2.0","2.1","2.2","2.3","2.4","2.5","2.6","2.7","2.8","2.9","3.0","3.1","3.2","3.3","3.4","3.5","3.6","3.7","3.8","3.9","4.0","4.1","4.2","4.3","4.4","4.5","4.6","4.7","4.8","4.9","5.0"]//拿到X轴坐标
        }else {
            firstChatView.dataArrOfX = xNumArr
        }
        scrollView.addSubview(firstChatView)
//        firstChatView.snp.makeConstraints { (make) in
//            make.top.equalTo(numResultLabel.snp.bottom)
//            make.left.equalTo(10*IPONE_SCALE)
//            make.right.equalTo(-10*IPONE_SCALE)
//            make.height.equalTo(200*IPONE_SCALE)
//        }
        
        var secondYNumArr:[String] = []
        for i in (0...6).reversed() {
            secondYNumArr.append(String.init(format: "%d", i))
        }
        secondChatView = FLChartView.init(frame: CGRect.init(x: SCREEN_WIDTH+CGFloat(10*IPONE_SCALE), y: 0, width: SCREEN_WIDTH-CGFloat(20*IPONE_SCALE), height: CGFloat(200*IPONE_SCALE)))
        secondChatView.backgroundColor = .clear
        secondChatView.titleOfXStr = "Sec"
        secondChatView.titleOfYStr = "L"
        secondChatView.leftDataArr = secondDataArr
        secondChatView.dataArrOfY = secondYNumArr
        if xNumArr.count == 0 {
            secondChatView.dataArrOfX = ["0","0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0","1.1","1.2","1.3","1.4","1.5","1.6","1.7","1.8","1.9","2.0","2.1","2.2","2.3","2.4","2.5","2.6","2.7","2.8","2.9","3.0","3.1","3.2","3.3","3.4","3.5","3.6","3.7","3.8","3.9","4.0","4.1","4.2","4.3","4.4","4.5","4.6","4.7","4.8","4.9","5.0"]//拿到X轴坐标
        }else {
            secondChatView.dataArrOfX = xNumArr
        }
        scrollView.addSubview(secondChatView)
//        secondChatView.snp.makeConstraints { (make) in
//            make.top.equalTo(numResultLabel.snp.bottom)
//            make.left.equalTo(10*IPONE_SCALE)
//            make.right.equalTo(-10*IPONE_SCALE)
//            make.height.equalTo(200*IPONE_SCALE)
//        }
        
        thirdChatView = FLCustomChartView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH-CGFloat(20*IPONE_SCALE), height: CGFloat(200*IPONE_SCALE)))
        thirdChatView.backgroundColor = .clear
        thirdChatView.titleOfXStr = "L"
        thirdChatView.titleOfYStr = "SLM(L/min)"
        thirdChatView.yDataArr = dataList
        thirdChatView.xDataArr = secondDataArr
        thirdChatView.dataArrOfY = yNumArr
        if thirdXNumArr.count == 0 {
            thirdChatView.dataArrOfX = ["0","0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0","1.1","1.2","1.3","1.4","1.5","1.6","1.7","1.8","1.9","2.0","2.1","2.2","2.3","2.4","2.5","2.6","2.7","2.8","2.9","3.0","3.1","3.2","3.3","3.4","3.5","3.6","3.7","3.8","3.9","4.0","4.1","4.2","4.3","4.4","4.5","4.6","4.7","4.8","4.9","5.0"]//拿到X轴坐标
        }else {
            thirdChatView.dataArrOfX = thirdXNumArr
        }
        self.view.addSubview(thirdChatView)
        thirdChatView.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView.snp.bottom)
            make.left.equalTo(10*IPONE_SCALE)
            make.right.equalTo(-10*IPONE_SCALE)
            make.height.equalTo(200*IPONE_SCALE)
        }
        
        var FEVStr = 0.0
        if secondDataArr.count>0 {
            guard let maxNum = Double(secondDataArr[secondDataArr.count-1]) else {
                return
            }
            FEVStr = maxNum
        }else {
            FEVStr = 0.0
        }
        countOneLabel = UILabel.init()
        countOneLabel.text = "1、最大用力肺活量(FEV)：\(FEVStr)L"
        countOneLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        countOneLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(countOneLabel)
        countOneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(thirdChatView.snp.bottom).offset(20*IPONE_SCALE)
            make.left.equalTo(40*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
        }
        
        var FEV1Str = 0.0
        if secondDataArr.count > 10 {
            guard let maxNum = Double(secondDataArr[9]) else {
                return
            }
            FEV1Str = maxNum
        }else {
            guard let maxNum = Double(secondDataArr[secondDataArr.count-1]) else {
                return
            }
            FEV1Str = maxNum
        }
        countTwoLabel = UILabel.init()
        countTwoLabel.text = "2、第一秒最大呼氣量(FEV1)：\(FEV1Str)L"
        countTwoLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        countTwoLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(countTwoLabel)
        countTwoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countOneLabel.snp.bottom).offset(10*IPONE_SCALE)
            make.left.equalTo(40*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
        }
        
        var maxPEF = 0.0
        if dataList.count > 0 {
            guard var maxPEFNum = Double(dataList[0]) else {
                return
            }
            for value in dataList {
                guard let doubleValue = Double(value) else {
                    return
                }
                if maxPEFNum < doubleValue {
                    maxPEFNum = doubleValue
                }
            }
            maxPEF = maxPEFNum
        }else {
            maxPEF = 0.0
        }
        countThreeLabel = UILabel.init()
        countThreeLabel.text = "3、尖峰呼氣流速(PEF)：\(maxPEF)L/Min"
        countThreeLabel.textColor = HEXCOLOR(h: 0x333333, alpha: 1)
        countThreeLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(countThreeLabel)
        countThreeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(countTwoLabel.snp.bottom).offset(10*IPONE_SCALE)
            make.left.equalTo(40*IPONE_SCALE)
            make.height.equalTo(15*IPONE_SCALE)
        }
        
        startTestBtn = UIButton.init(type: .custom)
        startTestBtn.setTitleColor(.white, for: .normal)
        startTestBtn.backgroundColor = RGBCOLOR(r: 16, g: 101, b: 182, alpha: 1)
        startTestBtn.layer.cornerRadius = 7
        startTestBtn.layer.masksToBounds = true
        startTestBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        startTestBtn.addTarget(self, action: #selector(startTestBtnAction(sender:)), for: .touchUpInside)
        if dataList.count == 0 {
            startTestBtn.isEnabled = false
        }else {
            startTestBtn.isEnabled = true
        }
        self.view.addSubview(startTestBtn)
        startTestBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-(CGFloat(20*IPONE_SCALE)+IPHONEX_BH))
            make.width.equalTo(150)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        if todayTestNum == 0 {
            numResultLabel.text = NSLocalizedString("First Test Results", comment: "")
            startTestBtn.setTitle(NSLocalizedString("Start The Second Test", comment: ""), for: .normal)
        }else if todayTestNum == 1 {
            numResultLabel.text = NSLocalizedString("Second Test Results", comment: "")
            startTestBtn.setTitle(NSLocalizedString("Start The Third Test", comment: ""), for: .normal)
        }else if todayTestNum == 2 {
            numResultLabel.text = NSLocalizedString("Third Test Result", comment: "")
            startTestBtn.setTitle(NSLocalizedString("End Test", comment: ""), for: .normal)
        }
    }
}

extension SLungTestDateController {
    @objc func startTestBtnAction(sender:UIButton) {
        if todayTestNum == 0 {
            let alertVC = UIAlertController.alertAlert(title: NSLocalizedString("Save or not", comment: ""), message: NSLocalizedString("This test will be saved as your first test today", comment: ""), okTitle: NSLocalizedString("YES", comment: ""), cancelTitle: NSLocalizedString("Test Again", comment: "")) {
                guard let exhaleDataSum = Double(self.secondDataArr[self.secondDataArr.count-1]) else {
                    return
                }
                DeviceRequestObject.shared.requestSaveExhaleData(medicineId: self.medicineId, exhaleData: self.exhaleDataStr, exhaleDataSum: exhaleDataSum, addDate: self.exhaleTime) { [weak self](code) in
                    if let weakself = self {
                        //隐藏加载动画
                        weakself.view.hideToastActivity()
                        if code == "200" {
                            LCProgressHUD.showSuccessText(NSLocalizedString("Upload success", comment: ""))
                            weakself.dataList = []
                            weakself.xNumArr = []
                            weakself.thirdXNumArr = []
                            weakself.secondDataArr = []
                            weakself.setInterface()
                            weakself.requestData()
                        }else {
                            LCProgressHUD.showSuccessText(NSLocalizedString("Upload failed", comment: ""))
                        }
                    }
                }
            }
            self.present(alertVC, animated: true, completion: nil)
        }else if todayTestNum == 1 {
            let alertVC = UIAlertController.alertAlert(title: NSLocalizedString("Save or not", comment: ""), message: NSLocalizedString("This test will be saved as your second test today", comment: ""), okTitle: NSLocalizedString("YES", comment: ""), cancelTitle: NSLocalizedString("Test Again", comment: "")) {
                guard let exhaleDataSum = Double(self.secondDataArr[self.secondDataArr.count-1]) else {
                    return
                }
                DeviceRequestObject.shared.requestSaveExhaleData(medicineId: self.medicineId, exhaleData: self.exhaleDataStr, exhaleDataSum: exhaleDataSum, addDate: self.exhaleTime) { [weak self](code) in
                    if let weakself = self {
                        //隐藏加载动画
                        weakself.view.hideToastActivity()
                        if code == "200" {
                            LCProgressHUD.showSuccessText(NSLocalizedString("Upload success", comment: ""))
                            weakself.dataList = []
                            weakself.xNumArr = []
                            weakself.thirdXNumArr = []
                            weakself.secondDataArr = []
                            weakself.setInterface()
                            weakself.requestData()
                        }else {
                            LCProgressHUD.showSuccessText(NSLocalizedString("Upload failed", comment: ""))
                        }
                    }
                }
            }
            self.present(alertVC, animated: true, completion: nil)
        }else if todayTestNum == 2 {
            let alertVC = UIAlertController.alertAlert(title: NSLocalizedString("Save or not", comment: ""), message: NSLocalizedString("This test will be saved as your third test today", comment: ""), okTitle: NSLocalizedString("YES", comment: ""), cancelTitle: NSLocalizedString("Test Again", comment: "")) {
                guard let exhaleDataSum = Double(self.secondDataArr[self.secondDataArr.count-1]) else {
                    return
                }
                DeviceRequestObject.shared.requestSaveExhaleData(medicineId: self.medicineId, exhaleData: self.exhaleDataStr, exhaleDataSum: exhaleDataSum, addDate: self.exhaleTime) { [weak self](code) in
                    if let weakself = self {
                        //隐藏加载动画
                        weakself.view.hideToastActivity()
                        if code == "200" {
                            LCProgressHUD.showSuccessText(NSLocalizedString("Upload success", comment: ""))
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopLungTrain"), object: nil, userInfo: nil)
                            weakself.writeDataAction()
                            weakself.navigationController?.popViewController(animated: true)
                        }else {
                            LCProgressHUD.showSuccessText(NSLocalizedString("Upload failed", comment: ""))
                        }
                    }
                }
            }
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}
